unit ComponentsExGroupUnit2;

interface

uses
  BaseComponentsGroupUnit2, CategoryParametersGroupUnit2,
  CategoryParametersQuery2, Data.DB, NotifyEvents, System.Classes,
  System.Contnrs, FireDAC.Stan.Option, FireDAC.Stan.Intf,
  System.Generics.Collections, ComponentsExQuery, FamilyExQuery,
  ProductParametersQuery, CustomComponentsQuery;

type
  TComponentsExGroup2 = class(TBaseComponentsGroup2)
    procedure OnFDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    FAllParameterFields: TDictionary<Integer, String>;
    FApplyUpdateEvents: TObjectList;
    FCatParamsGroup: TCategoryParametersGroup2;
    FClientCount: Integer;
    FFieldIndex: Integer;
    FFreeFields: TList<String>;
    FMark: string;
    FOnParamOrderChange: TNotifyEventsEx;
    FqComponentsEx: TQueryComponentsEx;
    FqFamilyEx: TQueryFamilyEx;
    FqProductParameters: TQueryProductParameters;
  const
    FFieldPrefix: string = 'Field';
    FFreeFieldCount = 20;
    procedure ApplyUpdate(AQueryCustomComponents: TQueryCustomComponents; AFamily:
        Boolean);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoOnApplyUpdateComponent(Sender: TObject);
    procedure DoOnApplyUpdateFamily(Sender: TObject);
    function GetNextFieldName: String;
    function GetqCategoryParameters: TQueryCategoryParameters2;
    function GetqComponentsEx: TQueryComponentsEx;
    function GetqFamilyEx: TQueryFamilyEx;
    function GetqProductParameters: TQueryProductParameters;
    procedure UpdateParameterValue(AComponentID: Integer; const AParamSubParamID:
        Integer; const AVaramValue: String);
  protected
    // TODO: ClearUpdateCount
    procedure LoadParameterValues;
    property qCategoryParameters: TQueryCategoryParameters2 read
        GetqCategoryParameters;
    property qProductParameters: TQueryProductParameters read GetqProductParameters;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient;
    procedure DecClient;
    function GetIDParameter(const AFieldName: String): Integer;
    procedure TryRefresh;
    procedure UpdateFields;
    property AllParameterFields: TDictionary<Integer, String> read
        FAllParameterFields;
    property CatParamsGroup: TCategoryParametersGroup2 read FCatParamsGroup;
    property Mark: string read FMark;
    property qComponentsEx: TQueryComponentsEx read GetqComponentsEx;
    property qFamilyEx: TQueryFamilyEx read GetqFamilyEx;
    property OnParamOrderChange: TNotifyEventsEx read FOnParamOrderChange;
  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, DBRecordHolder;

{ TfrmComponentsMasterDetail }

constructor TComponentsExGroup2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAllParameterFields := TDictionary<Integer, String>.Create();

  FApplyUpdateEvents := TObjectList.Create;

  FMark := '!';

  FCatParamsGroup := TCategoryParametersGroup2.Create(Self);

  // ������� ����� ��������� ����������, ����� ��� �������� ��������� ����� ������� � ���� ���������
  // ���������� � ��������� �� ������� ��� �������-���������� ������� ��� ��� �������� ���������
  QList.Add(qComponentsEx);
  QList.Add(qFamilyEx);

  TNotifyEventWrap.Create(qFamilyEx.W.BeforeOpen, DoBeforeOpen, EventList);
  TNotifyEventWrap.Create(qComponentsEx.W.BeforeOpen, DoBeforeOpen, EventList);
  TNotifyEventWrap.Create(qFamilyEx.W.AfterOpen, DoAfterOpen, EventList);

  FClientCount := 1;
  DecClient; // ������������ ��������� ����������

  FOnParamOrderChange := TNotifyEventsEx.Create(Self);
  FFreeFields := TList<String>.Create;
end;

destructor TComponentsExGroup2.Destroy;
begin
  FreeAndNil(FOnParamOrderChange);

  FreeAndNil(FAllParameterFields);
  FreeAndNil(FApplyUpdateEvents);
  FreeAndNil(FFreeFields);
  inherited;
end;

procedure TComponentsExGroup2.AddClient;
begin
  Inc(FClientCount);

  // ���� ����� �������������� ��������
  if (FClientCount > 0) then
  begin
    // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
    qComponentsEx.Lock := False;
    qFamilyEx.Lock := False;
  end;

end;

procedure TComponentsExGroup2.ApplyUpdate(AQueryCustomComponents :
    TQueryCustomComponents; AFamily: Boolean);
var
  // AQueryCustomComponents: TQueryCustomComponents;
  AField: TField;
  AFieldName: String;
  AParamSubParamID: Integer;
  // ADataSet: TFDQuery;
  // ANewValue: String;
  // AOldValue: String;
begin
  // AQueryCustomComponents := Sender as TQueryCustomComponents;

  // ADataSet := AQueryCustomComponents.FDQuery;
  Assert(AQueryCustomComponents.RecordHolder <> nil);

  // ���� �� ���� ����������� �����

  CatParamsGroup.qCategoryParameters.FDQuery.First;
  while not CatParamsGroup.qCategoryParameters.FDQuery.Eof do
  begin
    AParamSubParamID := CatParamsGroup.qCategoryParameters.
      W.ParamSubParamId.F.AsInteger;
    AFieldName := AllParameterFields[AParamSubParamID];
    AField := AQueryCustomComponents.W.Field(AFieldName);


    // AField.OldValue <> AField.Value ������-�� �� ��������
    // AOldValue := VarToStrDef(AQueryCustomComponents.RecordHolder.Field[AFieldName], '');
    // ANewValue := VarToStrDef(AField.Value, '');

    // ���� �������� ������� ��������� ����������
    if AQueryCustomComponents.RecordHolder.Field[AFieldName] <> AField.Value
    then
    begin
      // ��������� �������� ��������� �� �������
      UpdateParameterValue(AQueryCustomComponents.W.PK.AsInteger,
        AParamSubParamID, AField.AsString);
    end;
    // ��������� � ���������� ������������
    CatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup2.DecClient;
begin
  Dec(FClientCount);
  Assert(FClientCount >= 0);

  if FClientCount = 0 then
  begin
    qComponentsEx.Lock := True;
    qFamilyEx.Lock := True;
  end;
end;

procedure TComponentsExGroup2.DoAfterOpen(Sender: TObject);
begin
  LoadParameterValues;
end;

procedure TComponentsExGroup2.DoBeforeOpen(Sender: TObject);
var
  AData: TQueryCustomComponents;
  AFDQuery: TFDQuery;
  AFieldName: String;
  AFieldType: TFieldType;
  AParamSubParamID: Integer;
  ASize: Integer;
  I: Integer;
begin
  // ������� ������� ����������
  FAllParameterFields.Clear;
  // ������� ������ "���������" �����
  FFreeFields.Clear;

  AData := Sender as TQueryCustomComponents;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  // ��������� �������� �����
  AFDQuery.FieldDefs.Update;

  FFieldIndex := 0;
  AFieldType := ftWideString;
  ASize := 200;
  // � ������ ���������� ����� ��������� ��������� (�������, ���������)
  FCatParamsGroup.qCategoryParameters.Load(AData.ParentValue, True);
  FCatParamsGroup.qCategoryParameters.FDQuery.First;
  while not FCatParamsGroup.qCategoryParameters.FDQuery.Eof do
  begin
    AParamSubParamID := FCatParamsGroup.qCategoryParameters.
      W.ParamSubParamId.F.AsInteger;
    // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
    if not AData.ParameterFields.ContainsKey(AParamSubParamID) then
    begin
      // �������� ���� �� ��������� ������
      AFieldName := GetNextFieldName; // GetFieldName(AParamSubParamId);
      // ��������� ��������� ����
      AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
      FAllParameterFields.Add(AParamSubParamID, AFieldName);
    end
    else
      FAllParameterFields.Add(AParamSubParamID,
        AData.ParameterFields[AParamSubParamID]);

    FCatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;

  // ��������� ��������� ���������� ��������� �����
  for I := 0 to FFreeFieldCount - 1 do
  begin
    AFieldName := GetNextFieldName;
    // ��������� ��������� ����
    AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
    FFreeFields.Add(AFieldName);
  end;

  // ������ ����
  AData.W.CreateDefaultFields(False);

  FCatParamsGroup.qCategoryParameters.FDQuery.First;
  while not FCatParamsGroup.qCategoryParameters.FDQuery.Eof do
  begin
    AParamSubParamID := FCatParamsGroup.qCategoryParameters.
      W.ParamSubParamId.F.AsInteger;
    if not AData.ParameterFields.ContainsKey(AParamSubParamID) then
    begin
      AFieldName := FAllParameterFields[AParamSubParamID];
      AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FCatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;

  // �������� ��������� ���� ��� ��������� �����������
  for AFieldName in FFreeFields do
  begin
    AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
  end;

end;

procedure TComponentsExGroup2.DoOnApplyUpdateComponent(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, False);
end;

procedure TComponentsExGroup2.DoOnApplyUpdateFamily(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, True);
end;

function TComponentsExGroup2.GetIDParameter(const AFieldName: String): Integer;
var
  S: string;
begin
  S := AFieldName.Remove(0, FFieldPrefix.Length);
  Result := S.ToInteger();
end;

function TComponentsExGroup2.GetNextFieldName: String;
begin
  Inc(FFieldIndex);
  Result := Format('%s_%d', [FFieldPrefix, FFieldIndex]);
end;

function TComponentsExGroup2.GetqCategoryParameters: TQueryCategoryParameters2;
begin
  Result := CatParamsGroup.qCategoryParameters;
end;

function TComponentsExGroup2.GetqComponentsEx: TQueryComponentsEx;
begin
  if FqComponentsEx = nil then
    FqComponentsEx := TQueryComponentsEx.Create(Self);

  Result := FqComponentsEx;
end;

function TComponentsExGroup2.GetqFamilyEx: TQueryFamilyEx;
begin
  if FqFamilyEx = nil then
    FqFamilyEx := TQueryFamilyEx.Create(Self);
  Result := FqFamilyEx;
end;

function TComponentsExGroup2.GetqProductParameters: TQueryProductParameters;
begin
  if FqProductParameters = nil then
    FqProductParameters := TQueryProductParameters.Create(Self);

  Result := FqProductParameters;
end;

procedure TComponentsExGroup2.LoadParameterValues;
var
  AField: TField;
  qryComponents: TQueryCustomComponents;
  AFieldName: String;
  ANewValue: string;
  AParamSubParamID: Integer;
  AValue: string;
  S: string;
begin
  // �� ����� �������� �� �� ������ � �� ��������� �� �����
  FApplyUpdateEvents.Clear;
  qFamilyEx.SaveValuesAfterEdit := False;
  qComponentsEx.SaveValuesAfterEdit := False;
//  qFamilyEx.AutoTransaction := True;
//  qComponentsEx.AutoTransaction := True;

  // ��������� �������� ���������� �� �� �������������
  qProductParameters.Load(qFamilyEx.ParentValue, True);

  qFamilyEx.FDQuery.DisableControls;
  qComponentsEx.FDQuery.DisableControls;
  try
    // ���� �� ��������� ���������� ������� ���������
    qProductParameters.FDQuery.First;
    while not qProductParameters.FDQuery.Eof do
    begin

      if qProductParameters.W.ParentProductID.F.IsNull then
        qryComponents := qFamilyEx
      else
        qryComponents := qComponentsEx;

      qryComponents.W.LocateByPK(qProductParameters.W.ProductID.F.Value, True);

      AParamSubParamID := qProductParameters.W.ParamSubParamId.F.AsInteger;

      // �������� �������� ������������ � �� ����, � ��� ����������� ��������
      // ��� ��� ������ ��������� � SQL ������� ���� ����������
      if (not(AllParameterFields.ContainsKey(AParamSubParamID))) or
        (qryComponents.ParameterFields.ContainsKey(AParamSubParamID)) then
      begin
        qProductParameters.FDQuery.Next;
        Continue;
      end;

      AFieldName := AllParameterFields[AParamSubParamID];
      S := qProductParameters.W.Value.F.AsString.Trim;
      if not S.IsEmpty then
      begin
        AField := qryComponents.FDQuery.FindField(AFieldName);
        Assert(AField <> nil);
        // ��������� ������������, ����� ����� ����� ���� �����������
        ANewValue := Format('%s%s%s',
          [FMark, qProductParameters.W.Value.F.AsString.Trim, FMark]);

        AValue := AField.AsString.Trim;
        if AValue <> '' then
          AValue := AValue + #13#10;
        AValue := AValue + ANewValue;

        qryComponents.W.TryEdit;
        AField.AsString := AValue;
        qryComponents.W.TryPost;
      end;

      qProductParameters.FDQuery.Next;
    end;
  finally
    qFamilyEx.FDQuery.First;
    qComponentsEx.FDQuery.First;
    qComponentsEx.FDQuery.EnableControls;
    qFamilyEx.FDQuery.EnableControls;
  end;

  // ������������� �� �������, ����� ���������
  TNotifyEventWrap.Create(qFamilyEx.On_ApplyUpdate, DoOnApplyUpdateFamily,
    FApplyUpdateEvents);
  TNotifyEventWrap.Create(qComponentsEx.On_ApplyUpdate,
    DoOnApplyUpdateComponent, FApplyUpdateEvents);

  qFamilyEx.SaveValuesAfterEdit := True;
  qComponentsEx.SaveValuesAfterEdit := True;

  // ��������� ����������
  Connection.Commit;
end;

procedure TComponentsExGroup2.OnFDQueryUpdateRecord(ASender: TDataSet;
    ARequest: TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

procedure TComponentsExGroup2.TryRefresh;
begin
  // ��������� ���� ��� �� �������������
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

procedure TComponentsExGroup2.UpdateFields;
var
  AFieldName: string;
  AID: Integer;
  AParamSubParamID: Integer;
//  AProductCategoryID: Integer;
  ARecHolder: TRecordHolder;
  OK: Boolean;
begin
  // ������������ �������� ������������
  for ARecHolder in qCategoryParameters.DeletedSubParams do
  begin
    AParamSubParamID := ARecHolder.Field
      [qCategoryParameters.W.ParamSubParamId.FieldName];
//    AProductCategoryID := ARecHolder.Field
//      [qCategoryParameters.ProductCategoryID.FieldName];
    OK := FAllParameterFields.ContainsKey(AParamSubParamID);
    Assert(OK);
    AFieldName := FAllParameterFields[AParamSubParamID];
    FAllParameterFields.Remove(AParamSubParamID);
    // ��������� ���� � ������ ���������
    FFreeFields.Add(AFieldName);

    // ������� ������ ��������� ���������
//    TqUpdateParameterValuesParamSubParam.DoDelete(AParamSubParamID,
//      AProductCategoryID);
  end;

  // ������������ ��������� ������������
  for ARecHolder in qCategoryParameters.EditedSubParams do
  begin
    AParamSubParamID := ARecHolder.Field
      [qCategoryParameters.W.ParamSubParamId.FieldName];
    AID := ARecHolder.Field[qCategoryParameters.W.PKFieldName];
    qCategoryParameters.W.LocateByPK(AID, True);
    Assert(AParamSubParamID <> qCategoryParameters.W.ParamSubParamId.F.AsInteger);

    OK := FAllParameterFields.ContainsKey(AParamSubParamID);
    Assert(OK);
    AFieldName := FAllParameterFields[AParamSubParamID];

    FAllParameterFields.Remove(AParamSubParamID);
    FAllParameterFields.Add(qCategoryParameters.W.ParamSubParamId.F.AsInteger,
      AFieldName);

    // ��������� ������ � �� ������� ������������ �� �����
//    TqUpdateParameterValuesParamSubParam.DoUpdate
//      (qCategoryParameters.ParamSubParamId.AsInteger, AParamSubParamID,
//      qCategoryParameters.ProductCategoryID.AsInteger)
  end;

  // ������������ ����������� ������������
  for ARecHolder in qCategoryParameters.InsertedSubParams do
  begin
    Assert(FFreeFields.Count > 0);
    AParamSubParamID := ARecHolder.Field
      [qCategoryParameters.W.ParamSubParamId.FieldName];
    // ������ ������������ ��� �� ������ ����
    OK := FAllParameterFields.ContainsKey(AParamSubParamID);
    Assert(not OK);

    // ����������� ������ ��������� ����
    FAllParameterFields.Add(AParamSubParamID, FFreeFields[0]);
    FFreeFields.Delete(0);
  end;
end;

procedure TComponentsExGroup2.UpdateParameterValue(AComponentID: Integer; const
    AParamSubParamID: Integer; const AVaramValue: String);
var
  AValue: string;
  k: Integer;
  m: TArray<String>;
  S: string;
begin
  Assert(AComponentID > 0);
  Assert(AParamSubParamID > 0);

  // ��������� �������� ����������
  qProductParameters.W.ApplyFilter(AComponentID, AParamSubParamID);

  qProductParameters.FDQuery.First;

  S := AVaramValue;
  m := S.Split([#13]);
  k := 0;
  for S in m do
  begin

    AValue := S.Trim([FMark.Chars[0], #13, #10]);
    if not AValue.IsEmpty then
    begin
      Inc(k);
      if not(qProductParameters.FDQuery.Eof) then
        qProductParameters.W.TryEdit
      else
      begin
        qProductParameters.W.TryAppend;
        qProductParameters.W.ParamSubParamId.F.AsInteger := AParamSubParamID;
        qProductParameters.W.ProductID.F.AsInteger := AComponentID;
      end;

      qProductParameters.W.Value.F.AsString := AValue;
      qProductParameters.W.TryPost;
      qProductParameters.FDQuery.Next;
    end;
  end;

  // ������� "������" ��������
  while qProductParameters.FDQuery.RecordCount > k do
  begin
    qProductParameters.FDQuery.Last;
    qProductParameters.FDQuery.Delete;
  end;
  qProductParameters.FDQuery.Filtered := False;
end;

end.
