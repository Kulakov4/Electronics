unit DSWrap;

interface

uses
  System.Classes, Data.DB, System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, NotifyEvents, System.Contnrs,
  DBRecordHolder;

type
  TFieldWrap2 = class;

  TDSWrap2 = class(TComponent)
  private
    FAfterOpen: TNotifyEventsEx;
    FAfterClose: TNotifyEventsEx;
    FAfterInsert: TNotifyEventsEx;
    FBeforePost: TNotifyEventsEx;
    FAfterScroll: TNotifyEventsEx;
    FBeforeDelete: TNotifyEventsEx;
    FAfterPost: TNotifyEventsEx;
    FCloneEvents: TObjectList;
    FClones: TObjectList<TFDMemTable>;
    FDataSet: TDataSet;
    FEventList: TObjectList;
    FFieldsWrap: TObjectList<TFieldWrap>;
    FPKFieldName: string;
    FRecHolder: TRecordHolder;
    procedure AfterDataSetScroll(DataSet: TDataSet);
    procedure AfterDataSetClose(DataSet: TDataSet);
    procedure AfterDataSetOpen(DataSet: TDataSet);
    procedure AfterDataSetInsert(DataSet: TDataSet);
    procedure CloneAfterClose(Sender: TObject);
    procedure CloneAfterOpen(Sender: TObject);
    procedure CloneCursor(AClone: TFDMemTable);
    procedure DoAfterOpen___(Sender: TObject);
    function GetActive: Boolean;
    function GetAfterOpen: TNotifyEventsEx;
    function GetAfterClose: TNotifyEventsEx;
    function GetAfterInsert: TNotifyEventsEx;
    function GetBeforePost: TNotifyEventsEx;
    function GetAfterScroll: TNotifyEventsEx;
    function GetBeforeDelete: TNotifyEventsEx;
    function GetAfterPost: TNotifyEventsEx;
    function GetFDDataSet: TFDDataSet;
    function GetPK: TField;
    function GetRecordCount: Integer;
  protected
    procedure BeforeDataSetPost(DataSet: TDataSet);
    procedure BeforeDataSetDelete(DataSet: TDataSet);
    procedure AfterDataSetPost(DataSet: TDataSet);
    procedure UpdateFields; virtual;
    property FDDataSet: TFDDataSet read GetFDDataSet;
    property RecHolder: TRecordHolder read FRecHolder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddClone(const AFilter: String): TFDMemTable;
    procedure AfterConstruction; override;
    procedure ClearFilter;
    procedure DropClone(AClone: TFDMemTable);
    function Field(const AFieldName: string): TField;
    function HaveAnyChanges: Boolean;
    function Load(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>; ATestResult: Integer = -1)
      : Integer; overload;
    function LocateByPK(APKValue: Variant; TestResult: Boolean = False)
      : Boolean;
    procedure RefreshQuery; virtual;
    procedure RestoreBookmark; virtual;
    function SaveBookmark: Boolean;
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsVisible(AVisible: Boolean);
    procedure SetParameters(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>);
    procedure TryAppend;
    procedure TryCancel;
    function TryEdit: Boolean;
    function TryLocate(AFields: TArray<String>;
      AValues: TArray<Variant>): Integer;
    function Locate(AFields: TArray<String>; AValues: TArray<Variant>): Boolean;
    procedure TryOpen;
    procedure TryPost;
    property Active: Boolean read GetActive;
    property AfterOpen: TNotifyEventsEx read GetAfterOpen;
    property AfterClose: TNotifyEventsEx read GetAfterClose;
    property AfterInsert: TNotifyEventsEx read GetAfterInsert;
    property BeforePost: TNotifyEventsEx read GetBeforePost;
    property AfterScroll: TNotifyEventsEx read GetAfterScroll;
    property BeforeDelete: TNotifyEventsEx read GetBeforeDelete;
    property AfterPost: TNotifyEventsEx read GetAfterPost;
    property DataSet: TDataSet read FDataSet;
    property EventList: TObjectList read FEventList;
    property PK: TField read GetPK;
    property PKFieldName: string read FPKFieldName write FPKFieldName;
    property RecordCount: Integer read GetRecordCount;
  end;

  TFieldWrap2 = class(TObject)
  private
    FDataSetWrap: TDSWrap;
    FDefaultValue: Variant;
    FDisplayLabel: string;
    FFieldName: string;
    FVisible: Boolean;
    function GetF: TField;
  public
    constructor Create(ADataSetWrap: TDSWrap; const AFieldName: string;
      const ADisplayLabel: string = ''; APrimaryKey: Boolean = False);
    property DataSetWrap: TDSWrap read FDataSetWrap;
    property DefaultValue: Variant read FDefaultValue write FDefaultValue;
    property DisplayLabel: string read FDisplayLabel write FDisplayLabel;
    property F: TField read GetF;
    property FieldName: string read FFieldName;
    property Visible: Boolean read FVisible write FVisible;
  end;

implementation

uses
  FireDAC.Stan.Param, System.Variants, System.StrUtils;

constructor TDSWrap2.Create(AOwner: TComponent);
begin
  inherited;

  if not(AOwner is TDataSet) then
    raise Exception.Create
      ('������ ��� �������� TDSWrap. �������� ������ ���� TDataSet.');

  FDataSet := AOwner as TDataSet;
  FFieldsWrap := TObjectList<TFieldWrap>.Create;
  FEventList := TObjectList.Create;
end;

destructor TDSWrap2.Destroy;
begin
  FreeAndNil(FFieldsWrap);
  FreeAndNil(FEventList);
  if FAfterOpen <> nil then
    FreeAndNil(FAfterOpen);

  if FAfterScroll <> nil then
    FreeAndNil(FAfterScroll);
  inherited;
end;

function TDSWrap2.AddClone(const AFilter: String): TFDMemTable;
begin
  // ������ ������ ������
  if FClones = nil then
  begin
    FClones := TObjectList<TFDMemTable>.Create;

    // ������ �����������
    FCloneEvents := TObjectList.Create;

    // ����� ����������� �������
    TNotifyEventWrap.Create(AfterOpen, CloneAfterOpen, FCloneEvents);
    // ����� ��������� �������
    TNotifyEventWrap.Create(AfterClose, CloneAfterClose, FCloneEvents);
  end;

  Result := TFDMemTable.Create(nil); // ���������� ����� ������
  Result.Filter := AFilter;

  // ���������
  if FDataSet.Active then
    CloneCursor(Result);

  FClones.Add(Result); // ���������� ����� ������
end;

procedure TDSWrap2.AfterConstruction;
begin
  inherited;
  if FFieldsWrap.Count = 0 then
    Exit;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen___, EventList);
  if DataSet.Active then
    UpdateFields;
end;

procedure TDSWrap2.AfterDataSetOpen(DataSet: TDataSet);
begin
  FAfterOpen.CallEventHandlers(Self);
end;

procedure TDSWrap2.BeforeDataSetPost(DataSet: TDataSet);
begin
  FBeforePost.CallEventHandlers(Self);
end;

procedure TDSWrap2.AfterDataSetScroll(DataSet: TDataSet);
begin
  FAfterScroll.CallEventHandlers(Self);
end;

procedure TDSWrap2.AfterDataSetClose(DataSet: TDataSet);
begin
  FAfterClose.CallEventHandlers(Self);
end;

procedure TDSWrap2.AfterDataSetInsert(DataSet: TDataSet);
begin
  FAfterInsert.CallEventHandlers(Self);
end;

procedure TDSWrap2.BeforeDataSetDelete(DataSet: TDataSet);
begin
  FBeforeDelete.CallEventHandlers(Self);
end;

procedure TDSWrap2.AfterDataSetPost(DataSet: TDataSet);
begin
  FAfterPost.CallEventHandlers(Self);
end;

procedure TDSWrap2.ClearFilter;
begin
  FDataSet.Filtered := False;
end;

procedure TDSWrap2.CloneAfterClose(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �����
  for AClone in FClones do
    AClone.Close;
end;

procedure TDSWrap2.CloneAfterOpen(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �������
  for AClone in FClones do
  begin
    CloneCursor(AClone);
  end;
end;

procedure TDSWrap2.CloneCursor(AClone: TFDMemTable);
var
  AFilter: String;
begin
  // Assert(not AClone.Filter.IsEmpty);
  AFilter := AClone.Filter;
  AClone.CloneCursor(FDDataSet);

  // ���� ������ ����������� �� ����
  if (AFilter.IsEmpty) then
    Exit;

  AClone.Filter := AFilter;
  AClone.Filtered := True;
end;

procedure TDSWrap2.DoAfterOpen___(Sender: TObject);
begin
  UpdateFields;
end;

procedure TDSWrap2.DropClone(AClone: TFDMemTable);
begin
  Assert(AClone <> nil);
  Assert(FClones <> nil);

  FClones.Remove(AClone);

  if FClones.Count = 0 then
  begin
    // ������������
    FreeAndNil(FCloneEvents);
    // ��������� ������
    FreeAndNil(FClones);
  end;
end;

function TDSWrap2.Field(const AFieldName: string): TField;
begin
  Result := FDataSet.FieldByName(AFieldName);
end;

function TDSWrap2.GetActive: Boolean;
begin
  Result := FDataSet.Active;
end;

function TDSWrap2.GetAfterOpen: TNotifyEventsEx;
begin
  if FAfterOpen = nil then
  begin
    Assert(not Assigned(FDataSet.AfterOpen));
    FAfterOpen := TNotifyEventsEx.Create(Self);
    FDataSet.AfterOpen := AfterDataSetOpen;
  end;

  Result := FAfterOpen;
end;

function TDSWrap2.GetAfterClose: TNotifyEventsEx;
begin
  if FAfterClose = nil then
  begin
    Assert(not Assigned(FDataSet.AfterClose));
    FAfterClose := TNotifyEventsEx.Create(Self);
    FDataSet.AfterClose := AfterDataSetClose;
  end;

  Result := FAfterClose;
end;

function TDSWrap2.GetAfterInsert: TNotifyEventsEx;
begin
  if FAfterInsert = nil then
  begin
    Assert(not Assigned(FDataSet.AfterInsert));
    FAfterInsert := TNotifyEventsEx.Create(Self);
    FDataSet.AfterInsert := AfterDataSetInsert;
  end;

  Result := FAfterInsert;
end;

function TDSWrap2.GetBeforePost: TNotifyEventsEx;
begin
  if FBeforePost = nil then
  begin
    Assert(not Assigned(FDataSet.BeforePost));
    FBeforePost := TNotifyEventsEx.Create(Self);
    FDataSet.BeforePost := BeforeDataSetPost;
  end;

  Result := FBeforePost;
end;

function TDSWrap2.GetAfterScroll: TNotifyEventsEx;
begin
  if FAfterScroll = nil then
  begin
    Assert(not Assigned(FDataSet.AfterScroll));
    FAfterScroll := TNotifyEventsEx.Create(Self);
    FDataSet.AfterScroll := AfterDataSetScroll;
  end;
  Result := FAfterScroll;
end;

function TDSWrap2.GetBeforeDelete: TNotifyEventsEx;
begin
  if FBeforeDelete = nil then
  begin
    Assert(not Assigned(FDataSet.BeforeDelete));
    FBeforeDelete := TNotifyEventsEx.Create(Self);
    FDataSet.BeforeDelete := BeforeDataSetDelete;
  end;

  Result := FBeforeDelete;
end;

function TDSWrap2.GetAfterPost: TNotifyEventsEx;
begin
  if FAfterPost = nil then
  begin
    Assert(not Assigned(FDataSet.AfterPost));
    FAfterPost := TNotifyEventsEx.Create(Self);
    FDataSet.AfterPost := AfterDataSetPost;
  end;

  Result := FAfterPost;
end;

function TDSWrap2.GetFDDataSet: TFDDataSet;
begin
  Result := FDataSet as TFDDataSet;
end;

function TDSWrap2.GetPK: TField;
begin
  if FPKFieldName.IsEmpty then
    raise Exception.Create('��� ���������� ����� �� ������');

  Result := Field(FPKFieldName);
end;

function TDSWrap2.GetRecordCount: Integer;
begin
  Result := FDataSet.RecordCount;
end;

function TDSWrap2.HaveAnyChanges: Boolean;
begin
  Result := FDataSet.State in [dsEdit, dsinsert];
end;

function TDSWrap2.Load(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>; ATestResult: Integer = -1): Integer;
begin
  FDataSet.DisableControls;
  try
    FDataSet.Close;
    SetParameters(AParamNames, AParamValues);
    FDataSet.Open;
  finally
    FDataSet.EnableControls;
  end;
  Result := FDataSet.RecordCount;

  if ATestResult >= 0 then
    Assert(Result = ATestResult);
end;

function TDSWrap2.LocateByPK(APKValue: Variant;
  TestResult: Boolean = False): Boolean;
begin
  Assert(not FPKFieldName.IsEmpty);
  Result := FDDataSet.LocateEx(FPKFieldName, APKValue);
  if TestResult then
  begin
    Assert(Result);
  end;
end;

procedure TDSWrap2.RefreshQuery;
begin
  FDataSet.DisableControls;
  try
    FDataSet.Close;
    FDataSet.Open();
  finally
    FDataSet.EnableControls;
  end;
end;

procedure TDSWrap2.RestoreBookmark;
begin

end;

function TDSWrap2.SaveBookmark: Boolean;
begin
  Result := DataSet.Active and not DataSet.IsEmpty;
  if not Result then
    Exit;

  if FRecHolder = nil then
    FRecHolder := TRecordHolder.Create(DataSet)
  else
    FRecHolder.Attach(DataSet);
end;

procedure TDSWrap2.SetFieldsRequired(ARequired: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDataSet.Fields do
    AField.Required := ARequired;
end;

procedure TDSWrap2.SetFieldsVisible(AVisible: Boolean);
var
  F: TField;
begin
  for F in FDataSet.Fields do
    F.Visible := AVisible;
end;

procedure TDSWrap2.SetParameters(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  for i := Low(AParamNames) to High(AParamNames) do
  begin
    FDDataSet.ParamByName(AParamNames[i]).Value := AParamValues[i];
  end;
end;

procedure TDSWrap2.TryAppend;
begin
  Assert(FDataSet.Active);

  if not(FDataSet.State in [dsEdit, dsinsert]) then
    FDataSet.Append;
end;

procedure TDSWrap2.TryCancel;
begin
  Assert(FDataSet.Active);

  if FDataSet.State in [dsEdit, dsinsert] then
    FDataSet.Cancel;
end;

function TDSWrap2.TryEdit: Boolean;
begin
  Assert(FDataSet.Active);

  Result := False;
  if FDataSet.State in [dsEdit, dsinsert] then
    Exit;

  Assert(FDataSet.RecordCount > 0);
  FDataSet.Edit;
  Result := True;
end;

function TDSWrap2.TryLocate(AFields: TArray<String>;
  AValues: TArray<Variant>): Integer;
var
  AKeyFields: string;
  ALength: Integer;
  Arr: Variant;
  J: Integer;
  OK: Boolean;
begin
  Assert(Length(AFields) > 0);
  Assert(Length(AValues) > 0);
  Assert(Length(AFields) = Length(AValues));

  for ALength := Length(AValues) downto 1 do
  begin
    Result := ALength;
    AKeyFields := '';
    // ������ ���������� ������
    Arr := VarArrayCreate([0, ALength - 1], varVariant);

    for J := 0 to ALength - 1 do
    begin
      AKeyFields := AKeyFields + IfThen(AKeyFields.IsEmpty, '', ';') +
        AFields[J];
      Arr[J] := AValues[J];
    end;

    OK := FDDataSet.LocateEx(AKeyFields, Arr, []);

    VarClear(Arr);

    if OK then
      Exit;
  end;
  Result := 0;
end;

function TDSWrap2.Locate(AFields: TArray<String>;
  AValues: TArray<Variant>): Boolean;
var
  AKeyFields: string;
  ALength: Integer;
  Arr: Variant;
  J: Integer;
  OK: Boolean;
begin
  Assert(Length(AFields) > 0);
  Assert(Length(AValues) > 0);
  Assert(Length(AFields) = Length(AValues));
  ALength := Length(AValues);

  AKeyFields := '';
  // ������ ���������� ������
  Arr := VarArrayCreate([0, ALength - 1], varVariant);

  for J := 0 to ALength - 1 do
  begin
    AKeyFields := AKeyFields + IfThen(AKeyFields.IsEmpty, '', ';') + AFields[J];
    Arr[J] := AValues[J];
  end;

  Result := FDDataSet.LocateEx(AKeyFields, Arr, []);

  VarClear(Arr);
end;

procedure TDSWrap2.TryOpen;
begin
  if not FDataSet.Active then
    FDataSet.Open;
end;

procedure TDSWrap2.TryPost;
begin
  Assert(FDataSet.Active);

  if FDataSet.State in [dsEdit, dsinsert] then
    FDataSet.Post;
end;

procedure TDSWrap2.UpdateFields;
var
  F: TField;
  FW: TFieldWrap;
begin
  // ������ ��� ����
  SetFieldsVisible(False);

  // ���������� ������ ��, � ������� ���� DisplayLabel
  for FW in FFieldsWrap do
  begin
    F := FDataSet.FindField(FW.FieldName);
    if F = nil then
      Continue;

    F.Visible := FW.Visible;

    if not FW.DisplayLabel.IsEmpty then
      F.DisplayLabel := FW.DisplayLabel;
  end;
end;

constructor TFieldWrap2.Create(ADataSetWrap: TDSWrap; const AFieldName: string;
  const ADisplayLabel: string = ''; APrimaryKey: Boolean = False);
begin
  inherited Create;
  Assert(ADataSetWrap <> nil);
  Assert(not AFieldName.IsEmpty);

  FDataSetWrap := ADataSetWrap;
  FDataSetWrap.FFieldsWrap.Add(Self);

  FFieldName := AFieldName;

  FDisplayLabel := ADisplayLabel;
  FVisible := not FDisplayLabel.IsEmpty;
  // if FDisplayLabel.IsEmpty then
  // FDisplayLabel := FFieldName;

  if APrimaryKey then
    ADataSetWrap.PKFieldName := FFieldName;

  FDefaultValue := NULL;
end;

function TFieldWrap2.GetF: TField;
begin
  Result := FDataSetWrap.Field(FFieldName);
end;

end.
