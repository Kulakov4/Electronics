unit CategoryParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Data.DB, CategoryParametersQuery2,
  System.Generics.Collections, NotifyEvents, DBRecordHolder,
  SearchParamDefSubParamQuery, SearchParamSubParamQuery, DragHelper,
  ParamSubParamsQuery, System.Generics.Defaults, Trio, UpdateNegativeOrdQuery;

type
  TCategoryFDMemTable = class(TFDMemTable)
  private
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetPosID: TField;
  protected
    procedure DeleteTail(AFromRecNo: Integer);
    function LocateByField(const AFieldName: string; AValue: Variant;
      TestResult: Boolean = False): Boolean;
  public
    procedure AppendFrom(ASource: TCategoryFDMemTable);
    function GetFieldValues(const AFieldName: string): String;
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
    function LocateByPK(AValue: Integer; TestResult: Boolean = False): Boolean;
    procedure SetOrder(AOrder: Integer);
    procedure Update(ASource: TCategoryFDMemTable);
    procedure UpdateFrom(ASource: TCategoryFDMemTable);
    procedure UpdatePK(APKDictionary: TDictionary<Integer, Integer>);
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property PosID: TField read GetPosID;
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetIsDefault: TField;
    function GetParameterType: TField;
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

  TCategoryParametersGroup = class(TQueryGroup)
  private
    FAfterUpdateData: TNotifyEventsEx;
    FBeforeUpdateData: TNotifyEventsEx;
    FFDQCategoryParameters: TQryCategoryParameters;
    FqCategoryParameters: TQueryCategoryParameters2;
    FFDQCategorySubParameters: TQryCategorySubParameters;
    FIDDic: TDictionary<Integer, Integer>;
    FqCatParams: TQryCategoryParameters;
    FqCatSubParams: TQryCategorySubParameters;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParamSubParam: TQuerySearchParamSubParam;
    FqUpdNegativeOrd: TQueryUpdNegativeOrd;
    FVID: Integer;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsAllQuerysActive: Boolean;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParamSubParam: TQuerySearchParamSubParam;
    function GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
    { Private declarations }
  protected
    procedure AppendParameter(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName, ATranslation: String; AIsDefault: Integer);
    procedure AppendSubParameter(AID, ASubParamID: Integer);
    procedure DeleteParameter(AIDParameter: Integer);
    function GetVirtualID(AID: Integer; AUseDic: Boolean): Integer;
    procedure Move(AArray: TArray<TPair<Integer, Integer>>; AUp: Boolean;
      ACount: Integer);
    procedure MoveSubParam(AArray: TArray<TCategoryParamsRec>; AUp: Boolean;
      ACount: Integer);
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParamSubParam: TQuerySearchParamSubParam
      read GetqSearchParamSubParam;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddOrDeleteSubParameters(AID: Integer; ASubParamIDList: string);
    procedure AddOrDeleteParameters(AParamIDList: string; APosID: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DeleteParameters(APKValues: array of Variant);
    procedure DeleteSubParameters(APKValues: array of Variant);
    procedure UpdateData;
    procedure LoadData;
    procedure MoveParameters(IDList: TList<Integer>; TargetID: Integer;
      AUp: Boolean);
    procedure MoveSubParameters(IDList: TList<Integer>; TargetID: Integer;
      AUp: Boolean);
    property AfterUpdateData: TNotifyEventsEx read FAfterUpdateData;
    property BeforeUpdateData: TNotifyEventsEx read FBeforeUpdateData;
    property IsAllQuerysActive: Boolean read GetIsAllQuerysActive;
    property qCategoryParameters: TQueryCategoryParameters2
      read FqCategoryParameters;
    property qCatParams: TQryCategoryParameters read FqCatParams;
    property qCatSubParams: TQryCategorySubParameters read FqCatSubParams;
    property qUpdNegativeOrd: TQueryUpdNegativeOrd read GetqUpdNegativeOrd;
    { Public declarations }
  end;

implementation

uses
  System.StrUtils, System.Math;

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

constructor TCategoryParametersGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqCategoryParameters := TQueryCategoryParameters2.Create(Self);
  FFDQCategoryParameters := TQryCategoryParameters.Create(Self);
  FFDQCategorySubParameters := TQryCategorySubParameters.Create(Self);

  FqCatParams := TQryCategoryParameters.Create(Self);
  FqCatSubParams := TQryCategorySubParameters.Create(Self);

  TNotifyEventWrap.Create(FqCategoryParameters.AfterLoad, DoAfterLoad);

  FBeforeUpdateData := TNotifyEventsEx.Create(Self);
  FAfterUpdateData := TNotifyEventsEx.Create(Self);
  FIDDic := TDictionary<Integer, Integer>.Create;
end;

procedure TCategoryParametersGroup.AddOrDeleteSubParameters(AID: Integer;
  ASubParamIDList: string);
var
  AClone: TFDMemTable;
  AIDParameter: Integer;
  m: TArray<String>;
  S: String;
  S2: string;
  S1: String;
begin
  // ����� �������� ��� ������� ������������

  // ���� ������ ���������-��������
  qCategoryParameters.LocateByPK(AID, True);
  AIDParameter := qCategoryParameters.IDParameter.AsInteger;

  // ������ ����, ���������� ��� ������������ ������ ���������
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
      qCategoryParameters.Locate(AIDParameter, S.ToInteger, True);
      // ������� ����� �����������
      DeleteSubParameters([qCategoryParameters.PK.AsInteger]);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.AddOrDeleteParameters(AParamIDList: string;
  APosID: Integer);
var
  AIDParam: String;
  m: TArray<String>;
  S: string;
begin
  // ����� �������� ��� ������� ���������

  // ������ ��������������� ���������� ����� ���������, ������� �� ����� �������������!
  qCategoryParameters.FilterByIsDefault(1);
  try
    S := Format(',%s,',
      [qCategoryParameters.GetFieldValues(qCategoryParameters.IDParameter.
      FieldName)]);
  finally
    qCategoryParameters.FDQuery.Filtered := False;
  end;

  m := S.Trim([',']).Split([',']);
  // ���� �� ���������� ��� ���������
  for AIDParam in m do
  begin
    // ���� ������� � ������ �� ���������� ��������� �����
    if AParamIDList.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      DeleteParameter(AIDParam.ToInteger());
    end;
  end;

  m := AParamIDList.Trim([',']).Split([',']);
  // ���� �� ���������� � ����������� �������������
  for AIDParam in m do
  begin
    // ���� ������� ���������
    if S.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      // ���� ������ ���������� �� ���� ���������
      qSearchParamDefSubParam.SearchByID(AIDParam.ToInteger, 1);

      // ��������� ��������
      AppendParameter(qSearchParamDefSubParam.ParamSubParamID.Value,
        qCategoryParameters.NextOrder, 1, APosID,
        qSearchParamDefSubParam.PK.Value,
        qSearchParamDefSubParam.IDSubParameter.Value,
        qSearchParamDefSubParam.Value.Value,
        qSearchParamDefSubParam.TableName.Value,
        qSearchParamDefSubParam.ValueT.Value,
        qSearchParamDefSubParam.ParameterType.Value, '', '', 1);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.AppendParameter(AParamSubParamId, AOrd,
  AIsAttribute, APosID, AIDParameter, AIDSubParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType, AName,
  ATranslation: String; AIsDefault: Integer);
begin

  // ������� ��������� ��� � "�������" ������, ����� �� ���� ���-�� �������� ID
  // ��� ���������� � �� ID ����� �������
  FqCategoryParameters.AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
    AIDParameter, AIDSubParameter, AValue, ATableName, AValueT, AParameterType,
    AName, ATranslation, AIsDefault);
{
  // ����� ������� �� �� ������ � ���������
  FFDQCategoryParameters.AppendR(GetVirtualID(FqCategoryParameters.PK.Value,
    False), FqCategoryParameters.PK.Value, AIDParameter, AValue, ATableName,
    AValueT, AParameterType, AIsAttribute, AIsDefault, APosID, AOrd);
}
end;

procedure TCategoryParametersGroup.AppendSubParameter(AID,
  ASubParamID: Integer);
var
  AClone: TFDMemTable;
  AOrder: Integer;
  APosID: Integer;
  rc: Integer;
begin
  Assert(AID <> 0);
  Assert(ASubParamID > 0);

  // ���� ������ ���������-��������
  FFDQCategoryParameters.LocateByPK(AID, True);
  qCategoryParameters.LocateByPK(AID, True);

  // ����� �������� ����������� � ���������, ���� � ���� ��� ��� �� ����
  rc := qParamSubParams.SearchBySubParam
    (FFDQCategoryParameters.IDParameter.AsInteger, ASubParamID);
  // ���� � ����� ��������� ��� ������ ������������
  if rc = 0 then
  begin
    qParamSubParams.AppendSubParameter
      (FFDQCategoryParameters.IDParameter.AsInteger, ASubParamID);

    Assert(qParamSubParams.FDQuery.RecordCount > 0);
  end;

  // �������� ������ ���������� � ���� ������������
  qSearchParamSubParam.SearchByID(qParamSubParams.PK.Value, 1);

  // ������� ������������ �������� ���������
  AClone := qCategoryParameters.CreateSubParamsClone;
  try
    // ���� ���� �������� ��� �� ����� �������������
    if (AClone.RecordCount = 1) and (qCategoryParameters.IsDefault.AsInteger = 1) then
    begin
      // ���� �������� ����������� �� ��������� �� ����������� �����������
      qCategoryParameters.TryEdit;
      qCategoryParameters.ParamSubParamID.AsInteger := qParamSubParams.PK.Value;
      qCategoryParameters.Name.Value := qParamSubParams.Name.Value;
      qCategoryParameters.Translation.Value :=
        qParamSubParams.Translation.Value;
      qCategoryParameters.IsDefault.AsInteger := 0;
      qCategoryParameters.TryPost;
    end
    else
    begin
      // ��������� ����������� ����� � �����!
      AClone.Last;
      // ����� �������� �������
      AOrder := AClone.FieldByName(qCategoryParameters.Ord.FieldName)
        .AsInteger + 1;
      APosID := qCategoryParameters.PosID.AsInteger;
      // �������� �������� ������� ���� ����������/������������� �� 1.
      // ��� ��������� ����!
      qCategoryParameters.IncOrder(AOrder);

      // ��������� �����������
      qCategoryParameters.AppendR(qSearchParamSubParam.PK.Value, AOrder, 1,
        APosID, qSearchParamSubParam.IDParameter.Value,
        qSearchParamSubParam.IDSubParameter.Value,
        qSearchParamSubParam.Value.Value, qSearchParamSubParam.TableName.Value,
        qSearchParamSubParam.ValueT.Value,
        qSearchParamSubParam.ParameterType.Value,
        qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
        qSearchParamSubParam.IsDefault.Value);

    end;
  finally
    qCategoryParameters.DropClone(AClone);
  end;

(*

  // ���� ���������, ���� ���������
  // ���� ���� �������� ��� ����� ������������
  if qCategoryParameters.IsDefault.AsInteger = 0 then
  begin
    // ���� ������� ������� ������������� ���� �� 1
    APosID := FFDQCategoryParameters.PosID.AsInteger;
    AIDParameter := FFDQCategoryParameters.IDParameter.AsInteger;
    AOrder := FFDQCategoryParameters.Ord.AsInteger;

    // �������� ������������ ������ �������� ��������� (� ������, � ��������)
    qCategoryParameters.FilterByPosition(APosID);
    try
      Assert(qCategoryParameters.FDQuery.RecordCount > 0);

      // ���� ������ ����������� ������ ���������
      qCategoryParameters.Locate(AIDParameter, APosID, AOrder, True);

      // ���� �����, ���� ����� ��������� �����������
      while (not qCategoryParameters.FDQuery.EOF) and
        (qCategoryParameters.IDParameter.AsInteger = AIDParameter) do
      begin
        qCategoryParameters.FDQuery.Next;
      end;
      // ���� ��������� ����������� ����� � ����� �����
      if (qCategoryParameters.FDQuery.EOF) then
      begin
        AOrder := qCategoryParameters.NextOrder;
      end
      else
      begin
        // ���� ��������� ����� � �������� ������-���� ��������� (� ������, � �����)
        // ����� �������� �� ��� ���� ����
        Assert(qCategoryParameters.IDParameter.AsInteger <> AIDParameter);
        qCategoryParameters.FDQuery.Prior;
        Assert(qCategoryParameters.IDParameter.AsInteger = AIDParameter);
        ID := qCategoryParameters.PK.Value;
        // �� ��� ����, ����� ���������� ����
        qCategoryParameters.FDQuery.Last;
        ANewOrder := qCategoryParameters.Ord.AsInteger + 1;
        while qCategoryParameters.PK.Value <> ID do
        begin
          AOrder := qCategoryParameters.Ord.AsInteger;
          // ������ ������� � "��"
          qCategoryParameters.TryEdit;
          qCategoryParameters.Ord.AsInteger := ANewOrder;
          qCategoryParameters.TryPost;

          // ���� �������� ��������� ��������� "�� ���������"
          if qCategoryParameters.IsDefault.AsInteger = 1 then
          begin
            FFDQCategoryParameters.LocateByPK
              (qCategoryParameters.PK.Value, True);
            FFDQCategoryParameters.SetOrder(ANewOrder);
          end
          else
          begin // ���� �������� ��������� � ������������
            FFDQCategorySubParameters.LocateByPK
              (qCategoryParameters.PK.Value, True);
            FFDQCategorySubParameters.SetOrder(ANewOrder);

            FFDQCategoryParameters.LocateByVID
              (FFDQCategorySubParameters.IDParent.AsInteger);
            // ���� ����������� ������ � ������
            if FFDQCategoryParameters.ID.AsInteger = FFDQCategorySubParameters.
              ID.AsInteger then
            begin
              FFDQCategoryParameters.SetOrder(ANewOrder);
            end;
          end;
          ANewOrder := AOrder;
          // ��������� �� ���� ������ �����
          qCategoryParameters.FDQuery.Prior;
        end;
      end;
    finally
      // ���������� ������
      qCategoryParameters.FDQuery.Filtered := False;
    end;

    // ��������� ����������� � "�������" �����
    qCategoryParameters.AppendR(qSearchParamSubParam.PK.Value, AOrder, 1,
      APosID, qSearchParamSubParam.IDParameter.Value,
      qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Value.Value, qSearchParamSubParam.TableName.Value,
      qSearchParamSubParam.ValueT.Value,
      qSearchParamSubParam.ParameterType.Value, qSearchParamSubParam.Name.Value,
      qSearchParamSubParam.Translation.Value,
      qSearchParamSubParam.IsDefault.Value);

    FFDQCategorySubParameters.AppendR(qCategoryParameters.PK.Value, FIDDic[AID],
      qSearchParamSubParam.IDParameter.Value, qSearchParamSubParam.PK.Value,
      qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
      qCategoryParameters.IsAttribute.Value, APosID, AOrder);
  end
  else
  begin
    // ��� ������ ����������� �����������
    // ���� �������� ����������� �� ��������� �� ����
    // ���� ����������� "�� ���������" ������ ���������
    qCategoryParameters.LocateByPK(AID, True);
    Assert(qCategoryParameters.IsDefault.AsInteger = 1);

    // ������ ����������� "�� ���������" �� ���������
    qCategoryParameters.TryEdit;
    qCategoryParameters.ParamSubParamID.AsInteger := qParamSubParams.PK.Value;
    qCategoryParameters.Name.Value := qParamSubParams.Name.Value;
    qCategoryParameters.Translation.Value := qParamSubParams.Translation.Value;
    qCategoryParameters.IsDefault.AsInteger := 0;
    qCategoryParameters.TryPost;

    // ��������� �����������
    FFDQCategorySubParameters.AppendR(AID, FFDQCategoryParameters.VID.Value,
      FFDQCategoryParameters.IDParameter.Value, qParamSubParams.PK.Value,
      qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
      FFDQCategoryParameters.IsAttribute.Value,
      FFDQCategoryParameters.PosID.Value, FFDQCategoryParameters.Ord.AsInteger);
  end;
*)
end;

procedure TCategoryParametersGroup.ApplyUpdates;
var
  AID: Integer;
  AKey: Integer;
  VID: Integer;
begin
  // ��� ��� ��������� ��������� ���������� ���������� �� ���� ��
  FqCategoryParameters.ApplyUpdates;

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
    // UpdateData;
  end;
end;

procedure TCategoryParametersGroup.CancelUpdates;
begin
  // ��� ��� ��������� ��������� ����������
  FqCategoryParameters.CancelUpdates;

  LoadData;
end;

procedure TCategoryParametersGroup.DeleteParameters
  (APKValues: array of Variant);
var
  ADeletedID: TList<Integer>;
  AID: Variant;
begin
  ADeletedID := TList<Integer>.Create;

  FFDQCategoryParameters.DisableControls;
  try
    for AID in APKValues do
    begin
      // ���� � ��������� ���� ������������
      while FFDQCategorySubParameters.LocateEx
        (FFDQCategorySubParameters.IDParent.FieldName, AID) do
      begin
        // ������� �� "��������" ������, ���� ��� �� �������
        if (ADeletedID.IndexOf(FFDQCategorySubParameters.ID.AsInteger) = -1)
        then
        begin
          qCategoryParameters.LocateByPK
            (FFDQCategorySubParameters.ID.AsInteger, True);

          qCategoryParameters.FDQuery.Delete;
        end;
        // ������� �� �������������
        FFDQCategorySubParameters.Delete;
      end;

      // ������� �� ����������
      FFDQCategoryParameters.LocateByPK(AID, True);
      FFDQCategoryParameters.Delete;

      // ������� �� "��������" ������, ���� ��� �� �������
      if (ADeletedID.IndexOf(AID) = -1) then
      begin
        qCategoryParameters.LocateByPK(AID, True);
        qCategoryParameters.FDQuery.Delete;
      end;
    end;
  finally
    FFDQCategoryParameters.EnableControls;
    FreeAndNil(ADeletedID);
  end;

  UpdateData;
end;

procedure TCategoryParametersGroup.DeleteSubParameters
  (APKValues: array of Variant);
var
  AClone: TFDMemTable;
  AID: Variant;
  VID: Integer;
begin
  for AID in APKValues do
  begin
    qCategoryParameters.LocateByPK(AID, True);
    AClone := qCategoryParameters.CreateSubParamsClone;
    try
      // ���� ���� �������� ���� ����������� �����������
      if AClone.RecordCount = 1 then
      begin
        // �������� ���������� � ���, ����� ����������� "�� ���������" � ������ ���������
        qSearchParamDefSubParam.SearchByID
          (qCategoryParameters.IDParameter.AsInteger, 1);

        qCategoryParameters.TryEdit;
        // ������ ������ �� ��������� � ���������� �����������
        qCategoryParameters.ParamSubParamID.Value :=
          qSearchParamDefSubParam.ParamSubParamID.Value;
        qCategoryParameters.IDSubParameter.Value :=
          qSearchParamDefSubParam.IDSubParameter.Value;
        qCategoryParameters.IsDefault.AsInteger := 1;
        qCategoryParameters.Name.Value := qSearchParamDefSubParam.Name.Value;
        qCategoryParameters.Translation.Value :=
          qSearchParamDefSubParam.Translation.Value;
        qCategoryParameters.TryPost;
      end
      else
      begin
        // ������� �����������;
        qCategoryParameters.FDQuery.Delete;
        Assert(AClone.RecordCount > 0);
        // ���� �� ������� ������ �����������
        if FIDDic.ContainsKey(AID) then
        begin
          // ����������� ID �����. ���������
          VID := FIDDic[AID];
          FIDDic.Remove(AID);
          // ��������� ������������� ������� ������������
          FIDDic.Add(AClone.FieldByName(qCategoryParameters.PKFieldName)
            .AsInteger, VID);
        end;
      end;
    finally
      qCategoryParameters.DropClone(AClone);
    end;
  end;

  LoadData;
end;

// ��������� ������� �������� ������ �� ����� ��� ��������������
procedure TCategoryParametersGroup.DeleteParameter(AIDParameter: Integer);
begin
  Assert(AIDParameter > 0);

  FFDQCategoryParameters.DisableControls;
  try
    while FFDQCategoryParameters.LocateByParameterID(AIDParameter) do
    begin
      // ������� ���� ������� ��� �����������
      FFDQCategorySubParameters.DeleteByIDParent
        (FFDQCategoryParameters.ID.AsInteger);
      // ����� ������� ��� ��������
      FFDQCategoryParameters.Delete;
    end;
  finally
    FFDQCategoryParameters.EnableControls;
  end;

  // ������� �� "��������" �������
  FqCategoryParameters.FDQuery.DisableControls;
  try
    while FqCategoryParameters.LocateByField
      (FqCategoryParameters.IDParameter.FieldName, AIDParameter) do
      FqCategoryParameters.FDQuery.Delete;
  finally
    FqCategoryParameters.FDQuery.EnableControls;
  end;
end;

procedure TCategoryParametersGroup.DoAfterLoad(Sender: TObject);
begin
  FVID := 0;
  FIDDic.Clear;
  LoadData;
end;

function TCategoryParametersGroup.GetIsAllQuerysActive: Boolean;
begin
  Result := qCategoryParameters.FDQuery.Active and
    FFDQCategoryParameters.Active and FFDQCategorySubParameters.Active;
end;

function TCategoryParametersGroup.GetVirtualID(AID: Integer;
  AUseDic: Boolean): Integer;
begin
  Assert(not AUseDic or (AUseDic and (FIDDic.Count > 0)));

  // ���� �������� ������������ �������������� ���� �� �������
  if AUseDic then
  begin
    if FIDDic.ContainsKey(AID) then
      Result := FIDDic[AID]
    else
      Result := 0;
  end
  else
  begin
    Assert(FVID >= 0);
    Inc(FVID);
    FIDDic.Add(AID, FVID);
    Result := FVID;
  end;
end;

function TCategoryParametersGroup.GetqParamSubParams: TQueryParamSubParams;
begin
  if FqParamSubParams = nil then
    FqParamSubParams := TQueryParamSubParams.Create(Self);
  Result := FqParamSubParams;
end;

function TCategoryParametersGroup.GetqSearchParamDefSubParam
  : TQuerySearchParamDefSubParam;
begin
  if FqSearchParamDefSubParam = nil then
    FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create(Self);
  Result := FqSearchParamDefSubParam;
end;

function TCategoryParametersGroup.GetqSearchParamSubParam
  : TQuerySearchParamSubParam;
begin
  if FqSearchParamSubParam = nil then
    FqSearchParamSubParam := TQuerySearchParamSubParam.Create(Self);

  Result := FqSearchParamSubParam;
end;

function TCategoryParametersGroup.GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
begin
  if FqUpdNegativeOrd = nil then
    FqUpdNegativeOrd := TQueryUpdNegativeOrd.Create(Self);
  Result := FqUpdNegativeOrd;
end;

procedure TCategoryParametersGroup.UpdateData;
begin
  FBeforeUpdateData.CallEventHandlers(Self);
  try
    qCatParams.Update(FFDQCategoryParameters);
    qCatSubParams.Update(FFDQCategorySubParameters);
  finally
    FAfterUpdateData.CallEventHandlers(Self);
  end;
end;

procedure TCategoryParametersGroup.LoadData;
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
      while not qCategoryParameters.FDQuery.EOF do
      begin
        FFDQCategoryParameters.LoadRecFrom(qCategoryParameters.FDQuery,
          AFieldList);
        if FFDQCategoryParameters.ID.IsNull then
        begin
          VID := GetVirtualID(qCategoryParameters.PK.AsInteger, AUseDic);
          FFDQCategoryParameters.Edit;
          FFDQCategoryParameters.VID.AsInteger := VID;
          FFDQCategoryParameters.ID.AsInteger :=
            qCategoryParameters.PK.AsInteger;
          FFDQCategoryParameters.IsAttribute.Value :=
            qCategoryParameters.IsAttribute.Value;
          FFDQCategoryParameters.Ord.Value := qCategoryParameters.Ord.Value;
          FFDQCategoryParameters.Post;
        end;

        if qCategoryParameters.IsDefault.AsInteger = 0 then
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

procedure TCategoryParametersGroup.Move(AArray: TArray<TPair<Integer, Integer>>;
  AUp: Boolean; ACount: Integer);
var
  Coef: Integer;
  AComparer: IComparer<TPair<Integer, Integer>>;
  ATargetCount: Integer;
  I: Integer;
  J: Integer;
  L: TList<TPair<Integer, Integer>>;
begin
  Assert(ACount > 0);
  ATargetCount := Length(AArray) - ACount;
  Assert(ATargetCount > 0);

  Coef := IfThen(AUp, 1, -1);
  // ��������� �� ����������� ��� ��������
  AComparer := TComparer < TPair < Integer, Integer >>.Construct(
    function(const Left, Right: TPair<Integer, Integer>): Integer
    begin
      Result := 0;
      if Left.Value < Right.Value then
        Result := -1 * Coef
      else if Left.Value > Right.Value then
        Result := Coef;
    end);

  TArray.Sort < TPair < Integer, Integer >> (AArray, AComparer);

  // ��������� � ������������ �������

  L := TList < TPair < Integer, Integer >>.Create;
  try
    {
      // 1) ������ ������� �� ���������������
      for I := 0 to ATargetCount - 1 do
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, -AArray[I].Value));
    }
    // 2) �������� ������ ����� (����)
    J := 0;
    for I := ATargetCount to Length(AArray) - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, AArray[J].Value));
      Inc(J);
    end;
    // 3) �������� ������ �� �������������� �����
    for I := 0 to ATargetCount - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TPair<Integer, Integer>.Create(AArray[I].Key, AArray[J].Value));
      Inc(J);
    end;
    // ��������� ����������� ��������� � ��
    qCategoryParameters.Move(L.ToArray);
  finally
    FreeAndNil(L);
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.MoveSubParam
  (AArray: TArray<TCategoryParamsRec>; AUp: Boolean; ACount: Integer);
var
  Coef: Integer;
  AComparer: IComparer<TCategoryParamsRec>;
  ATargetCount: Integer;
  I: Integer;
  J: Integer;
  L: TList<TCategoryParamsRec>;
begin
  Assert(ACount > 0);
  ATargetCount := Length(AArray) - ACount;
  Assert(ATargetCount > 0);

  Coef := IfThen(AUp, 1, -1);
  // ��������� �� ����������� ��� ��������
  AComparer := TComparer<TCategoryParamsRec>.Construct(
    function(const Left, Right: TCategoryParamsRec): Integer
    begin
      Result := 0;
      if Left.Order < Right.Order then
        Result := -1 * Coef
      else if Left.Order > Right.Order then
        Result := Coef;
    end);

  TArray.Sort<TCategoryParamsRec>(AArray, AComparer);

  // ��������� � ������������ �������

  L := TList<TCategoryParamsRec>.Create;
  try
    // 1) �������� ������ ����� (����)
    J := 0;
    for I := ATargetCount to Length(AArray) - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TCategoryParamsRec.Create(AArray[I].ID, AArray[J].ParamSubParamID,
        AArray[J].Order, AArray[J].IsAttribute, AArray[J].IDParameter,
        AArray[J].IDSubParameter, AArray[J].Name, AArray[J].Translation,
        AArray[J].IsDefault));
      Inc(J);
    end;
    // 3) �������� ������ �� �������������� �����
    for I := 0 to ATargetCount - 1 do
    begin
      Assert(J < Length(AArray));
      L.Add(TCategoryParamsRec.Create(AArray[I].ID, AArray[J].ParamSubParamID,
        AArray[J].Order, AArray[J].IsAttribute, AArray[J].IDParameter,
        AArray[J].IDSubParameter, AArray[J].Name, AArray[J].Translation,
        AArray[J].IsDefault));
      Inc(J);
    end;
    // ��������� ����������� ��������� � ��
    qCategoryParameters.MoveSubParam(L.ToArray);
  finally
    FreeAndNil(L);
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.MoveParameters(IDList: TList<Integer>;
TargetID: Integer; AUp: Boolean);
var
  AID: Integer;
  L: TDictionary<Integer, Integer>;
  ACount: Integer;
begin
  Assert(IDList.Count > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  L := TDictionary<Integer, Integer>.Create;
  try
    IDList.Add(TargetID);
    for AID in IDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // ���������� ����������� �������

      FFDQCategorySubParameters.FilterByIDParent(AID);
      // ���� � ������ ��������� ���� ������������
      if FFDQCategorySubParameters.RecordCount > 0 then
      begin
        FFDQCategorySubParameters.First;
        while not FFDQCategorySubParameters.EOF do
        begin
          L.Add(FFDQCategorySubParameters.ID.AsInteger,
            FFDQCategorySubParameters.Ord.AsInteger);
          FFDQCategorySubParameters.Next;
        end;
      end
      else
      begin
        FFDQCategoryParameters.LocateByPK(AID, True);
        L.Add(FFDQCategoryParameters.ID.AsInteger,
          FFDQCategoryParameters.Ord.AsInteger);
      end;
    end;
    FFDQCategorySubParameters.Filtered := False;

    Move(L.ToArray, AUp, ACount);
  finally
    FreeAndNil(L);
  end;
end;

procedure TCategoryParametersGroup.MoveSubParameters(IDList: TList<Integer>;
TargetID: Integer; AUp: Boolean);
var
  AID: Integer;
  L: TList<TCategoryParamsRec>;
  ACount: Integer;
begin
  Assert(IDList.Count > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  L := TList<TCategoryParamsRec>.Create;
  try
    IDList.Add(TargetID);
    for AID in IDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // ���������� ����������� �������

      FFDQCategorySubParameters.LocateByPK(AID, True);
      L.Add(TCategoryParamsRec.Create(FFDQCategorySubParameters.ID.AsInteger,
        FFDQCategorySubParameters.ParamSubParamID.AsInteger,
        FFDQCategorySubParameters.Ord.AsInteger,
        FFDQCategorySubParameters.IsAttribute.AsInteger,
        FFDQCategorySubParameters.IDParameter.AsInteger,
        FFDQCategorySubParameters.IDSubParameter.AsInteger,
        FFDQCategorySubParameters.Name.AsString,
        FFDQCategorySubParameters.Translation.AsString, 0));
    end;

    MoveSubParam(L.ToArray, AUp, ACount);
  finally
    FreeAndNil(L);
  end;

  LoadData;
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
  while not EOF do
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

function TCategoryFDMemTable.LocateByPK(AValue: Integer;
TestResult: Boolean = False): Boolean;
begin
  Assert(AValue <> 0);
  Result := LocateEx(ID.FieldName, AValue);
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
    AID := ID.AsInteger;
    ASource.First;
    while not ASource.EOF do
    begin
      // ���� ����� ������ � ��� ��� ���
      if not LocateByPK(ASource.ID.AsInteger) then
        AppendFrom(ASource)
      else
        UpdateFrom(ASource);
      ASource.Next;
    end;

    // ������� ��, ���� ��� ���
    First;
    while not EOF do
    begin
      if not ASource.LocateByPK(ID.AsInteger) then
        Delete
      else
        Next;
    end;

    if AID <> 0 then
      LocateByPK(AID);
  finally
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

{$R *.dfm}

end.
