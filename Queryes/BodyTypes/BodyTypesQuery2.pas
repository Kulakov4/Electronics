unit BodyTypesQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, BodyTypesExcelDataModule, QueryWithDataSourceUnit,
  BodiesQuery, BodyDataQuery, BodyVariationsQuery, BodyTypesBaseQuery;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryBodyTypes2 = class(TQueryBodyTypesBase)
    fdqBase: TFDQuery;
    procedure FDQueryBodyType1Change(Sender: TField);
    procedure FDQueryBodyType2Change(Sender: TField);
  private
    FIDS: string;
    FShowDuplicate: Boolean;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyInsertOrUpdate;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    procedure DoBeforeDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function ConstructBodyKind(const APackage: String): string;
    function ConstructBodyType(const APackage: string): string;
    procedure LocateOrAppend(AIDBodyKind: Integer; const ABody, ABodyData: String;
        AIDProducer: Integer; const AOutlineDrawing, ALandPattern, AVariation,
        AImage: string);
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, RepositoryDataModule, System.StrUtils,
  StrHelper;

constructor TQueryBodyTypes2.Create(AOwner: TComponent);
begin
  inherited;
  // Копируем базовый запрос и параметры
  AssignFrom(fdqBase);

  TNotifyEventWrap.Create(BeforeDelete, DoBeforeDelete, FEventList);
end;

procedure TQueryBodyTypes2.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
  AIDS: string;
  m: TArray<String>;
  S: string;
begin
  Assert(ASender = FDQuery);
  AIDS := FIDS;

  if not AIDS.IsEmpty then
  begin
    // Почему-то иногда AID = 0
    m := AIDS.Split([',']);
    for S in m do
    begin
      AID := S.Trim.ToInteger();
      // Удаляем вариант корпуса
      QueryBodyVariations.LocateByPKAndDelete(AID);
    end;

    // Удаляем неиспользуемые корпуса
    DropUnusedBodies;
  end;

end;

procedure TQueryBodyTypes2.ApplyInsert(ASender: TDataSet);
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
  QueryBodies.LocateOrAppend(Body.Value, IDBodyKind.Value);
  QueryBodyData.LocateOrAppend(BodyData.Value, IDProducer.Value,
    QueryBodies.PK.Value);

  AIDSS := '';
  // Анализируем варианты корпусов
  L := TStringList.Create;
  try
    L.Delimiter := ',';
    L.StrictDelimiter := True;
    L.DelimitedText := Variations.AsString.Trim;

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

    AOLDIDS := ','+IDS.AsString.Replace(' ', '')+',';

    for I := 0 to L.Count - 1 do
    begin
      QueryBodyVariations.LocateOrAppend(QueryBodyData.PK.Value,
        OutlineDrawing.AsString, LandPattern.AsString, L[I], Image.AsString);
      AID := QueryBodyVariations.PK.AsString;
      Assert(not AID.IsEmpty);

      // Удаляем этот идентификатор из старых
      AOLDIDS := AOLDIDS.Replace(','+AID+',', ',');

      AIDSS := AIDSS + IfThen(AIDSS.IsEmpty, '', ', ');
      AIDSS := AIDSS + AID;
    end;

    AOldIDS := AOldIDS.Trim([',']);

    // Если остались какие-то старые варианты корпусов
    if not AOldIDS.IsEmpty then
    begin
      m := AOldIDS.Split([',']);
      for AID in m do
        QueryBodyVariations.LocateByPKAndDelete(AID);
    end;

    IDS.Value := AIDSS;
    IDS.NewValue := AIDSS;
    Body0.Value := QueryBodies.Body0.Value;
    Body1.Value := QueryBodies.Body1.Value;
    Body2.Value := QueryBodies.Body2.Value;
    Body3.Value := QueryBodies.Body3.Value;
    Body4.Value := QueryBodies.Body4.Value;
    Body5.Value := QueryBodies.Body5.Value;

    IDBodyData.Value := QueryBodyData.PK.Value;
    IDBody.Value := QueryBodies.PK.Value;

  finally
    FreeAndNil(L);
  end;

end;

procedure TQueryBodyTypes2.ApplyUpdate(ASender: TDataSet);
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

procedure TQueryBodyTypes2.DoAfterInsertMessage(var Message: TMessage);
var
  AID: Integer;
begin
  AID := Message.WParam;

  if LocateByPK(AID) then
  begin
    FDQuery.Edit;
    FDQuery.Post;
  end;
end;

procedure TQueryBodyTypes2.DoBeforeDelete(Sender: TObject);
begin
  FIDS := IDS.AsString
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

procedure TQueryBodyTypes2.LocateOrAppend(AIDBodyKind: Integer; const ABody,
    ABodyData: String; AIDProducer: Integer; const AOutlineDrawing,
    ALandPattern, AVariation, AImage: string);
begin
end;

procedure TQueryBodyTypes2.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDuplicate then
    begin
      ASQL := Replace(ASQL, '', '/* ShowDuplicate');
      ASQL := Replace(ASQL, '', 'ShowDuplicate */');
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
