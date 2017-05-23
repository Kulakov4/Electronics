unit BaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, System.Contnrs, System.Generics.Collections, ProgressInfo;

// WM_NEED_POST = WM_USER + 558;

type
  TQueryBase = class(TFrame)
    FDQuery: TFDQuery;
    Label1: TLabel;
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
  private
    FAfterLoad: TNotifyEventsEx;
    FBeforeLoad: TNotifyEventsEx;
    FDetailParameterName: string;
    FMaxUpdateRecCount: Integer;
    FUpdateRecCount: Integer;
    function GetCashedRecordBalance: Integer;
    function GetParentValue: Integer;
    function GetPKValue: Integer;
    { Private declarations }
  protected
    FEventList: TObjectList;
    FPKFieldName: String;
    procedure ApplyDelete(ASender: TDataSet); virtual;
    procedure ApplyInsert(ASender: TDataSet); virtual;
    procedure ApplyUpdate(ASender: TDataSet); virtual;
    procedure DeleteSelfDetail(AIDMaster: Variant); virtual;
    // TODO: DoOnNeedPost
    // procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    function GetHaveAnyChanges: Boolean; virtual;
    function GetHaveAnyNotCommitedChanges: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>);
      overload; virtual;
    procedure AppendRows(AFieldNames: Array of String; AValues: TArray<String>);
      overload; virtual;
    procedure ApplyUpdates; virtual;
    procedure AssignFrom(AFDQuery: TFDQuery);
    procedure CancelUpdates; virtual;
    procedure CascadeDelete(const AIDMaster: Integer;
      const ADetailKeyFieldName: String); virtual;
    procedure ClearUpdateRecCount;
    procedure CreateDefaultFields(AUpdate: Boolean);
    procedure DeleteByFilter(const AFilterExpression: string);
    procedure DeleteList(var AList: TList<Variant>);
    function Field(const AFieldName: String): TField;
    function GetFieldValues(AFieldName: string;
      ADelimiter: String = ','): String;
    procedure IncUpdateRecCount;
    procedure Load(AIDParent: Integer); overload; virtual;
    procedure Load(const AParamNames: array of string;
      const AParamValues: array of Variant); overload;
    procedure SetParameters(const AParamNames: array of string;
      const AParamValues: array of Variant);
    function LocateByPK(APKValue: Variant): Boolean;
    procedure LocateByPKAndDelete(APKValue: Variant);
    procedure RefreshQuery; virtual;
    function Search(const AParamNames: array of string;
      const AParamValues: array of Variant): Integer; overload;
    procedure SetConditionSQL(const ABaseSQL, AConditionSQL, AMark: string;
        ANotifyEventRef: TNotifyEventRef = nil);
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsReadOnly(AReadOnly: Boolean);
    procedure TryEdit;
    procedure TryPost; virtual;
    procedure TryCancel;
    procedure TryAppend;
    procedure TryOpen;
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property BeforeLoad: TNotifyEventsEx read FBeforeLoad;
    property CashedRecordBalance: Integer read GetCashedRecordBalance;
    property DetailParameterName: string read FDetailParameterName
      write FDetailParameterName;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
    property ParentValue: Integer read GetParentValue;
    property PKFieldName: String read FPKFieldName;
    property PKValue: Integer read GetPKValue;
    { Public declarations }
  published
  end;

implementation

uses System.Math, RepositoryDataModule, StrHelper;

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
  inherited;
end;

procedure TQueryBase.AppendRows(AFieldName: string; AValues: TArray<String>);
var
  AValue: string;
begin
  Assert(not AFieldName.IsEmpty);

  // ��������� � ������ ������������ ����������
  for AValue in AValues do
  begin
    TryAppend;
    Field(AFieldName).AsString := AValue;
    TryPost;
  end;
end;

procedure TQueryBase.AppendRows(AFieldNames: Array of String;
  AValues: TArray<String>);
var
  AValue: string;
  i: Integer;
  m: TArray<String>;
begin
  Assert(Length(AFieldNames) > 0);

  // ��������� � ������ ������������ ����������
  for AValue in AValues do
  begin
    // ����� ������ �� ����� �� ���������
    m := AValue.Split([#9]);

    if Length(m) = Length(AFieldNames) then
    begin
      TryAppend;

      // ��������� ��� ����
      for i := Low(AFieldNames) to High(AFieldNames) do
      begin
        FDQuery.ParamByName(AFieldNames[i]).Value := m[i];
      end;

      TryPost;
    end
    else
      raise Exception.Create('�������������� ���������� �����');
  end;
end;

procedure TQueryBase.ApplyDelete(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyInsert(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyUpdate(ASender: TDataSet);
begin
end;

procedure TQueryBase.ApplyUpdates;
begin
  if not FDQuery.CachedUpdates then
    raise Exception.Create('�� ������� ����� ����������� ������� �� �������');

  TryPost;

  FDQuery.ApplyUpdates();
  FDQuery.CommitUpdates;
end;

procedure TQueryBase.AssignFrom(AFDQuery: TFDQuery);
begin
  Assert(AFDQuery <> nil);
  Assert(AFDQuery <> FDQuery);
  Assert(not AFDQuery.SQL.Text.IsEmpty);

  // �������� ������� ������
  FDQuery.SQL.Text := AFDQuery.SQL.Text;
  // �������� ���������
  FDQuery.Params.Assign(AFDQuery.Params);
end;

// ����-�� ��������� �� ���������� � ��
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

function TQueryBase.GetPKValue: Integer;
begin
  Result := FDQuery.FieldByName(FPKFieldName).AsInteger;
end;

procedure TQueryBase.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  FDQuery.CancelUpdates;
end;

procedure TQueryBase.CascadeDelete(const AIDMaster: Integer;
  const ADetailKeyFieldName: String);
begin
  Assert(AIDMaster > 0);

  FDQuery.DisableControls;
  try
    // ���� ���� ������ ���������� �������
    while FDQuery.LocateEx(ADetailKeyFieldName, AIDMaster, []) do
    begin
      FDQuery.Delete;
    end;
  finally
    FDQuery.EnableControls;
  end;

  // ��������� ������ � �������
  //DeleteByFilter(Format('%s = %d', [ADetailKeyFieldName, AIDMaster]));
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
          // ������� ������� ���������� ���� ������
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

procedure TQueryBase.DeleteList(var AList: TList<Variant>);
var
  V: Variant;
begin
  // ������� ������
  FDQuery.DisableControls;
  try
    for V in AList do
    begin
      // ������� ������� � ���� �� ���������� ������
      DeleteSelfDetail(V);

      // ������ ������� ���� ������
      if LocateByPK(V) then
      begin
        // ����� ������� ����
        FDQuery.Delete;
      end;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryBase.DeleteSelfDetail(AIDMaster: Variant);
begin
  // �� ��������� ��� ���������� �����-�� �������
end;

procedure TQueryBase.DoOnQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  try
    // ���� ��������� ��������
    if ARequest = arDelete then
    begin
      ApplyDelete(ASender);
    end;

    // �������� ���������� ������ �� �������
    if ARequest = arInsert then
    begin
      ApplyInsert(ASender);
    end;

    // �������� ���������� ������ �� �������
    if ARequest = arUpdate then
    begin
      ApplyUpdate(ASender);
    end;

    AAction := eaApplied;
  except
    AAction := eaFail;
    raise;
  end;
end;

procedure TQueryBase.FDQueryBeforeOpen(DataSet: TDataSet);
begin;
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

function TQueryBase.GetHaveAnyNotCommitedChanges: Boolean;
begin
  Result := True;
end;

function TQueryBase.GetParentValue: Integer;
begin
  Assert(DetailParameterName <> '');
  Result := FDQuery.Params.ParamByName(DetailParameterName).AsInteger;
end;

procedure TQueryBase.IncUpdateRecCount;
begin
  Assert(FDQuery.Connection.InTransaction);
  Assert(FUpdateRecCount < FMaxUpdateRecCount);
  Inc(FUpdateRecCount);
  if FUpdateRecCount >= FMaxUpdateRecCount  then
  begin
    // ������ ������������� ������
    FDQuery.Connection.Commit;
    FUpdateRecCount := 0;
  end;
end;

procedure TQueryBase.Load(AIDParent: Integer);
begin
  Assert(DetailParameterName <> '');

  // ���� ���� ������������� � �������� ������
  if (not FDQuery.Active) or (FDQuery.Params.ParamByName(DetailParameterName)
    .AsInteger <> AIDParent) then
  begin
    FBeforeLoad.CallEventHandlers(FDQuery);

    FDQuery.Close;
    FDQuery.Params.ParamByName(DetailParameterName).AsInteger := AIDParent;
    FDQuery.Open();

    FAfterLoad.CallEventHandlers(FDQuery);
  end;
end;

procedure TQueryBase.Load(const AParamNames: array of string;
  const AParamValues: array of Variant);
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

procedure TQueryBase.SetParameters(const AParamNames: array of string;
  const AParamValues: array of Variant);
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

function TQueryBase.LocateByPK(APKValue: Variant): Boolean;
begin
  Result := FDQuery.LocateEx(FPKFieldName, APKValue);
end;

procedure TQueryBase.LocateByPKAndDelete(APKValue: Variant);
var
  OK: Boolean;
begin
  OK := LocateByPK(APKValue);
  Assert(OK);
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

function TQueryBase.Search(const AParamNames: array of string;
  const AParamValues: array of Variant): Integer;
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  FDQuery.DisableControls;
  try
    FDQuery.Close;
    for i := Low(AParamNames) to High(AParamNames) do
    begin
      FDQuery.ParamByName(AParamNames[i]).Value := AParamValues[i];
    end;
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
  Result := FDQuery.RecordCount;
end;

procedure TQueryBase.SetConditionSQL(const ABaseSQL, AConditionSQL, AMark:
    string; ANotifyEventRef: TNotifyEventRef = nil);
begin
  Assert(not ABaseSQL.IsEmpty);
  Assert(not AConditionSQL.IsEmpty);
  Assert(not AMark.IsEmpty);

  FDQuery.DisableControls;
  try
    FDQuery.Close;
    FDQuery.SQL.Text := Replace(ABaseSQL, AConditionSQL, AMark);
    if Assigned(ANotifyEventRef) then
      ANotifyEventRef(Self);
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
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

procedure TQueryBase.TryEdit;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Edit;
end;

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

procedure TQueryBase.TryAppend;
begin
  Assert(FDQuery.Active);

  if not(FDQuery.State in [dsEdit, dsInsert]) then
    FDQuery.Append;
end;

procedure TQueryBase.TryOpen;
begin
  if not FDQuery.Active then
    FDQuery.Open;
end;

end.
