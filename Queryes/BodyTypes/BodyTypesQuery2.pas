unit BodyTypesQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, BodyTypesExcelDataModule,
  BodiesQuery, BodyDataQuery, BodyVariationsQuery, BodyTypesBaseQuery,
  DocFieldInfo, System.IOUtils, JEDECQuery, System.Generics.Collections,
  BodyVariationJedecQuery, BodyOptionsQuery, BodyVariationOptionQuery;

type
  TQueryBodyTypes2 = class(TQueryBodyTypesBase)
    procedure FDQueryBodyType1Change(Sender: TField);
    procedure FDQueryBodyType2Change(Sender: TField);
  private
    FShowDuplicate: Boolean;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsertOrUpdate;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
  public
    function ConstructBodyKind(const APackage: String): string;
    function ConstructBodyType(const APackage: string): string;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    procedure LoadJEDEC(const AFileName: String; Add: Boolean);
    procedure LocateOrAppend(AIDBodyKind: Integer;
      const ABody, ABodyData: String; AIDProducer: Integer;
      const AOutlineDrawing, ALandPattern, AVariation, AImage: string);
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, RepositoryDataModule, System.StrUtils,
  StrHelper;

procedure TQueryBodyTypes2.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AID: Integer;
  AIDS: string;
  m: TArray<String>;
  S: string;
begin
  Assert(ASender = FDQuery);
  AIDS := W.DeletedPKValue;

  // Почему-то иногда AID = 0
  if AIDS.IsEmpty then
    Exit;

  m := AIDS.Split([',']);
  for S in m do
  begin
    AID := S.Trim.ToInteger();
    // Удаляем вариант корпуса
    QueryBodyVariations.W.LocateByPKAndDelete(AID);
  end;

  // Удаляем неиспользуемые корпуса
  DropUnusedBodies;
end;

procedure TQueryBodyTypes2.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

procedure TQueryBodyTypes2.ApplyInsertOrUpdate;
var
  AID: string;
  AIDSS: string;
  AOLDIDS: string;
  I: Integer;
  L: TStringList;
  m: TArray<String>;
begin
  QueryBodies.LocateOrAppend(W.Body.F.Value, W.IDBodyKind.F.Value);
  QueryBodyData.LocateOrAppend(W.BodyData.F.Value, W.IDProducer.F.Value,
    QueryBodies.PK.Value);

  AIDSS := '';
  // Анализируем варианты корпусов
  L := TStringList.Create;
  try
    L.Delimiter := ',';
    L.StrictDelimiter := True;
    L.DelimitedText := W.Variations.F.AsString.Trim;

    // Убираем пустые строки
    for I := L.Count - 1 downto 0 do
      if L[I].Trim.IsEmpty then
        L.Delete(I)
      else
        L[I] := L[I].Trim;

    // Если никакого варианта корпуса нет
    if L.Count = 0 then
    begin
      // Добавляем пустой вариант корпуса
      L.Add('');
    end;

    AOLDIDS := ',' + W.IDS.F.AsString.Replace(' ', '') + ',';

    // Цикл по всем вариантам корпуса
    for I := 0 to L.Count - 1 do
    begin
      QueryBodyVariations.LocateOrAppend(QueryBodyData.PK.Value,
        W.OutlineDrawing.F.AsString, W.LandPattern.F.AsString, L[I],
        W.Image.F.AsString);

      AID := QueryBodyVariations.PK.AsString;
      Assert(not AID.IsEmpty);

      // Удаляем этот идентификатор из старых
      AOLDIDS := AOLDIDS.Replace(',' + AID + ',', ',');

      AIDSS := AIDSS + IfThen(AIDSS.IsEmpty, '', ', ');
      AIDSS := AIDSS + AID;

      UpdateJEDEC;
      UpdateOptions;
    end;

    AOLDIDS := AOLDIDS.Trim([',']);

    // Если остались какие-то старые варианты корпусов
    if not AOLDIDS.IsEmpty then
    begin
      m := AOLDIDS.Split([',']);
      for AID in m do
        QueryBodyVariations.W.LocateByPKAndDelete(AID);
    end;

    W.IDS.F.Value := AIDSS;

    // Заполняем части наименования
    SetMySplitDataValues(QueryBodies.FDQuery, W.Body.FieldName);
    // Заполняем части корпусных данных
    SetMySplitDataValues(QueryBodyData.FDQuery, W.BodyData.FieldName);

    W.IDBodyData.F.Value := QueryBodyData.PK.Value;
    W.IDBody.F.Value := QueryBodies.PK.Value;

  finally
    FreeAndNil(L);
  end;

end;

procedure TQueryBodyTypes2.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

function TQueryBodyTypes2.ConstructBodyKind(const APackage: String): string;
var
  m: TArray<String>;
begin
  Assert(not APackage.IsEmpty);
  m := APackage.Split([';']);
  if Length(m) = 1 then
    Result := APackage
  else
  begin
    Result := m[0].Trim([',']);
    if Result.IsEmpty then
      Result := 'Новый';
  end;
end;

function TQueryBodyTypes2.ConstructBodyType(const APackage: string): string;
var
  AStartIndex: Integer;
  m: TArray<String>;
  S: string;
begin
  Assert(not APackage.IsEmpty);
  m := APackage.Split([';']);
  if Length(m) = 1 then
    Result := APackage
  else
  begin
    Result := m[0].Trim([',']);
    if Result.IsEmpty then
      Result := 'Новый';
    S := m[1];
    AStartIndex := 0;
    while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      AStartIndex) = AStartIndex do
      Inc(AStartIndex);

    if AStartIndex > 0 then
    begin
      S := S.Substring(0, AStartIndex);
      Result := Format('%s/%s', [Result, S]);
    end;
  end;
end;

procedure TQueryBodyTypes2.FDQueryBodyType1Change(Sender: TField);
{
  var
  OK: Boolean;
  AID: Integer;
}
begin
  {
    inherited;

    if FInChange then
    Exit;

    FInChange := True;
    try
    // Загружаем все возможные варианты корпуса для редактируемого типа корпуса
    QueryBodyTypesBranch.Load(IDParentBodyType1.Value);
    OK := QueryBodyTypesBranch.LocateBodyType(Sender.Value);
    if OK then
    begin
    if ID1.Value <> QueryBodyTypesBranch.PKValue then
    begin
    ID1.Value := QueryBodyTypesBranch.PKValue;
    // Загружаем все возможные варианты корпуса для редактируемого типа корпуса
    QueryBodyTypesBranch.Load(QueryBodyTypesBranch.PKValue);
    if QueryBodyTypesBranch.FDQuery.RecordCount > 0 then
    begin
    IDParentBodyType2.AsInteger := ID1.AsInteger;
    ID2.AsInteger := QueryBodyTypesBranch.PKValue;
    BodyType2.AsString := QueryBodyTypesBranch.BodyType.AsString;
    AID := ID2.AsInteger;
    end
    else
    begin
    IDParentBodyType2.Value := null;
    ID2.Value := null;
    BodyType2.Value := null;

    AID := ID1.AsInteger;
    end;

    // Меняем ссылку на тип корпуса у варианта корпуса
    IDBodyType.AsInteger := AID;
    end;
    end
    else
    begin
    ID1.Value := null;
    IDParentBodyType2.Value := null;
    ID2.Value := null;
    BodyType2.Value := null;
    IDBodyType.Value := null;
    end;
    finally
    FInChange := False;
    end;
  }
end;

procedure TQueryBodyTypes2.FDQueryBodyType2Change(Sender: TField);
{
  var
  AID: Integer;
  // OK: Boolean;
}
begin
  {
    inherited;

    // Если сейчас происходит изменение BodyType1
    if FInChange then
    Exit;

    if ID1.IsNull then
    Exit;

    FInChange := True;
    try

    QueryBodyTypesBranch.Load(ID1.Value);
    if QueryBodyTypesBranch.LocateBodyType(Sender.Value) then
    begin
    IDParentBodyType2.AsInteger := ID1.AsInteger;
    ID2.AsInteger := QueryBodyTypesBranch.PKValue;
    BodyType2.AsString := QueryBodyTypesBranch.BodyType.AsString;
    AID := ID2.AsInteger;

    // Меняем ссылку на тип корпуса у варианта корпуса
    IDBodyType.AsInteger := AID;
    end;
    finally
    FInChange := False;
    end;
  }
end;

procedure TQueryBodyTypes2.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  OK: Boolean;
  S: string;
begin
  Assert(not AFileName.IsEmpty);

  // В БД храним имя файла без расширения и всё
  S := TPath.GetFileNameWithoutExtension(AFileName);
  OK := W.TryEdit;
  W.Field(ADocFieldInfo.FieldName).AsString := S;
  if OK then
    W.TryPost;
end;

procedure TQueryBodyTypes2.LoadJEDEC(const AFileName: String; Add: Boolean);
var
  OK: Boolean;
  S: string;
begin
  Assert(not AFileName.IsEmpty);

  S := '';
  if Add and (not W.JEDEC.F.AsString.IsEmpty) then
    S := W.JEDEC.F.AsString + '; ';

  // В БД храним имя файла без расширения и всё
  S := S + TPath.GetFileNameWithoutExtension(AFileName);

  OK := W.TryEdit;
  W.JEDEC.F.AsString := S;
  if OK then
    W.TryPost;
end;

procedure TQueryBodyTypes2.LocateOrAppend(AIDBodyKind: Integer;
  const ABody, ABodyData: String; AIDProducer: Integer;
  const AOutlineDrawing, ALandPattern, AVariation, AImage: string);
begin
end;

procedure TQueryBodyTypes2.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    // Получаем базовый запрос
    ASQL := SQL;
    if FShowDuplicate then
    begin
      ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
      ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
    end;

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
  end;
end;

// TODO: LocateOrAppend
// procedure TQueryBodyTypes2.LocateOrAppend(AIDParentBodyType: Integer;
// const ABodyType1, ABodyType2, AOutlineDrawing, ALandPattern, AVariation,
// AImage: string);
// var
// AKeyFields: string;
// OK: Boolean;
// begin
//
// AKeyFields := Format('%s;%s;%s;%s', [IDParentBodyType1.FieldName,
// BodyType1.FieldName, BodyType2.FieldName, Variations.FieldName]);
//
// OK := FDQuery.LocateEx(AKeyFields, VarArrayOf([AIDParentBodyType, ABodyType1,
// ABodyType2, AVariation]), []);
//
// if not OK then
// begin
// FDQuery.Append;
// IDParentBodyType1.Value := AIDParentBodyType;
// BodyType1.Value := ABodyType1;
// BodyType2.Value := ABodyType2;
// Variations.Value := AVariation;
// end
// else
// FDQuery.Edit;
//
// OutlineDrawing.Value := AOutlineDrawing;
// LandPattern.Value := ALandPattern;
// Image.Value := AImage;
//
// FDQuery.Post;
//
// end;

{
  procedure TQueryBodyTypes2.LocateOrAppend(AValue: string);
  var
  OK: Boolean;
  begin
  OK := FDQuery.LocateEx(IDParentBodyType1.FieldName, AValue, []);

  if not OK then
  AddNewValue(AValue);
  end;
}
end.
