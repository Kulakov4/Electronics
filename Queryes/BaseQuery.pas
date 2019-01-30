unit BaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections, DBRecordHolder;

type
  TParamRec = record
    FieldName: String;
    Value: Variant;
    DataType: TFieldType;
    CaseInsensitive: Boolean;
    FullName: String;
    Operation: String;
  public
    constructor Create(const AFullName: String; const AValue: Variant;
      const ADataType: TFieldType = ftInteger;
      const ACaseInsensitive: Boolean = False; const AOperation: String = '=');
  end;

  TQueryBase = class(TFrame)
    FDQuery: TFDQuery;
    Label1: TLabel;
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
  private
    FAfterLoad: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FBookmark: Variant;
    FDetailParameterName: string;
    FFDUpdateSQL: TFDUpdateSQL;
    FMaxUpdateRecCount: Integer;
    FSQL: string;
    FUpdateRecCount: Integer;
  class var
    function GetCashedRecordBalance: Integer;
    function GetFDUpdateSQL: TFDUpdateSQL;
    function GetParentValue: Integer;
    function GetPK: TField;
    { Private declarations }
  protected
    FEventList: TObjectList;
    FPKFieldName: String;
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure DeleteSelfDetail(AIDMaster: Variant); virtual;
    // TODO: DoOnNeedPost
    // procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    procedure DoOnUpdateRecordException(AException: Exception); virtual;
    procedure FDQueryUpdateRecordOnClient(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    function GetHaveAnyChanges: Boolean; virtual;
    function GetHaveAnyNotCommitedChanges: Boolean; virtual;
    property FDUpdateSQL: TFDUpdateSQL read GetFDUpdateSQL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure CascadeDelete(const AIDMaster: Variant;
      const ADetailKeyFieldName: String;
      AFromClientOnly: Boolean = False); virtual;
    procedure ClearUpdateRecCount;
    procedure CreateDefaultFields(AUpdate: Boolean);
    function Delete(APKValue: Variant): Boolean;
    procedure DeleteAll;
    procedure DeleteByFilter(const AFilterExpression: string);
    procedure FetchFields(const AFieldNames: TArray<String>;
      const AValues: TArray<Variant>; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); overload;
    procedure FetchFields(ARecordHolder: TRecordHolder;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions); overload;
    function Field(const AFieldName: String): TField;
    function GetFieldValues(AFieldName: string;
      ADelimiter: String = ','): String;
    function GetFieldValuesAsIntArray(AFieldName: string): TArray<Integer>;
    procedure IncUpdateRecCount;
    procedure Load(AIDParent: Integer; AForcibly: Boolean = False);
      overload; virtual;
    procedure Load(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>); overload;
    function LocateByField(const AFieldName: string; const AValue: Variant;
      AOptions: TFDDataSetLocateOptions = [lxoCaseInsensitive, lxoPartialKey]
      ): Boolean;
    procedure SetParameters(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>);
    function LocateByPK(APKValue: Variant; TestResult: Boolean = False)
      : Boolean;
    procedure LocateByPKAndDelete(APKValue: Variant);
    procedure RefreshQuery; virtual;
    function RestoreBookmark: Boolean;
    procedure SaveBookmark;
    function Search(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>; TestResult: Integer = -1)
      : Integer; overload;
    function SearchEx(AParams: TArray<TParamRec>;
      TestResult: Integer = -1): Integer;
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsReadOnly(AReadOnly: Boolean);
    function SetParamType(const AParamName: String; AParamType: TParamType =
        ptInput; ADataType: TFieldType = ftInteger): TFDParam;
    function SetParamTypeEx(const AParamName: String; AValue: Variant; AParamType:
        TParamType = ptInput; ADataType: TFieldType = ftInteger): TFDParam;
// TODO: TryEdit
//  function TryEdit: Boolean;
    procedure TryPost; virtual;
    procedure TryCancel;
    procedure TryOpen;
    procedure UpdateFields(AFields: TArray<TField>; AValues: TArray<Variant>;
      AUpdateNullFieldsOnly: Boolean);
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property ParentValue: Integer read GetParentValue;
    property PK: TField read GetPK;
    property PKFieldName: String read FPKFieldName;
    property SQL: string read FSQL;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule, StrHelper, MapFieldsUnit,
  System.StrUtils;

{$R *.dfm}
{ TfrmDataModule }

constructor TQueryBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // ������ ������ ����� ����������� �� �������
  FEventList := TObjectList.Create;

  FPKFieldName := 'ID';

  // ������ �������
  FBeforeLoad := TNotifyEventsEx.Create(Self);
  FAfterLoad := TNotifyEventsEx.Create(Self);

  // ������������ ���������� ���������� ������� � ������ ����� ����������
  FMaxUpdateRecCount := 1000;
end;

destructor TQueryBase.Destroy;
begin
  FreeAndNil(FEventList); // ������������ �� ���� �������
  FreeAndNil(FBeforeLoad);
  FreeAndNil(FAfterLoad);
  inherited;
end;

procedure TQueryBase.AfterConstruction;
begin
  inherited;
  // ��������� �������������� SQL
  FSQL := FDQuery.SQL.Text;
end;

procedure TQueryBase.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQueryBase.ApplyUpdates;
begin
  TryPost;
  if FDQuery.CachedUpdates then
  begin
    // ���� ��� ��������� ������ ��� ������
    if FDQuery.ApplyUpdates() = 0 then
      FDQuery.CommitUpdates;
  end
end;

// ����-�� ��������� �� ����������� � ��
function TQueryBase.GetHaveAnyChanges: Boolean;
begin
  Result := FDQuery.State in [dsEdit, dsInsert];
  if Result then
    Exit;

  // ���� ��� ��������� ���������� �� ������� �������
  if FDQuery.CachedUpdates then
  begin
    Result := FDQuery.ChangeCount > 0;
  end
  else
  begin
    // ���� ���������� �� ���������
    Result := FDQuery.Connection.InTransaction and GetHaveAnyNotCommitedChanges;
  end;

end;

procedure TQueryBase.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  if FDQuery.CachedUpdates then
  begin
    FDQuery.CancelUpdates;
  end
end;

procedure TQueryBase.CascadeDelete(const AIDMaster: Variant;
  const ADetailKeyFieldName: String; AFromClientOnly: Boolean = False);
var
  E: TFDUpdateRecordEvent;
begin
  Assert(AIDMaster > 0);

  E := FDQuery.OnUpdateRecord;
  try
    // ���� ��������� �������� ��� ����������� �� ������� �������
    // ������ ������ ��� ������ � ������� ������ �� �������� �� ������� �������
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;

    // FDQuery.DisableControls;
    // try
    // ���� ���� ������ ����������� �������
    while FDQuery.LocateEx(ADetailKeyFieldName, AIDMaster, []) do
    begin
      FDQuery.Delete;
    end;
    // finally
    // ��� cxGrid ������� �������������� � ����������� � ������������� �� ������ ������
    // FDQuery.EnableControls;
    // end;

  finally
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := E;
  end;

  // ��������� ������ � �������
  // DeleteByFilter(Format('%s = %d', [ADetailKeyFieldName, AIDMaster]));
end;

procedure TQueryBase.ClearUpdateRecCount;
begin
  FUpdateRecCount := 0;
end;

procedure TQueryBase.CreateDefaultFields(AUpdate: Boolean);
var
  i: Integer;
begin
  Assert(not FDQuery.Active);
  with FDQuery do
  begin
    if AUpdate then
      FieldDefs.Update;
    for i := 0 to FieldDefs.Count - 1 do
    begin
      FieldDefs[i].CreateField(FDQuery);
    end;
  end;
end;

function TQueryBase.Delete(APKValue: Variant): Boolean;
begin
  Result := LocateByPK(APKValue);
  if not Result then
    Exit;

  FDQuery.Delete; // ������� ������, ���� �����
end;

procedure TQueryBase.DeleteAll;
begin
  FDQuery.DisableControls;
  try
    while not FDQuery.Eof do
      FDQuery.Delete;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryBase.DeleteByFilter(const AFilterExpression: string);
Var
  AClone: TFDMemTable;
begin
  Assert(not AFilterExpression.IsEmpty);

  // ������ �����
  AClone := TFDMemTable.Create(Self);
  try
    // ��������� ������
    AClone.CloneCursor(FDQuery);
    // ����������� ������
    AClone.Filter := AFilterExpression;
    // �������� ������
    AClone.Filtered := True;

    if AClone.RecordCount > 0 then
    begin
      FDQuery.DisableControls;
      try

        // ������� ��� ��������������� ������
        while AClone.RecordCount > 0 do
        begin
          // ������� ������� ����������� ���� ������
          DeleteSelfDetail(AClone.FieldByName(FPKFieldName).Value);

          if LocateByPK(AClone.FieldByName(FPKFieldName).Value) then
          begin
            // ����� ���
            FDQuery.Delete;
          end;
        end;
      finally
        FDQuery.EnableControls;
      end;
    end;

  finally
    FreeAndNil(AClone);
  end;

end;

procedure TQueryBase.DeleteSelfDetail(AIDMaster: Variant);
begin
  // �� ��������� ��� ����������� �����-�� �������
end;

procedure TQueryBase.DoOnQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ARequest in [arDelete, arInsert, arUpdate] then
  begin
    // try
    AAction := eaApplied;
    // ���� ��������� ��������
    if ARequest = arDelete then
    begin
      ApplyDelete(ASender, ARequest, AAction, AOptions);
    end;

    // �������� ���������� ������ �� �������
    if ARequest = arInsert then
    begin
      ApplyInsert(ASender, ARequest, AAction, AOptions);
    end;

    // �������� ���������� ������ �� �������
    if ARequest = arUpdate then
    begin
      ApplyUpdate(ASender, ARequest, AAction, AOptions);
    end;
    {
      except
      on E: Exception do
      begin
      AAction := eaFail;
      DoOnUpdateRecordException(E);
      end;
      end;
    }
  end
  else
    AAction := eaSkip;
end;

procedure TQueryBase.DoOnUpdateRecordException(AException: Exception);
begin
  raise AException;
end;

procedure TQueryBase.FDQueryBeforeOpen(DataSet: TDataSet);
begin;
end;

procedure TQueryBase.FDQueryUpdateRecordOnClient(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

procedure TQueryBase.FetchFields(const AFieldNames: TArray<String>;
  const AValues: TArray<Variant>; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
var
  ASQL: string;
  i: Integer;
  S: string;
  V: Variant;
begin
  Assert(Low(AFieldNames) = Low(AValues));
  Assert(High(AFieldNames) = High(AValues));

  ASQL := 'SELECT ';
  for i := Low(AFieldNames) to High(AFieldNames) do
  begin
    V := AValues[i];
    Assert(not VarIsNull(V));
    if VarIsStr(V) then
      S := QuotedStr(V)
    else
    begin
      S := V;

      // ���� � ��� ������������ �����,
      // ���� � SQL ������� � �������� ����������� ������������ �����
      if VarIsType(V, [varDouble, varCurrency]) then
        S := S.Replace(',', '.');
    end;
    S := S + ' ' + AFieldNames[i];

    if i > Low(AFieldNames) then
      ASQL := ASQL + ', ';
    ASQL := ASQL + S;
  end;

  case ARequest of
    arInsert:
      FDUpdateSQL.InsertSQL.Text := ASQL;
    arUpdate:
      FDUpdateSQL.ModifySQL.Text := ASQL;
  end;

  FDUpdateSQL.Apply(ARequest, AAction, AOptions);
end;

procedure TQueryBase.FetchFields(ARecordHolder: TRecordHolder;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ASQL: string;
  i: Integer;
  S: string;
  V: Variant;
begin
  ASQL := 'SELECT ';
  for i := 0 to ARecordHolder.Count - 1 do
  begin
    V := ARecordHolder[i].Value;
    if VarIsNull(V) then
      Continue;

    if VarIsStr(V) then
      S := QuotedStr(V)
    else
    begin
      S := V;

      // ���� � ��� ������������ �����,
      // ���� � SQL ������� � �������� ����������� ������������ �����
      if VarIsType(V, [varDouble, varCurrency]) then
        S := S.Replace(',', '.');

    end;
    S := S + ' ' + ARecordHolder[i].FieldName;

    if i > 0 then
      ASQL := ASQL + ', ';
    ASQL := ASQL + S;
  end;

  case ARequest of
    arInsert:
      FDUpdateSQL.InsertSQL.Text := ASQL;
    arUpdate:
      FDUpdateSQL.ModifySQL.Text := ASQL;
  end;

  FDUpdateSQL.Apply(ARequest, AAction, AOptions);
end;

function TQueryBase.Field(const AFieldName: String): TField;
begin
  Result := FDQuery.FieldByName(AFieldName);
end;

function TQueryBase.GetCashedRecordBalance: Integer;
var
  AClone: TFDMemTable;
begin
  Result := 0;

  // Exit;

  if not FDQuery.Active then
    Exit;

  // ���� ��� ��������� ���������� �� ������� �������
  if FDQuery.CachedUpdates then
  begin
    // ������ �����
    AClone := TFDMemTable.Create(Self);
    try
      AClone.CloneCursor(FDQuery);

      // ��������� ���-�� �����������
      AClone.FilterChanges := [rtInserted];
      Result := AClone.RecordCount;

      // �������� ���-�� ��������
      AClone.FilterChanges := [rtDeleted];
      Result := Result - AClone.RecordCount;

    finally
      FreeAndNil(AClone);
    end;
    (*
      // ������ ������ ���� ����� ������ � ��������� ���������
      Assert(FDQuery.State = dsBrowse);
      FDQuery.DisableControls;
      try
      // ��������� ���-�� �����������
      FDQuery.FilterChanges := [rtInserted];
      Result := FDQuery.RecordCount;
      // �������� ���-�� ��������
      FDQuery.FilterChanges := [rtDeleted];
      Result := Result - FDQuery.RecordCount;

      FDQuery.FilterChanges := [rtUnmodified, rtModified, rtInserted];
      finally
      FDQuery.EnableControls;
      end;
    *)
  end
  else
    Result := IfThen(FDQuery.State in [dsInsert], 1, 0);

end;

function TQueryBase.GetFDUpdateSQL: TFDUpdateSQL;
begin
  if FFDUpdateSQL = nil then
  begin
    FFDUpdateSQL := TFDUpdateSQL.Create(Self);
    FFDUpdateSQL.DataSet := FDQuery;
  end;
  Result := FFDUpdateSQL;
end;

function TQueryBase.GetFieldValues(AFieldName: string;
  ADelimiter: String = ','): String;
var
  AClone: TFDMemTable;
  AValue: string;
begin
  Result := ADelimiter;

  // ������ �����
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;
    while not AClone.Eof do
    begin

      AValue := AClone.FieldByName(AFieldName).AsString;

      if (AValue <> '') then
      begin
        Result := Result + AValue + ADelimiter;
      end;

      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TQueryBase.GetFieldValuesAsIntArray(AFieldName: string)
  : TArray<Integer>;
var
  AClone: TFDMemTable;
  AValue: Integer;
  L: TList<Integer>;
begin
  // ������ ������
  L := TList<Integer>.Create;
  // ������ �����
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;
    while not AClone.Eof do
    begin

      AValue := AClone.FieldByName(AFieldName).AsInteger;
      L.Add(AValue);

      AClone.Next;
    end;
    Result := L.ToArray;
  finally
    FreeAndNil(AClone);
    FreeAndNil(L);
  end;
end;

function TQueryBase.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := True;
end;

function TQueryBase.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
end;

function TQueryBase.GetPK: TField;
begin
  Result := Field(FPKFieldName);
end;

procedure TQueryBase.IncUpdateRecCount;
begin
  Assert(FDQuery.Connection.InTransaction);
  Assert(FUpdateRecCount < FMaxUpdateRecCount);
  Inc(FUpdateRecCount);
  if FUpdateRecCount >= FMaxUpdateRecCount then
  begin
    // ������ ������������� ������
    FDQuery.Connection.Commit;
    FUpdateRecCount := 0;
  end;
end;

procedure TQueryBase.Load(AIDParent: Integer; AForcibly: Boolean = False);
begin
  Assert(DetailParameterName <> '');

  // ���� ���� ������������� � �������� ������
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) or AForcibly then
  begin
    FBeforeLoad.CallEventHandlers(FDQuery);

    FDQuery.Close;
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;
    FDQuery.Open();

    FAfterLoad.CallEventHandlers(FDQuery);
  end;
end;

procedure TQueryBase.Load(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
begin
  FDQuery.DisableControls;
  try
    FDQuery.Close;
    SetParameters(AParamNames, AParamValues);
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryBase.LocateByField(const AFieldName: string;
  const AValue: Variant;
  AOptions: TFDDataSetLocateOptions = [lxoCaseInsensitive, lxoPartialKey]
  ): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := FDQuery.LocateEx(AFieldName, AValue, AOptions);
end;

procedure TQueryBase.SetParameters(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  for i := Low(AParamNames) to High(AParamNames) do
  begin
    FDQuery.ParamByName(AParamNames[i]).Value := AParamValues[i];
  end;
end;

function TQueryBase.LocateByPK(APKValue: Variant;
  TestResult: Boolean = False): Boolean;
begin
  Assert(not VarIsNull(APKValue));
  Result := FDQuery.LocateEx(FPKFieldName, APKValue);
  if TestResult then
  begin
    Assert(Result);
  end;
end;

procedure TQueryBase.LocateByPKAndDelete(APKValue: Variant);
begin
  LocateByPK(APKValue, True);
  FDQuery.Delete;
end;

procedure TQueryBase.RefreshQuery;
begin
  FDQuery.DisableControls;
  try
    FDQuery.Close;
    FDQuery.Open();
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryBase.RestoreBookmark: Boolean;
begin
  Result := False;
  if VarIsNull(FBookmark) then
    Exit;
  Result := LocateByPK(FBookmark);
end;

procedure TQueryBase.SaveBookmark;
begin
  FBookmark := PK.Value;
end;

function TQueryBase.Search(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>; TestResult: Integer = -1): Integer;
begin
  Load(AParamNames, AParamValues);

  Result := FDQuery.RecordCount;
  if TestResult >= 0 then
    Assert(Result = TestResult);
end;

function TQueryBase.SearchEx(AParams: TArray<TParamRec>;
  TestResult: Integer = -1): Integer;
var
  AParamNames: TList<String>;
  AFormatStr: string;
  ANewValue: string;
  ANewSQL: string;
  AValues: TList<Variant>;
  i: Integer;
begin
  Assert(Length(AParams) > 0);

  ANewSQL := SQL; // ��������������� �������������� SQL

  for i := Low(AParams) to High(AParams) do
  begin
    // ���� ����� ���������������� � ��������
    if AParams[i].CaseInsensitive then
      AFormatStr := 'upper(%s) %s upper(:%s)'
    else
      AFormatStr := '%s %s :%s';

    ANewValue := Format(AFormatStr, [AParams[i].FullName, AParams[i].Operation,
      AParams[i].FieldName]);

    // ������ ������ � SQL �������
    ANewSQL := ReplaceInSQL(ANewSQL, ANewValue, i);
  end;

  // ������ SQL ������
  FDQuery.SQL.Text := ANewSQL;

  AParamNames := TList<String>.Create;
  AValues := TList<Variant>.Create;
  try
    // ������ ��������� SQL �������
    for i := Low(AParams) to High(AParams) do
    begin
      SetParamType(AParams[i].FieldName, ptInput, AParams[i].DataType);

      AParamNames.Add(AParams[i].FieldName);
      AValues.Add(AParams[i].Value);
    end;

    // ��������� �����
    Result := Search(AParamNames.ToArray, AValues.ToArray, TestResult);
  finally
    FreeAndNil(AParamNames);
    FreeAndNil(AValues);
  end;
end;

procedure TQueryBase.SetFieldsRequired(ARequired: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDQuery.Fields do
    AField.Required := ARequired;
end;

procedure TQueryBase.SetFieldsReadOnly(AReadOnly: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDQuery.Fields do
    AField.ReadOnly := AReadOnly;
end;

function TQueryBase.SetParamType(const AParamName: String; AParamType:
    TParamType = ptInput; ADataType: TFieldType = ftInteger): TFDParam;
begin
  Result := FDQuery.FindParam(AParamName);
  Assert(Result <> nil);
  Result.ParamType := AParamType;
  Result.DataType := ADataType;
end;

function TQueryBase.SetParamTypeEx(const AParamName: String; AValue: Variant;
    AParamType: TParamType = ptInput; ADataType: TFieldType = ftInteger):
    TFDParam;
begin
  Assert(not VarIsNull(AValue));
  Result := SetParamType(AParamName, AParamType, ADataType);
  Result.Value := AValue;
end;

// TODO: TryEdit
//function TQueryBase.TryEdit: Boolean;
//begin
//Assert(FDQuery.Active);
//
//Result := False;
//if FDQuery.State in [dsEdit, dsInsert] then
//  Exit;
//
//Assert(FDQuery.RecordCount > 0);
//FDQuery.Edit;
//Result := True;
//end;

procedure TQueryBase.TryPost;
begin
  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Post;
end;

procedure TQueryBase.TryCancel;
begin
  Assert(FDQuery.Active);

  if FDQuery.State in [dsEdit, dsInsert] then
    FDQuery.Cancel;
end;

procedure TQueryBase.TryOpen;
begin
  if not FDQuery.Active then
    FDQuery.Open;
end;

procedure TQueryBase.UpdateFields(AFields: TArray<TField>;
  AValues: TArray<Variant>; AUpdateNullFieldsOnly: Boolean);
var
  f: TField;
  i: Integer;
  V: Variant;
begin
  Assert(FDQuery.State in [dsInsert, dsEdit]);

  Assert(Length(AFields) > 0);
  Assert(Length(AFields) = Length(AValues));

  // ��������� ������ �������� ����� �� �������� �� ADataSet
  for i := Low(AFields) to High(AFields) do
  begin
    f := AFields[i];
    V := AValues[i];

    // ���� NULL ��� ������ ������
    if ((not AUpdateNullFieldsOnly) or (f.IsNull or f.AsString.Trim.IsEmpty))
      and (not VarIsNull(V) and (not VarToStr(V).Trim.IsEmpty)) then
      f.Value := V;
  end;
end;

constructor TParamRec.Create(const AFullName: String; const AValue: Variant;
  const ADataType: TFieldType = ftInteger;
  const ACaseInsensitive: Boolean = False; const AOperation: String = '=');
var
  p: Integer;
begin
  inherited;
  Assert(not AFullName.IsEmpty);
  Assert(not VarIsNull(AValue));

  FullName := AFullName;
  p := FullName.IndexOf('.');
  FieldName := IfThen(p > 0, AFullName.Substring(p + 1), AFullName);
  Value := AValue;
  DataType := ADataType;
  CaseInsensitive := ACaseInsensitive;
  Operation := AOperation;

  if ACaseInsensitive then
    Assert(ADataType = ftWideString);
end;

end.
