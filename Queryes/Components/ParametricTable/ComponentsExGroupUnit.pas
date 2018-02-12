unit ComponentsExGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, FamilyExQuery,
  ParametersForCategoryQuery, ProductParametersQuery, Data.DB,
  FireDAC.Stan.Option, FireDAC.Comp.DataSet, CustomComponentsQuery,
  System.Contnrs, System.Generics.Collections, QueryWithDataSourceUnit,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, FamilyQuery, BaseFamilyQuery,
  BaseComponentsQuery, ComponentsQuery, ComponentsExQuery,
  BaseComponentsGroupUnit, NotifyEvents, UpdateParamValueRec,
  CategoryParametersGroupUnit;

type
  TComponentsExGroup = class(TBaseComponentsGroup)
    qFamilyEx: TQueryFamilyEx;
    qComponentsEx: TQueryComponentsEx;
    procedure OnFDQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
  private
    FApplyUpdateEvents: TObjectList;
    FClientCount: Integer;
    FMark: string;
    FAllParameterFields: TDictionary<Integer, String>;
    FCatParamsGroup: TCategoryParametersGroup;
    FFamilyIDList: TUpdParamList;
    FOnParamOrderChange: TNotifyEventsEx;
    FqProductParameters: TQueryProductParameters;
  const
    FFieldPrefix: string = 'Field';
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure ApplyUpdate(AQueryCustomComponents: TQueryCustomComponents;
      AFamily: Boolean);
    procedure DoOnApplyUpdateComponent(Sender: TObject);
    procedure DoOnApplyUpdateFamily(Sender: TObject);
    function GetFamilyIDList: TUpdParamList;
    function GetFieldName(AIDParameter: Integer): String;
    function GetqProductParameters: TQueryProductParameters;
    procedure UpdateParameterValue(AComponentID: Integer; const AParamSubParamID:
        Integer; const AVaramValue: String);
// TODO: qProductParameters
//  // TODO: qParametersForCategory
//  // property qParametersForCategory: TQueryParametersForCategory read
//  // FqParametersForCategory;
    { Private declarations }
  protected
    // TODO: ClearUpdateCount
    procedure LoadParameterValues;
    property FamilyIDList: TUpdParamList read GetFamilyIDList;
    property qProductParameters: TQueryProductParameters read GetqProductParameters;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient;
    procedure DecClient;
    function GetIDParameter(const AFieldName: String): Integer;
    procedure TryRefresh;
    procedure UpdateFamilyParameterValues;
    property Mark: string read FMark;
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property OnParamOrderChange: TNotifyEventsEx read FOnParamOrderChange;
    property CatParamsGroup: TCategoryParametersGroup read FCatParamsGroup;
    { Public declarations }
  end;

implementation

uses FireDAC.Stan.Param, SearchFamilyParamValuesQuery;

{$R *.dfm}
{ TfrmComponentsMasterDetail }

constructor TComponentsExGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAllParameterFields := TDictionary<Integer, String>.Create();

  FApplyUpdateEvents := TObjectList.Create;

  FMark := '!';

  FCatParamsGroup := TCategoryParametersGroup.Create(Self);

  Main := qFamilyEx;
  Detail := qComponentsEx;

  TNotifyEventWrap.Create(qFamilyEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qFamilyEx.AfterOpen, DoAfterOpen);

  FClientCount := 1;
  DecClient; // ������������ ��������� ����������

  FOnParamOrderChange := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsExGroup.Destroy;
begin
  if FFamilyIDList <> nil then
    FreeAndNil(FFamilyIDList);

  FreeAndNil(FAllParameterFields);
  FreeAndNil(FApplyUpdateEvents);
  inherited;
end;

procedure TComponentsExGroup.AddClient;
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

procedure TComponentsExGroup.DecClient;
begin
  Dec(FClientCount);
  Assert(FClientCount >= 0);

  if FClientCount = 0 then
  begin
    qComponentsEx.Lock := True;
    qFamilyEx.Lock := True;
  end;
end;

procedure TComponentsExGroup.DoAfterOpen(Sender: TObject);
begin
  LoadParameterValues;
end;

procedure TComponentsExGroup.DoBeforeOpen(Sender: TObject);
var
  AData: TQueryCustomComponents;
  AFDQuery: TFDQuery;
  AFieldName: String;
  AFieldType: TFieldType;
  AParamSubParamId: Integer;
  ASize: Integer;
begin
  // ������� ������� ����������
  FAllParameterFields.Clear;

  AData := Sender as TQueryCustomComponents;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  AFDQuery.FieldDefs.Update;

  // � ������ ���������� ����� ��������� ��������� (�������, ���������)
  FCatParamsGroup.qCategoryParameters.Load(AData.ParentValue, True);
  FCatParamsGroup.qCategoryParameters.FDQuery.First;
  while not FCatParamsGroup.qCategoryParameters.FDQuery.Eof do
  begin
    AParamSubParamId := FCatParamsGroup.qCategoryParameters.
      ParamSubParamId.AsInteger;
    // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
    if not AData.ParameterFields.ContainsKey(AParamSubParamId) then
    begin
      AFieldType := ftWideString;
      ASize := 200;

      AFieldName := GetFieldName(AParamSubParamId);
      // ��������� ��������� ����
      AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
      FAllParameterFields.Add(AParamSubParamId, AFieldName);
    end
    else
      FAllParameterFields.Add(AParamSubParamId,
        AData.ParameterFields[AParamSubParamId]);

    FCatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;

  AData.CreateDefaultFields(False);

  FCatParamsGroup.qCategoryParameters.FDQuery.First;
  while not FCatParamsGroup.qCategoryParameters.FDQuery.Eof do
  begin
    AParamSubParamId := FCatParamsGroup.qCategoryParameters.
      ParamSubParamId.AsInteger;
    if not AData.ParameterFields.ContainsKey(AParamSubParamId) then
    begin
      AFieldName := GetFieldName(AParamSubParamId);
      AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FCatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;

  (*

    // � ������ ���������� ����� ��������� ��������� (�������, ���������)
    qParametersForCategory.Load(AData.ParentValue, True); // �������������

    qParametersForCategory.FDQuery.First;
    while not FqParametersForCategory.FDQuery.Eof do
    begin
    // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
    if not AData.ParameterFields.ContainsKey
    (FqParametersForCategory.ParameterID.AsInteger) then
    begin
    ASize := 0;
    // AFieldType := ftInteger;

    case qParametersForCategory.FieldType.AsInteger of
    // ����� �����
    1:
    AFieldType := ftInteger;
    2: // ������
    begin
    AFieldType := ftWideString;
    ASize := 200;
    end;
    // ������� �����
    3:
    AFieldType := ftFloat;
    // ������ ��������
    4:
    AFieldType := ftBoolean;
    // ���� � �����
    5:
    AFieldType := ftDateTime;
    else
    AFieldType := ftWideString;
    ASize := 200;
    end;

    AFieldName := GetFieldName(FqParametersForCategory.ParameterID.AsInteger);
    // ��������� ��������� ����
    AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
    FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
    AFieldName);
    end
    else
    FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
    AData.ParameterFields[FqParametersForCategory.ParameterID.AsInteger]);

    FqParametersForCategory.FDQuery.Next;
    end;

    AData.CreateDefaultFields(False);

    FqParametersForCategory.FDQuery.First;
    while not FqParametersForCategory.FDQuery.Eof do
    begin
    if not AData.ParameterFields.ContainsKey
    (FqParametersForCategory.ParameterID.AsInteger) then
    begin
    AFieldName := GetFieldName(FqParametersForCategory.ParameterID.AsInteger);
    AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FqParametersForCategory.FDQuery.Next;
    end;
  *)
end;

procedure TComponentsExGroup.ApplyUpdate(AQueryCustomComponents
  : TQueryCustomComponents; AFamily: Boolean);
var
  // AQueryCustomComponents: TQueryCustomComponents;
  AField: TField;
  AFieldName: String;
  AParamSubParamId: Integer;
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
    AParamSubParamId := CatParamsGroup.qCategoryParameters.
      ParamSubParamId.AsInteger;
    AFieldName := AllParameterFields[AParamSubParamId];
    AField := AQueryCustomComponents.Field(AFieldName);


    // AField.OldValue <> AField.Value ������-�� �� ��������
    // AOldValue := VarToStrDef(AQueryCustomComponents.RecordHolder.Field[AFieldName], '');
    // ANewValue := VarToStrDef(AField.Value, '');

    // ���� �������� ������� ��������� ����������
    if AQueryCustomComponents.RecordHolder.Field[AFieldName] <> AField.Value
    then
    begin
      // ��������� �������� ��������� �� �������
      UpdateParameterValue(AQueryCustomComponents.PK.AsInteger,
        AParamSubParamId, AField.AsString);
    end;
    // ��������� � ���������� ������������
    CatParamsGroup.qCategoryParameters.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.DoOnApplyUpdateComponent(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, False);
end;

procedure TComponentsExGroup.DoOnApplyUpdateFamily(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, True);
end;

function TComponentsExGroup.GetFamilyIDList: TUpdParamList;
begin
  if FFamilyIDList = nil then
    FFamilyIDList := TUpdParamList.Create;

  Result := FFamilyIDList;
end;

procedure TComponentsExGroup.OnFDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TComponentsExGroup.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TComponentsExGroup.GetIDParameter(const AFieldName: String): Integer;
var
  S: string;
begin
  S := AFieldName.Remove(0, FFieldPrefix.Length);
  Result := S.ToInteger();
end;

function TComponentsExGroup.GetqProductParameters: TQueryProductParameters;
begin
  if FqProductParameters = nil then
    FqProductParameters := TQueryProductParameters.Create(Self);

  Result := FqProductParameters;
end;

procedure TComponentsExGroup.LoadParameterValues;
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

  // ��������� �������� ���������� �� �� �������������
  qProductParameters.Load(qFamilyEx.ParentValue, True);

  qFamilyEx.FDQuery.DisableControls;
  qComponentsEx.FDQuery.DisableControls;
  try
    // ���� �� ��������� ���������� ������� ���������
    qProductParameters.FDQuery.First;
    while not qProductParameters.FDQuery.Eof do
    begin

      if qProductParameters.ParentProductID.IsNull then
        qryComponents := qFamilyEx
      else
        qryComponents := qComponentsEx;

      qryComponents.LocateByPK(qProductParameters.ProductID.Value, True);

      AParamSubParamID := qProductParameters.ParamSubParamID.AsInteger;

      // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
      if not qryComponents.ParameterFields.ContainsKey(AParamSubParamID) then
      begin
        AFieldName := GetFieldName(AParamSubParamID);
        S := qProductParameters.Value.AsString.Trim;
        if not S.IsEmpty then
        begin
          // �������� ������ ��������� � ����� ��������� ��� ���
          AField := qryComponents.FDQuery.FindField(AFieldName);
          // ���� ����� �������� � ����� ��������� ����
          if AField <> nil then
          begin
            // ��������� ������������, ����� ����� ����� ���� �����������
            ANewValue := Format('%s%s%s',
              [FMark, qProductParameters.Value.AsString.Trim, FMark]);

            AValue := AField.AsString.Trim;
            if AValue <> '' then
              AValue := AValue + #13#10;
            AValue := AValue + ANewValue;

            qryComponents.TryEdit;
            AField.AsString := AValue;
            qryComponents.TryPost;
          end;
        end;
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

procedure TComponentsExGroup.TryRefresh;
begin
  // ��������� ���� ��� �� �������������
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

procedure TComponentsExGroup.UpdateFamilyParameterValues;
var
  AUpdParam: TUpdParam;
  Q: TQueryFamilyParamValues;
begin
  if (FFamilyIDList = nil) or (FamilyIDList.Count = 0) then
    Exit;

  Q := TQueryFamilyParamValues.Create(Self);
  try

    for AUpdParam in FFamilyIDList do
    begin
      // ���� ������� ������������ ��������
      if Q.SearchEx(AUpdParam.FamilyID, AUpdParam.ParameterID) = 1 then
      begin
        UpdateParameterValue(AUpdParam.FamilyID, AUpdParam.ParameterID,
          Q.Value.AsString)
      end;
    end;

  finally
    FreeAndNil(Q);
  end;
end;

procedure TComponentsExGroup.UpdateParameterValue(AComponentID: Integer; const
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
  qProductParameters.ApplyFilter(AComponentID, AParamSubParamID);

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
        qProductParameters.FDQuery.Edit
      else
      begin
        qProductParameters.FDQuery.Append;
        qProductParameters.ParamSubParamID.AsInteger :=
          qProductParameters.ParamSubParamID.AsInteger;
        qProductParameters.ProductID.AsInteger := AComponentID;
      end;

      qProductParameters.Value.AsString := AValue;
      qProductParameters.TryPost;
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
