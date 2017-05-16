unit BodyTypesQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  BodyTypesBranchQuery, ApplyQueryFrame, BodyTypesExcelDataModule3,
  QueryWithDataSourceUnit, BodiesQuery, BodyDataQuery, BodyVariationsQuery;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryBodyTypes2 = class(TQueryWithDataSource)
    qBodyVariations: TfrmApplyQuery;
    fdqUnusedBodyTypes: TFDQuery;
    qBodies: TfrmApplyQuery;
    qBodyData: TfrmApplyQuery;
    procedure FDQueryBodyType1Change(Sender: TField);
    procedure FDQueryBodyType2Change(Sender: TField);
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
    procedure FDQueryUpdateRecordOnClient(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
  private
    FInChange: Boolean;
    FQueryBodies: TQueryBodies;
    FQueryBodyData: TQueryBodyData;
    // FIndexFields: string;
    FQueryBodyTypesBranch: TQueryBodyTypesBranch;
    FQueryBodyVariations: TQueryBodyVariations;
    procedure DoAfterOpen(Sender: TObject);
    procedure DropUnusedBodyTypes;
    function GetBody: TField;
    function GetBodyData: TField;
    function GetIDBodyKind: TField;
    function GetIDProducer: TField;
    function GetImage: TField;
    function GetLandPattern: TField;
    function GetOutlineDrawing: TField;
    function GetQueryBodies: TQueryBodies;
    function GetQueryBodyData: TQueryBodyData;
    function GetQueryBodyVariations: TQueryBodyVariations;
    function GetVariations: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    property BodyData: TField read GetBodyData;
    property IDProducer: TField read GetIDProducer;
    property QueryBodies: TQueryBodies read GetQueryBodies;
    property QueryBodyData: TQueryBodyData read GetQueryBodyData;
    property QueryBodyVariations: TQueryBodyVariations read GetQueryBodyVariations;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CascadeDelete(const AIDMaster: Integer;
      const ADetailKeyFieldName: String); overload; override;
    function ConstructBodyKind(const APackage: String): string;
    function ConstructBodyType(const APackage: string): string;
    property Body: TField read GetBody;
    property IDBodyKind: TField read GetIDBodyKind;
    // TODO: LocateOrAppend
    // procedure LocateOrAppend(AIDParentBodyType: Integer;
    // const ABodyType1, ABodyType2, AOutlineDrawing, ALandPattern, AVariation,
    // AImage: string);
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property QueryBodyTypesBranch: TQueryBodyTypesBranch
      read FQueryBodyTypesBranch write FQueryBodyTypesBranch;
    property Variations: TField read GetVariations;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, RepositoryDataModule;

constructor TQueryBodyTypes2.Create(AOwner: TComponent);
begin
  inherited;
  FPKFieldName := 'IDS';
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  AutoTransaction := False;
end;

procedure TQueryBodyTypes2.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
  AIDS: string;
  m: TArray<String>;
  S: string;
begin
  AIDS := ASender.FieldByName(PKFieldName).AsString;
  if not AIDS.IsEmpty then
  begin
    // Почему-то иногда AID = 0
    m := AIDS.Split([',']);
    for S in m do
    begin
      AID := S.Trim.ToInteger();
      // Удаляем вариант корпуса
      qBodyVariations.DeleteRecord(AID);
    end;

    // Удаляем неиспользуемые типы корпусов
    DropUnusedBodyTypes;
  end;

end;

procedure TQueryBodyTypes2.ApplyInsert(ASender: TDataSet);
var
  ABody: TField;
  ABodyData: TField;
  AIDBodyKind: TField;
  AIDProducer: TField;
  AImage: TField;
  ALandPattern: TField;
  AOutlineDrawing: TField;
  AVariation: string;
  AVariations: TField;
  m: TArray<String>;
  S: string;
  SS: string;
begin
  ABody := ASender.FieldByName(Body.FieldName);
  AIDBodyKind := ASender.FieldByName(IDBodyKind.FieldName);
  ABodyData := ASender.FieldByName(IDBodyKind.FieldName);
  AIDProducer := ASender.FieldByName(IDProducer.FieldName);
  AOutlineDrawing := ASender.FieldByName(OutlineDrawing.FieldName);
  ALandPattern := ASender.FieldByName(LandPattern.FieldName);
  AVariations := ASender.FieldByName(Variations.FieldName);
  AImage := ASender.FieldByName(Image.FieldName);

  QueryBodies.LocateOrAppend(ABody.Value, IDBodyKind.Value);
  QueryBodyData.LocateOrAppend(ABodyData.Value, AIDProducer.Value, QueryBodies.PKValue);

  // Анализируем варианты корпусов
  S := AVariations.AsString.Trim;
  m := S.Split(',');
  for SS in m do
  begin
    AVariation := SS.Trim;
    if AVariation. then

  end;
  QueryBodyVariations.Append(QueryBodyData.PKValue, );
end;

procedure TQueryBodyTypes2.ApplyUpdate(ASender: TDataSet);
begin
end;

procedure TQueryBodyTypes2.CascadeDelete(const AIDMaster: Integer;
  const ADetailKeyFieldName: String);
var
  E: TFDUpdateRecordEvent;
begin
  // каскадное удаление уже реализовано на стороне сервера
  // Просто удалим эти записи с клиента ничего не сохраняя на стороне сервера

  E := FDQuery.OnUpdateRecord;
  try
    FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;
    inherited;
  finally
    FDQuery.OnUpdateRecord := E;
  end;
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

procedure TQueryBodyTypes2.DoAfterOpen(Sender: TObject);
begin
  // Подписываемся на событие об изменении значения поля
  // BodyType1.OnChange := FDQueryBodyType1Change;
  // BodyType2.OnChange := FDQueryBodyType2Change;
end;

procedure TQueryBodyTypes2.DropUnusedBodyTypes;
begin
  while True do
  begin
    fdqUnusedBodyTypes.Close;
    fdqUnusedBodyTypes.Open;

    if fdqUnusedBodyTypes.RecordCount = 0 then
      break;

    while not fdqUnusedBodyTypes.Eof do
    begin
      //qBodyTypes.DeleteRecord(fdqUnusedBodyTypes['ID']);
      fdqUnusedBodyTypes.Next;
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

procedure TQueryBodyTypes2.FDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
{
  var
  ABodyType1: TField;
  ABodyType2: TField;
  AID: Integer;
  AIDS: String;
  AID1: TField;
  AID2: TField;
  AIDBodyType: TField;
  AIDParentBodyType1: TField;
  AIDParentBodyType2: TField;
  m: TArray<String>;
  RH: TRecordHolder;
  S: string;
}
begin
  inherited;
  {
    // Если произошло удаление
    if ARequest = arDelete then
    begin
    AIDS := ASender.FieldByName(PKFieldName).AsString;
    if not AIDS.IsEmpty then
    begin
    // Почему-то иногда AID = 0

    m := AIDS.Split([',']);
    for S in m do
    begin
    AID := S.Trim.ToInteger();
    // Удаляем вариант корпуса
    qBodyVariations.DeleteRecord(AID);
    end;

    // Удаляем неиспользуемые типы корпусов
    DropUnusedBodyTypes;
    end;
    end
    else if ARequest in [arUpdate, arInsert] then
    begin
    ABodyType1 := ASender.FieldByName(BodyType1.FieldName);
    AIDParentBodyType1 := ASender.FieldByName(IDParentBodyType1.FieldName);
    AID1 := ASender.FieldByName(ID1.FieldName);
    ABodyType2 := ASender.FieldByName(BodyType2.FieldName);
    AIDParentBodyType2 := ASender.FieldByName(IDParentBodyType2.FieldName);
    AID2 := ASender.FieldByName(ID2.FieldName);
    AIDBodyType := ASender.FieldByName(IDBodyType.FieldName);

    // Если указан корпус
    if not ABodyType1.AsString.Trim.IsEmpty then
    begin
    FInChange := True;
    try
    // Загружаем все возможные варианты корпуса для редактируемого типа корпуса
    QueryBodyTypesBranch.Load(AIDParentBodyType1.AsInteger);
    // Ищем или добавляем корпус
    QueryBodyTypesBranch.LocateOrAppend(ABodyType1.AsString, 1);
    AID1.Value := QueryBodyTypesBranch.PKValue;
    AID := AID1.Value;

    // Если указаны корпусные данные
    if not ABodyType2.AsString.Trim.IsEmpty then
    begin
    // Загружаем все возможные варианты корпусных данных
    QueryBodyTypesBranch.Load(AID1.Value);

    // Ищем или добавляем корпусные данные
    QueryBodyTypesBranch.LocateOrAppend(ABodyType2.AsString, 2);
    AIDParentBodyType2.AsInteger := AID1.AsInteger;
    AID2.AsInteger := QueryBodyTypesBranch.PKValue;
    AID := AID2.AsInteger;
    end;

    finally
    FInChange := False;
    end;
    end
    else
    begin
    AID := AIDParentBodyType1.AsInteger;
    end;

    // привязываем вариант корпуса к типу корпуса, корпусу или корпусным данным
    AIDBodyType.AsInteger := AID;

    RH := TRecordHolder.Create();
    try
    RH.Attach(ASender);

    // Обновление данных
    if ARequest = arUpdate then
    begin
    qBodyVariations.UpdateRecord(RH);
    end;

    // Обновление данных
    if ARequest = arInsert then
    begin
    // Вставляем запись
    qBodyVariations.InsertRecord(RH);
    // Обновляем первичный ключ
    AID := qBodyVariations.FDQuery.FieldByName(PKFieldName).AsInteger;
    ASender.FieldByName(PKFieldName).AsInteger := AID;
    // Заплатка.
    PostMessage(Handle, WM_arInsert, ASender[PKFieldName], 0);
    end;

    finally
    FreeAndNil(RH);
    end;

    end;
  }
  AAction := eaApplied;
end;

procedure TQueryBodyTypes2.FDQueryUpdateRecordOnClient(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TQueryBodyTypes2.GetBody: TField;
begin
  Result := Field('Body');
end;

function TQueryBodyTypes2.GetBodyData: TField;
begin
  Result := Field('BodyData');
end;

function TQueryBodyTypes2.GetIDBodyKind: TField;
begin
  Result := Field('IDBodyKind');
end;

function TQueryBodyTypes2.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryBodyTypes2.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryBodyTypes2.GetLandPattern: TField;
begin
  Result := Field('LandPattern');
end;

function TQueryBodyTypes2.GetOutlineDrawing: TField;
begin
  Result := Field('OutlineDrawing');
end;

function TQueryBodyTypes2.GetQueryBodies: TQueryBodies;
begin
  if FQueryBodies = nil then
  begin
    FQueryBodies := TQueryBodies.Create(Self);
    FQueryBodies.FDQuery.Open();
  end;
  Result := FQueryBodies;
end;

function TQueryBodyTypes2.GetQueryBodyData: TQueryBodyData;
begin
  if FQueryBodyData = nil then
  begin
    FQueryBodyData := TQueryBodyData.Create(Self);
    FQueryBodyData.FDQuery.Open;
  end;

  Result := FQueryBodyData;
end;

function TQueryBodyTypes2.GetQueryBodyVariations: TQueryBodyVariations;
begin
  if FQueryBodyVariations = nil then
  begin
    FQueryBodyVariations := TQueryBodyVariations.Create(Self);
    FQueryBodyVariations.FDQuery.Open;
  end;
  Result := FQueryBodyVariations;
end;

function TQueryBodyTypes2.GetVariations: TField;
begin
  Result := Field('Variations');
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
