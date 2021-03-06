unit CategoryParametersGroupUnit2;

interface

uses
  QueryGroupUnit2, NotifyEvents, System.Classes,
  System.Generics.Collections, CategoryParametersQuery2, ParamSubParamsQuery,
  SearchParamDefSubParamQuery, SearchParamSubParamQuery,
  UpdateNegativeOrdQuery, FireDAC.Comp.Client, Data.DB;

type
  TCategoryFDMemTable = class(TFDMemTable)
  private
    FInUpdate: Boolean;
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetPK: TField; virtual;
    function GetPosID: TField;
  protected
    procedure DeleteTail(AFromRecNo: Integer);
    function LocateByField(const AFieldName: string; AValue: Variant;
      TestResult: Boolean = False): Boolean;
  public
    procedure AppendFrom(ASource: TCategoryFDMemTable);
    function GetFieldValues(const AFieldName: string): String;
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
    function LocateByPK(AField: TField; AValue: Integer; TestResult: Boolean =
        False): Boolean;
    procedure SetOrder(AOrder: Integer);
    procedure Update(ASource: TCategoryFDMemTable);
    procedure UpdateFrom(ASource: TCategoryFDMemTable);
    procedure UpdatePK(APKDictionary: TDictionary<Integer, Integer>);
    property ID: TField read GetID;
    property InUpdate: Boolean read FInUpdate;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property PK: TField read GetPK;
    property PosID: TField read GetPosID;
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetIsDefault: TField;
    function GetParameterType: TField;
    function GetPK: TField; override;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    function GetVID: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AVID, AID, AIDParameter: Integer;
      const AValue, ATableName, AValueT, AParameterType: String;
      AIsAttribute, AIsDefault, APosID, AOrd: Integer);
    function LocateByParameterID(AIDParameter: Integer): Boolean;
    function LocateByVID(AValue: Integer; TestResult: Boolean = False): Boolean;
    property IDParameter: TField read GetIDParameter;
    property IsDefault: TField read GetIsDefault;
    property ParameterType: TField read GetParameterType;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    property VID: TField read GetVID;
  end;

  TQryCategorySubParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetIDParent: TField;
    function GetIDSubParameter: TField;
    function GetName: TField;
    function GetParamSubParamID: TField;
    function GetTranslation: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AID, AIDParent, AIDParameter, AParamSubParamId,
      AIDSubParameter: Integer; const AName, ATranslation: String;
      AIsAttribute, APosID, AOrd: Integer);
    procedure DeleteByIDParent(AIDCategoryParam: Integer);
    procedure FilterByIDParent(AIDCategoryParam: Integer);
    procedure FilterByIDParameter(AParameterID: Integer);
    function Locate2(AIDParent, AIDSubParameter: Integer;
      TestResult: Boolean = False): Boolean;
    property IDParameter: TField read GetIDParameter;
    property IDParent: TField read GetIDParent;
    property IDSubParameter: TField read GetIDSubParameter;
    property Name: TField read GetName;
    property ParamSubParamID: TField read GetParamSubParamID;
    property Translation: TField read GetTranslation;
  end;

  TCategoryParametersGroup2 = class(TQueryGroup2)
  private
    FAfterUpdateData: TNotifyEventsEx;
    FBeforeUpdateData: TNotifyEventsEx;
    FDataLoading: Boolean;
    FFDQCategoryParameters: TQryCategoryParameters;
    FFDQCategorySubParameters: TQryCategorySubParameters;
    FFullUpdate: Boolean;
    FIDDic: TDictionary<Integer, Integer>;
    FOnIsAttributeChange: TNotifyEventsEx;
    FqCategoryParameters: TQueryCategoryParameters2;
    FqCatParams: TQryCategoryParameters;
    FqCatSubParams: TQryCategorySubParameters;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParamSubParam: TQuerySearchParamSubParam;
    FqUpdNegativeOrd: TQueryUpdNegativeOrd;
    FVID: Integer;
    procedure DoAfterOpenOrRefresh(Sender: TObject);
    function GetIsAllQuerysActive: Boolean;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParamSubParam: TQuerySearchParamSubParam;
    function GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
  protected
    procedure AppendParameter(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName, ATranslation: String; AIsDefault: Integer);
    procedure AppendSubParameter(AID, ASubParamID: Integer);
    procedure DoOnIsAttributeChange(Sender: TField);
    function GetHaveAnyChanges: Boolean; override;
    function GetVirtualID(AID: Integer; AUseDic: Boolean): Integer;
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParamSubParam: TQuerySearchParamSubParam
      read GetqSearchParamSubParam;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient; override;
    procedure AddOrDeleteParameters(AParamIDList: string; APosID: Integer);
    procedure AddOrDeleteSubParameters(AID: Integer; ASubParamIDList: string);
    function ApplyOrCancelUpdates: Boolean;
    function ApplyUpdates: Boolean; override;
    procedure CancelUpdates; override;
    procedure DeleteParameters(APKValues: array of Integer);
    procedure DeleteSubParameters(APKValues: array of Integer);
    function GetIDList(AID: Integer): TArray<Integer>;
    procedure LoadData;
    procedure MoveParameters(IDArr: TArray<Integer>; TargetID: Integer;
      AUp: Boolean);
    procedure MoveSubParameters(IDArr: TArray<Integer>; TargetID: Integer; AUp:
        Boolean);
    procedure RefreshData; override;
    procedure RemoveClient; override;
    procedure SetPos(AIDArray: TArray<Integer>; AWithSubParams: Boolean;
      APosID: Integer);
    procedure UpdateData;
    property AfterUpdateData: TNotifyEventsEx read FAfterUpdateData;
    property BeforeUpdateData: TNotifyEventsEx read FBeforeUpdateData;
    property IsAllQuerysActive: Boolean read GetIsAllQuerysActive;
    property OnIsAttributeChange: TNotifyEventsEx read FOnIsAttributeChange;
    property DataLoading: Boolean read FDataLoading;
    property FullUpdate: Boolean read FFullUpdate;
    property qCategoryParameters: TQueryCategoryParameters2
      read FqCategoryParameters;
    property qCatParams: TQryCategoryParameters read FqCatParams;
    property qCatSubParams: TQryCategorySubParameters read FqCatSubParams;
    property qUpdNegativeOrd: TQueryUpdNegativeOrd read GetqUpdNegativeOrd;
  end;

implementation

uses
  System.SysUtils, MoveHelper, System.StrUtils, System.Variants;

constructor TCategoryParametersGroup2.Create(AOwner: TComponent);
begin
  inherited;
  FqCategoryParameters := TQueryCategoryParameters2.Create(Self);
  FFDQCategoryParameters := TQryCategoryParameters.Create(Self);
  FFDQCategorySubParameters := TQryCategorySubParameters.Create(Self);

  FqCatParams := TQryCategoryParameters.Create(Self);
  FqCatParams.IsAttribute.OnChange := DoOnIsAttributeChange;
  FqCatSubParams := TQryCategorySubParameters.Create(Self);

  TNotifyEventWrap.Create(FqCategoryParameters.W.AfterOpen,
    DoAfterOpenOrRefresh, EventList);
  TNotifyEventWrap.Create(FqCategoryParameters.W.AfterRefresh,
    DoAfterOpenOrRefresh, EventList);

  FBeforeUpdateData := TNotifyEventsEx.Create(Self);
  FAfterUpdateData := TNotifyEventsEx.Create(Self);
  FOnIsAttributeChange := TNotifyEventsEx.Create(Self);

  FIDDic := TDictionary<Integer, Integer>.Create;
end;

destructor TCategoryParametersGroup2.Destroy;
begin
  FreeAndNil(FIDDic);
  FreeAndNil(FBeforeUpdateData);
  FreeAndNil(FAfterUpdateData);
  FreeAndNil(FOnIsAttributeChange);
  inherited;
end;

procedure TCategoryParametersGroup2.AddClient;
begin
  FqCategoryParameters.AddClient;
end;

procedure TCategoryParametersGroup2.AddOrDeleteParameters(AParamIDList: string;
  APosID: Integer);
var
  AIDParam: String;
  m: TArray<String>;
  S: string;
begin
  // ����� �������� ��� ������� ���������

  // ������ ��������������� ���������� ����� ���������, ������� �� ����� �������������!
  qCategoryParameters.W.FilterByIsDefault(1);
  try
    S := qCategoryParameters.W.IDParameter.AllValues(',');
  finally
    qCategoryParameters.FDQuery.Filtered := False;
  end;

  m := S.Split([',']);
  S := Format(',%s,', [S]);
  // ���� �� ���������� ��� ���������
  for AIDParam in m do
  begin
    // ���� ������� � ������ �� ���������� ��������� �����
    if AParamIDList.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      // ���� ����� �������� ��� �������������
      qCategoryParameters.W.LocateDefault(AIDParam.ToInteger, True);
      DeleteParameters([qCategoryParameters.W.PK.AsInteger]);
    end;
  end;

  m := AParamIDList.Trim([',']).Split([',']);
  // ���� �� ���������� � ����������� ����������
  for AIDParam in m do
  begin
    // ���� ������� ���������
    if S.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      // ���� ������ ���������� �� ���� ���������
      qSearchParamDefSubParam.SearchByID(AIDParam.ToInteger, 1);

      // ��������� ��������
      AppendParameter(qSearchParamDefSubParam.W.ParamSubParamID.F.Value,
        qCategoryParameters.NextOrder, 1, APosID,
        qSearchParamDefSubParam.W.PK.Value,
        qSearchParamDefSubParam.W.IDSubParameter.F.Value,
        qSearchParamDefSubParam.W.Value.F.Value,
        qSearchParamDefSubParam.W.TableName.F.Value,
        qSearchParamDefSubParam.W.ValueT.F.Value,
        qSearchParamDefSubParam.W.ParameterType.F.Value, '', '', 1);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup2.AddOrDeleteSubParameters(AID: Integer;
  ASubParamIDList: string);
var
  AIDParameter: Integer;
  m: TArray<String>;
  S: String;
  S2: string;
  S1: String;
begin
  // ����� �������� ��� ������� ������������

  // ���� ������ ���������-��������
  qCategoryParameters.W.LocateByPK(AID, True);
  AIDParameter := qCategoryParameters.W.IDParameter.F.AsInteger;

  // �������� ��� ������������ ������ ���������
  // ��� ����� ���� ����������� � ������ �������!!!
  S1 := Format(',%s,', [qCategoryParameters.GetAllIDSubParamList]);

  // ��������� ����������� ������� - �������������
  m := ASubParamIDList.Split([',']);
  for S in m do
  begin
    // ���� ����� �������� ����� �����������
    if S1.IndexOf(Format(',%s,', [S])) = -1 then
      AppendSubParameter(AID, S.ToInteger);
  end;

  // ��������� ������ ������� - �������������
  S2 := Format(',%s,', [ASubParamIDList]);
  m := S1.Trim([',']).Split([',']);
  for S in m do
  begin
    // ���� ����� ������� ������ �����������
    if S2.IndexOf(Format(',%s,', [S])) = -1 then
    begin
      // �� ����� ��� ��������� � ��� ������������ ��� ��������
      // ���� ������ �� ��������� ������������
      qCategoryParameters.W.Locate(AIDParameter, S.ToInteger, True);
      // ������� ����� �����������
      DeleteSubParameters([qCategoryParameters.W.PK.AsInteger]);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup2.AppendParameter(AParamSubParamId, AOrd,
  AIsAttribute, APosID, AIDParameter, AIDSubParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType, AName,
  ATranslation: String; AIsDefault: Integer);
begin
  FqCategoryParameters.W.AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
    AIDParameter, AIDSubParameter, AValue, ATableName, AValueT, AParameterType,
    AName, ATranslation, AIsDefault);
end;

procedure TCategoryParametersGroup2.AppendSubParameter(AID,
  ASubParamID: Integer);
var
  ACloneW: TCategoryParameters2W;
  AOrder: Integer;
  APosID: Integer;
  rc: Integer;
begin
  Assert(AID <> 0);
  Assert(ASubParamID > 0);

  // ���� ������ ���������-��������
  qCategoryParameters.W.LocateByPK(AID, True);

  // ����� �������� ����������� � ���������, ���� � ���� ��� ��� �� ����
  rc := qParamSubParams.SearchBySubParam
    (qCategoryParameters.W.IDParameter.F.AsInteger, ASubParamID);
  // ���� � ����� ��������� ��� ������ ������������
  if rc = 0 then
  begin
    qParamSubParams.W.AppendSubParameter
      (qCategoryParameters.W.IDParameter.F.AsInteger, ASubParamID);

    Assert(qParamSubParams.FDQuery.RecordCount > 0);
  end;

  // �������� ������ ���������� � ���� ������������
  qSearchParamSubParam.SearchByID(qParamSubParams.W.PK.Value, 1);

  // ������� ������������ �������� ���������
  ACloneW := qCategoryParameters.CreateSubParamsClone;
  try
    // ���� ���� �������� ��� �� ����� �������������
    if (ACloneW.DataSet.RecordCount = 1) and
      (qCategoryParameters.W.IsDefault.F.AsInteger = 1) then
    begin
      // ���� �������� ����������� �� ��������� �� ����������� �����������
      qCategoryParameters.W.TryEdit;
      qCategoryParameters.W.ParamSubParamID.F.AsInteger :=
        qParamSubParams.W.PK.Value;
      qCategoryParameters.W.Name.F.Value := qParamSubParams.W.Name.F.Value;
      qCategoryParameters.W.Translation.F.Value :=
        qParamSubParams.W.Translation.F.Value;
      qCategoryParameters.W.IsDefault.F.AsInteger := 0;
      qCategoryParameters.W.TryPost;
    end
    else
    begin
      // ��������� ����������� ����� � �����!
      ACloneW.DataSet.Last;
      // ����� �������� �������
      AOrder := ACloneW.Ord.F.AsInteger + 1;
      APosID := qCategoryParameters.W.PosID.F.AsInteger;
      // �������� �������� ������� ���� ����������/������������� �� 1.
      // ��� ��������� ����!
      qCategoryParameters.IncOrder(AOrder);

      // ��������� �����������
      qCategoryParameters.W.AppendR(qSearchParamSubParam.W.PK.Value, AOrder, 1,
        APosID, qSearchParamSubParam.W.IDParameter.F.Value,
        qSearchParamSubParam.W.IDSubParameter.F.Value,
        qSearchParamSubParam.W.Value.F.Value,
        qSearchParamSubParam.W.TableName.F.Value,
        qSearchParamSubParam.W.ValueT.F.Value,
        qSearchParamSubParam.W.ParameterType.F.Value,
        qSearchParamSubParam.W.Name.F.Value,
        qSearchParamSubParam.W.Translation.F.Value,
        qSearchParamSubParam.W.IsDefault.F.Value);

    end;
  finally
    qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
  end;
end;

function TCategoryParametersGroup2.ApplyOrCancelUpdates: Boolean;
begin
  Result := ApplyUpdates;
  // Result := False;
  // ���� �� ������� ��������� ���������
  if not Result then
    CancelUpdates;
end;

function TCategoryParametersGroup2.ApplyUpdates: Boolean;
var
  AID: Integer;
  AKey: Integer;
  ok: Boolean;
  VID: Integer;
begin
  ok := not FqCategoryParameters.FDQuery.Connection.InTransaction;
  Assert(ok);

  // ���� �������� ����������!!
  FqCategoryParameters.FDQuery.Connection.StartTransaction;

  // ��� ��� ��������� ��������� ���������� ���������� �� ���� ��
  FqCategoryParameters.ApplyUpdates;

  // ���������, ������� ��
  Result := not FqCategoryParameters.HaveAnyChanges;
  if not Result then
  begin
    FqCategoryParameters.FDQuery.Connection.Rollback;
    Exit;
  end;

  // ������ ������������� ������� �� �������������!
  qUpdNegativeOrd.FDQuery.ExecSQL;

  if FqCategoryParameters.PKDictionary.Count > 0 then
  begin
    // ��� ���� �������� ����������� �������������� �� ��������
    FFDQCategoryParameters.UpdatePK(FqCategoryParameters.PKDictionary);
    FFDQCategorySubParameters.UpdatePK(FqCategoryParameters.PKDictionary);
    qCatParams.UpdatePK(FqCategoryParameters.PKDictionary);
    qCatSubParams.UpdatePK(FqCategoryParameters.PKDictionary);

    for AKey in FqCategoryParameters.PKDictionary.Keys do
    begin
      // ���� ����� ���� ����������� ������������
      if not FIDDic.ContainsKey(AKey) then
        Continue;

      AID := FqCategoryParameters.PKDictionary[AKey];
      // ����� ���� �� -> VID
      VID := FIDDic[AKey];
      FIDDic.Add(AID, VID);
      FIDDic.Remove(AKey);
    end;
  end;
  FqCategoryParameters.FDQuery.Connection.Commit;
  ok := not FqCategoryParameters.FDQuery.Connection.InTransaction;
  Assert(ok);
end;

procedure TCategoryParametersGroup2.CancelUpdates;
begin
  // ��� ��� ��������� ��������� ����������
  FqCategoryParameters.CancelUpdates;

  LoadData;
end;

procedure TCategoryParametersGroup2.DeleteParameters
  (APKValues: array of Integer);
var
  ACloneW: TCategoryParameters2W;
  AID: Integer;
begin
  for AID in APKValues do
  begin
    qCategoryParameters.W.LocateByPK(AID);
    // �������� ��� ������������, ����������� � ������� ������
    ACloneW := qCategoryParameters.CreateSubParamsClone;
    try
      // ������� ��
      ACloneW.DeleteAll;
    finally
      qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
    end;
  end;
  LoadData;
end;

procedure TCategoryParametersGroup2.DeleteSubParameters
  (APKValues: array of Integer);
var
  ACloneW: TCategoryParameters2W;
  AID: Integer;
  VID: Integer;
begin
  for AID in APKValues do
  begin
    qCategoryParameters.W.LocateByPK(AID, True);
    ACloneW := qCategoryParameters.CreateSubParamsClone;
    try
      // ���� ���� �������� ���� ����������� �����������
      if ACloneW.DataSet.RecordCount = 1 then
      begin
        // �������� ���������� � ���, ����� ����������� "�� ���������" � ������ ���������
        qSearchParamDefSubParam.SearchByID
          (qCategoryParameters.W.IDParameter.F.AsInteger, 1);

        qCategoryParameters.W.TryEdit;
        // ������ ������ �� ��������� � ���������� �����������
        qCategoryParameters.W.ParamSubParamID.F.Value :=
          qSearchParamDefSubParam.W.ParamSubParamID.F.Value;
        qCategoryParameters.W.IDSubParameter.F.Value :=
          qSearchParamDefSubParam.W.IDSubParameter.F.Value;
        qCategoryParameters.W.IsDefault.F.AsInteger := 1;
        qCategoryParameters.W.Name.F.Value :=
          qSearchParamDefSubParam.W.Name.F.Value;
        qCategoryParameters.W.Translation.F.Value :=
          qSearchParamDefSubParam.W.Translation.F.Value;
        qCategoryParameters.W.TryPost;
      end
      else
      begin
        // ������� �����������;
        qCategoryParameters.FDQuery.Delete;
        Assert(ACloneW.DataSet.RecordCount > 0);
        // ���� �� ������� ������ �����������
        if FIDDic.ContainsKey(AID) then
        begin
          // ����������� ID �����. ���������
          VID := FIDDic[AID];
          FIDDic.Remove(AID);
          // ��������� ������������� ������� ������������
          FIDDic.Add(ACloneW.ID.F.AsInteger, VID);
        end;
      end;
    finally
      qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup2.DoAfterOpenOrRefresh(Sender: TObject);
begin
  FVID := 0;
  FIDDic.Clear;

  FFullUpdate := True;
  try
    LoadData;
  finally
    FFullUpdate := False;
  end;
end;

procedure TCategoryParametersGroup2.DoOnIsAttributeChange(Sender: TField);
begin
  if qCatParams.InUpdate then
    Exit;

  // ��������� ��������� � ������� ������ ������
  qCategoryParameters.SetIsAttribute(qCatParams.ID.AsInteger,
    qCatParams.IsAttribute.AsInteger);

  LoadData;

  FOnIsAttributeChange.CallEventHandlers(Self);
end;

function TCategoryParametersGroup2.GetHaveAnyChanges: Boolean;
begin
  Result := qCategoryParameters.HaveAnyChanges;
end;

function TCategoryParametersGroup2.GetIDList(AID: Integer): TArray<Integer>;
var
  ACloneW: TCategoryParameters2W;
  L: TList<Integer>;
begin
  Assert(AID > 0);
  // ������ ���� ������ ������ ������������
  Assert(qCategoryParameters.FDQuery.RecordCount > 0);

  L := TList<Integer>.Create;
  try
    qCategoryParameters.W.LocateByPK(AID, True);
    ACloneW := qCategoryParameters.CreateSubParamsClone;
    try
      // ���������� ������ ��������������� �������� �����
      while not ACloneW.DataSet.Eof do
      begin
        L.Add(ACloneW.ID.F.AsInteger);
        ACloneW.DataSet.Next;
      end;
      Result := L.ToArray;
    finally
      qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
    end;
  finally
    FreeAndNil(L);
  end;
end;

function TCategoryParametersGroup2.GetIsAllQuerysActive: Boolean;
begin
  Result := qCategoryParameters.FDQuery.Active and
    FFDQCategoryParameters.Active and FFDQCategorySubParameters.Active;
end;

function TCategoryParametersGroup2.GetqParamSubParams: TQueryParamSubParams;
begin
  if FqParamSubParams = nil then
    FqParamSubParams := TQueryParamSubParams.Create(Self);
  Result := FqParamSubParams;
end;

function TCategoryParametersGroup2.GetqSearchParamDefSubParam
  : TQuerySearchParamDefSubParam;
begin
  if FqSearchParamDefSubParam = nil then
    FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create(Self);
  Result := FqSearchParamDefSubParam;
end;

function TCategoryParametersGroup2.GetqSearchParamSubParam
  : TQuerySearchParamSubParam;
begin
  if FqSearchParamSubParam = nil then
    FqSearchParamSubParam := TQuerySearchParamSubParam.Create(Self);

  Result := FqSearchParamSubParam;
end;

function TCategoryParametersGroup2.GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
begin
  if FqUpdNegativeOrd = nil then
    FqUpdNegativeOrd := TQueryUpdNegativeOrd.Create(Self);
  Result := FqUpdNegativeOrd;
end;

function TCategoryParametersGroup2.GetVirtualID(AID: Integer;
  AUseDic: Boolean): Integer;
begin
  Assert(not AUseDic or (AUseDic and (FIDDic.Count > 0)));

  // ���� �������� ������������ �������������� ���� �� �������
  if AUseDic and FIDDic.ContainsKey(AID) then
  begin
    Result := FIDDic[AID]
  end
  else
  begin
    // � ������� ����� ������ ���. ������ ��� ������ ��������
    Assert(FVID >= 0);
    Inc(FVID);
    FIDDic.Add(AID, FVID);
    Result := FVID;
  end;
end;

procedure TCategoryParametersGroup2.LoadData;
var
  AFieldList: TStringList;
  AUseDic: Boolean;
  VID: Integer;
begin
  AUseDic := FIDDic.Count > 0;
  AFieldList := TStringList.Create;
  try
    FFDQCategorySubParameters.EmptyDataSet;
    FFDQCategoryParameters.EmptyDataSet;

    FFDQCategoryParameters.Fields.GetFieldNames(AFieldList);
    // ��� ���� ����� ���������� ��� �����������
    AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.ID.FieldName));
    AFieldList.Delete
      (AFieldList.IndexOf(FFDQCategoryParameters.IsAttribute.FieldName));
    AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.Ord.FieldName));
    Assert(AFieldList.Count > 0);

    qCategoryParameters.FDQuery.DisableControls;
    try
      qCategoryParameters.FDQuery.First;
      FFDQCategoryParameters.First;
      while not qCategoryParameters.FDQuery.Eof do
      begin
        FFDQCategoryParameters.LoadRecFrom(qCategoryParameters.FDQuery,
          AFieldList);
        if FFDQCategoryParameters.ID.IsNull then
        begin
          VID := GetVirtualID(qCategoryParameters.W.PK.AsInteger, AUseDic);
          FFDQCategoryParameters.Edit;
          FFDQCategoryParameters.VID.AsInteger := VID;
          FFDQCategoryParameters.ID.AsInteger :=
            qCategoryParameters.W.PK.AsInteger;
          FFDQCategoryParameters.IsAttribute.Value :=
            qCategoryParameters.W.IsAttribute.F.Value;
          FFDQCategoryParameters.Ord.Value := qCategoryParameters.W.Ord.F.Value;
          FFDQCategoryParameters.Post;
        end;

        if qCategoryParameters.W.IsDefault.F.AsInteger = 0 then
        begin
          FFDQCategorySubParameters.LoadRecFrom
            (qCategoryParameters.FDQuery, nil);

          FFDQCategorySubParameters.Edit;
          FFDQCategorySubParameters.IDParent.AsInteger :=
            FFDQCategoryParameters.VID.AsInteger;
          FFDQCategorySubParameters.Post;
        end;
        qCategoryParameters.FDQuery.Next;
      end;
    finally
      qCategoryParameters.FDQuery.EnableControls;
    end;
  finally
    FreeAndNil(AFieldList);
  end;
  UpdateData;
end;

procedure TCategoryParametersGroup2.MoveParameters(IDArr: TArray<Integer>;
  TargetID: Integer; AUp: Boolean);
var
  ACloneW: TCategoryParameters2W;
  AID: Integer;
  L: TDictionary<Integer, Integer>;
  ACount: Integer;
  AIDList: TList<Integer>;
begin
  Assert(Length(IDArr) > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  AIDList := TList<Integer>.Create();
  L := TDictionary<Integer, Integer>.Create;
  try
    AIDList.AddRange(IDArr);
    AIDList.Add(TargetID);
    for AID in AIDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // ���������� ����������� �������

      qCategoryParameters.W.LocateByPK(AID, True);
      ACloneW := qCategoryParameters.CreateSubParamsClone;
      try
        while not ACloneW.DataSet.Eof do
        begin
          L.Add(ACloneW.ID.F.AsInteger, ACloneW.Ord.F.AsInteger);
          ACloneW.DataSet.Next;
        end;
      finally
        qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
      end;
    end;

    qCategoryParameters.W.Move(TMoveHelper.Move(L.ToArray, AUp, ACount));
  finally
    FreeAndNil(L);
    FreeAndNil(AIDList);
  end;
  LoadData;
end;

procedure TCategoryParametersGroup2.MoveSubParameters(IDArr: TArray<Integer>;
    TargetID: Integer; AUp: Boolean);
var
  ACloneW: TCategoryParameters2W;
  AID: Integer;
  L: TDictionary<Integer, Integer>;
  ACount: Integer;
  AIDList: TList<Integer>;
  ANewID: Integer;
  AVID: Integer;
begin
  Assert(Length(IDArr) > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  AIDList := TList<Integer>.Create();
  L := TDictionary<Integer, Integer>.Create;
  try
    AIDList.AddRange(IDArr);
    AIDList.Add(TargetID);

    for AID in AIDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // ���������� ����������� �������

      qCategoryParameters.W.LocateByPK(AID, True);
      L.Add(qCategoryParameters.W.PK.Value, qCategoryParameters.W.Ord.F.Value);
    end;

    ACloneW := qCategoryParameters.CreateSubParamsClone;
    try
      // ������������� ������� ������������
      AID := ACloneW.ID.F.AsInteger;
      // ������ ���������� �������
      qCategoryParameters.W.Move(TMoveHelper.Move(L.ToArray, AUp, ACount));
      ANewID := ACloneW.ID.F.AsInteger;
    finally
      qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
    end;

    // ���� � ���� �����������, �� ������ ����� ����� ������ �����������
    if ANewID <> AID then
    begin
      AVID := FIDDic[AID];
      FIDDic.Add(ANewID, AVID);
      FIDDic.Remove(AID);
    end;

  finally
    FreeAndNil(L);
    FreeAndNil(AIDList);
  end;

  LoadData;
end;

procedure TCategoryParametersGroup2.RefreshData;
begin
  qCategoryParameters.W.RefreshQuery;
  LoadData;
end;

procedure TCategoryParametersGroup2.RemoveClient;
begin
  FqCategoryParameters.RemoveClient;
end;

procedure TCategoryParametersGroup2.SetPos(AIDArray: TArray<Integer>;
  AWithSubParams: Boolean; APosID: Integer);
var
  ACloneW: TCategoryParameters2W;
  AID: Integer;
  AIDList: TList<Integer>;
begin
  AIDList := TList<Integer>.Create;
  try
    for AID in AIDArray do
    begin
      qCategoryParameters.W.LocateByPK(AID);
      if AWithSubParams then
      begin
        ACloneW := qCategoryParameters.CreateSubParamsClone;
        try
          while not ACloneW.DataSet.Eof do
          begin
            AIDList.Add(ACloneW.ID.F.AsInteger);
            ACloneW.DataSet.Next;
          end;
        finally
          qCategoryParameters.W.DropClone(ACloneW.DataSet as TFDMemTable);
        end;
      end
      else
        AIDList.Add(qCategoryParameters.W.PK.AsInteger);
    end;

    // ������ �������� ��������� ���� ���� �������
    qCategoryParameters.W.SetPos(AIDList.ToArray, APosID);

  finally
    FreeAndNil(AIDList);
  end;
  LoadData;
end;

procedure TCategoryParametersGroup2.UpdateData;
begin
  FDataLoading := True;
  FBeforeUpdateData.CallEventHandlers(Self);
  try
    qCatParams.Update(FFDQCategoryParameters);
    qCatSubParams.Update(FFDQCategorySubParameters);
  finally
    FAfterUpdateData.CallEventHandlers(Self);
    FDataLoading := False;
  end;
end;

procedure TCategoryFDMemTable.AppendFrom(ASource: TCategoryFDMemTable);
var
  F: TField;
begin
  Assert(ASource <> nil);
  Append;
  for F in Fields do
    F.Value := ASource.FieldByName(F.FieldName).Value;
  Post;
end;

procedure TCategoryFDMemTable.DeleteTail(AFromRecNo: Integer);
begin
  if RecordCount < AFromRecNo then
    Exit;

  DisableControls;
  try

    while RecordCount >= AFromRecNo do
    begin
      RecNo := AFromRecNo;
      Delete;
    end;

  finally
    EnableControls;
  end;
end;

function TCategoryFDMemTable.GetFieldValues(const AFieldName: string): String;
begin
  Result := '';
  First;
  while not Eof do
  begin
    Result := Result + IfThen(Result <> '', ',', '') +
      FieldByName(AFieldName).AsString;
    Next;
  end;
end;

function TCategoryFDMemTable.GetID: TField;
begin
  Result := FieldByName('ID');
end;

function TCategoryFDMemTable.GetIsAttribute: TField;
begin
  Result := FieldByName('IsAttribute');
end;

function TCategoryFDMemTable.GetOrd: TField;
begin
  Result := FieldByName('Ord');
end;

function TCategoryFDMemTable.GetPK: TField;
begin
  Result := ID;
end;

function TCategoryFDMemTable.GetPosID: TField;
begin
  Result := FieldByName('PosID');
end;

procedure TCategoryFDMemTable.LoadRecFrom(ADataSet: TDataSet;
  AFieldList: TStrings);
var
  AFieldName: String;
  AFL: TStrings;
  AUF: TDictionary<String, Variant>;
  F: TField;
  FF: TField;
  NeedEdit: Boolean;
begin
  Assert(ADataSet <> nil);
  Assert(ADataSet.RecordCount > 0);

  if AFieldList = nil then
  begin
    AFL := TStringList.Create;
    ADataSet.Fields.GetFieldNames(AFL);
  end
  else
    AFL := AFieldList;

  Assert(AFL.Count > 0);

  NeedEdit := False;

  AUF := TDictionary<String, Variant>.Create;
  try
    // ���� �� ���� �����
    for F in ADataSet.Fields do
    begin
      if AFL.IndexOf(F.FieldName) = -1 then
        Continue;

      FF := FindField(F.FieldName);
      if (FF <> nil) then
      begin
        NeedEdit := NeedEdit or (FF.Value <> F.Value);

        AUF.Add(FF.FieldName, F.Value);
      end;
    end;

    // ���� ���� ������������ ���������
    if NeedEdit then
    begin
      Append;

      for AFieldName in AUF.Keys do
      begin
        FieldByName(AFieldName).Value := AUF[AFieldName];
      end;

      Post;
    end;

  finally
    FreeAndNil(AUF);
    if AFieldList = nil then
      FreeAndNil(AFL);
  end;
end;

function TCategoryFDMemTable.LocateByField(const AFieldName: string;
  AValue: Variant; TestResult: Boolean = False): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := LocateEx(AFieldName, AValue);
  if TestResult then
    Assert(Result);
end;

function TCategoryFDMemTable.LocateByPK(AField: TField; AValue: Integer;
    TestResult: Boolean = False): Boolean;
begin
  Assert(AValue <> 0);
  Result := LocateEx(AField.FieldName, AValue);
  if TestResult then
    Assert(Result);
end;

procedure TCategoryFDMemTable.SetOrder(AOrder: Integer);
begin
  Assert(AOrder > 0);
  Assert(RecordCount > 0);
  Edit;
  Ord.AsInteger := AOrder;
  Post;
end;

procedure TCategoryFDMemTable.Update(ASource: TCategoryFDMemTable);
var
  AID: Integer;
begin
  Assert(ASource <> nil);

  DisableControls;
  try
    FInUpdate := True; // ������ ���� ��������������� � ���, ��� �� �����������
    AID := PK.AsInteger;
    ASource.First;
    while not ASource.Eof do
    begin
      // ���� ����� ������ � ��� ��� ���
      if not LocateByPK(ID, ASource.ID.AsInteger) then
        AppendFrom(ASource)
      else
        UpdateFrom(ASource);
      ASource.Next;
    end;

    // ������� ��, ���� ��� ���
    First;
    while not Eof do
    begin
      if not ASource.LocateByPK(ASource.ID, ID.AsInteger) then
        Delete
      else
        Next;
    end;

    if AID <> 0 then
      LocateByPK(PK, AID);
  finally
    FInUpdate := False;
    EnableControls;
  end;
end;

procedure TCategoryFDMemTable.UpdateFrom(ASource: TCategoryFDMemTable);
var
  AFieldName: string;
  F: TField;
  UpdatedFields: TDictionary<String, Variant>;
begin
  UpdatedFields := TDictionary<String, Variant>.Create;
  try
    Assert(ASource <> nil);
    for F in Fields do
    begin
      if F.Value <> ASource.FieldByName(F.FieldName).Value then
        UpdatedFields.Add(F.FieldName, ASource.FieldByName(F.FieldName).Value);
    end;

    if UpdatedFields.Count > 0 then
    begin
      // ���������� ���������� ������
      Edit;
      for AFieldName in UpdatedFields.Keys do
        FieldByName(AFieldName).Value := UpdatedFields[AFieldName];
      Post;
    end;

  finally
    FreeAndNil(UpdatedFields)
  end;
end;

procedure TCategoryFDMemTable.UpdatePK(APKDictionary
  : TDictionary<Integer, Integer>);
var
  AClone: TFDMemTable;
  AField: TField;
  AID: Integer;
begin
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(Self);
    AField := AClone.FieldByName(ID.FieldName);

    for AID in APKDictionary.Keys do
    begin
      if not AClone.LocateEx(ID.FieldName, AID) then
        Continue;

      AClone.Edit;
      AField.AsInteger := APKDictionary[AField.AsInteger];
      AClone.Post;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

constructor TQryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('VID', ftInteger);
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDParameter', ftInteger);
  FieldDefs.Add('Value', ftWideString, 200);
  FieldDefs.Add('TableName', ftWideString, 200);
  FieldDefs.Add('ValueT', ftWideString, 200);
  FieldDefs.Add('ParameterType', ftWideString, 30);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('IsDefault', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
  IndexFieldNames := Format('%s;%s', [PosID.FieldName, Ord.FieldName]);
end;

procedure TQryCategoryParameters.AppendR(AVID, AID, AIDParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType: String;
  AIsAttribute, AIsDefault, APosID, AOrd: Integer);
begin
  Append;
  VID.Value := AVID;
  ID.Value := AID;
  IDParameter.Value := AIDParameter;
  Value.Value := AValue;
  TableName.Value := ATableName;
  ValueT.Value := AValueT;
  ParameterType.Value := AParameterType;
  IsAttribute.Value := AIsAttribute;
  IsDefault.Value := AIsDefault;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

function TQryCategoryParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TQryCategoryParameters.GetIsDefault: TField;
begin
  Result := FieldByName('IsDefault');
end;

function TQryCategoryParameters.GetParameterType: TField;
begin
  Result := FieldByName('ParameterType');
end;

function TQryCategoryParameters.GetPK: TField;
begin
  Result := VID;
end;

function TQryCategoryParameters.GetTableName: TField;
begin
  Result := FieldByName('TableName');
end;

function TQryCategoryParameters.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

function TQryCategoryParameters.GetValueT: TField;
begin
  Result := FieldByName('ValueT');
end;

function TQryCategoryParameters.GetVID: TField;
begin
  Result := FieldByName('VID');
end;

function TQryCategoryParameters.LocateByParameterID(AIDParameter
  : Integer): Boolean;
begin
  Assert(AIDParameter > 0);
  Result := LocateEx(IDParameter.FieldName, AIDParameter);
end;

function TQryCategoryParameters.LocateByVID(AValue: Integer;
  TestResult: Boolean = False): Boolean;
begin
  Assert(AValue <> 0);
  Result := LocateEx(VID.FieldName, AValue);
  if TestResult then
    Assert(Result);
end;

constructor TQryCategorySubParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDParent', ftInteger);
  FieldDefs.Add('IDParameter', ftInteger);
  FieldDefs.Add('ParamSubParamID', ftInteger);
  FieldDefs.Add('IDSubParameter', ftInteger);
  FieldDefs.Add('Name', ftWideString, 200);
  FieldDefs.Add('Translation', ftWideString, 200);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
  IndexFieldNames := Format('%s;%s;%s', [IDParent.FieldName, PosID.FieldName,
    Ord.FieldName]);
end;

procedure TQryCategorySubParameters.AppendR(AID, AIDParent, AIDParameter,
  AParamSubParamId, AIDSubParameter: Integer; const AName, ATranslation: String;
  AIsAttribute, APosID, AOrd: Integer);
begin
  Append;
  ID.Value := AID;
  IDParent.Value := AIDParent;
  IDParameter.Value := AIDParameter;
  ParamSubParamID.Value := AParamSubParamId;
  IDSubParameter.Value := AIDSubParameter;
  Name.Value := AName;
  Translation.Value := ATranslation;
  IsAttribute.Value := AIsAttribute;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

procedure TQryCategorySubParameters.DeleteByIDParent(AIDCategoryParam: Integer);
begin
  Assert(AIDCategoryParam > 0);

  DisableControls;
  try
    while LocateEx(IDParent.FieldName, AIDCategoryParam) do
      Delete;
  finally
    EnableControls;
  end;
end;

procedure TQryCategorySubParameters.FilterByIDParent(AIDCategoryParam: Integer);
begin
  Assert(AIDCategoryParam <> 0);
  Filter := Format('%s = %d', [IDParent.FieldName, AIDCategoryParam]);
  Filtered := True;
end;

procedure TQryCategorySubParameters.FilterByIDParameter(AParameterID: Integer);
begin
  Assert(AParameterID <> 0);
  Filter := Format('%s = %d', [IDParameter.FieldName, AParameterID]);
  Filtered := True;
end;

function TQryCategorySubParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TQryCategorySubParameters.GetIDParent: TField;
begin
  Result := FieldByName('IDParent');
end;

function TQryCategorySubParameters.GetIDSubParameter: TField;
begin
  Result := FieldByName('IDSubParameter');
end;

function TQryCategorySubParameters.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TQryCategorySubParameters.GetParamSubParamID: TField;
begin
  Result := FieldByName('ParamSubParamID');
end;

function TQryCategorySubParameters.GetTranslation: TField;
begin
  Result := FieldByName('Translation');
end;

function TQryCategorySubParameters.Locate2(AIDParent, AIDSubParameter: Integer;
  TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParent > 0);
  Assert(AIDSubParameter > 0);

  AFieldNames := Format('%s;%s', [IDParent.FieldName,
    IDSubParameter.FieldName]);
  Result := LocateEx(AFieldNames, VarArrayOf([AIDParent, AIDSubParameter]));
  if TestResult then
    Assert(Result);
end;

end.
