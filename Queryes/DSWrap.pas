unit DSWrap;

interface

uses
  System.Classes, Data.DB, System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, NotifyEvents, System.Contnrs,
  DBRecordHolder, Winapi.Messages, Winapi.Windows;

const
  WM_DS_AFTER_SCROLL = WM_USER + 500;
  WM_DS_AFTER_POST = WM_USER + 501;

type
  TFieldWrap = class;
  TParamWrap = class;

  TDSWrap = class(TComponent)
  private
    FAfterOpen: TNotifyEventsEx;
    FAfterClose: TNotifyEventsEx;
    FAfterInsert: TNotifyEventsEx;
    FBeforePost: TNotifyEventsEx;
    FAfterScroll: TNotifyEventsEx;
    FBeforeDelete: TNotifyEventsEx;
    FAfterPost: TNotifyEventsEx;
    FAfterCancel: TNotifyEventsEx;
    FAfterDelete: TNotifyEventsEx;
    FAfterEdit: TNotifyEventsEx;
    FAfterScrollM: TNotifyEventsEx;
    FAfterPostM: TNotifyEventsEx;
    FBeforeOpen: TNotifyEventsEx;
    FBeforeClose: TNotifyEventsEx;
    FBeforeEdit: TNotifyEventsEx;
    FCloneEvents: TObjectList;
    FClones: TObjectList<TFDMemTable>;
    FDataSet: TDataSet;
    FEventList: TObjectList;
    FFieldsWrap: TObjectList<TParamWrap>;
    FHandle: HWND;
    FIsRecordModifedClone: TFDMemTable;
    FNEList: TList<TNotifyEventsEx>;
    FDeletedPKValue: Variant;
    FPKFieldName: string;
    FPostAPM: Boolean;
    FPostASM: Boolean;
    FRecHolder: TRecordHolder;
    procedure AfterDataSetScroll(DataSet: TDataSet);
    procedure AfterDataSetClose(DataSet: TDataSet);
    procedure AfterDataSetOpen(DataSet: TDataSet);
    procedure AfterDataSetInsert(DataSet: TDataSet);
    procedure AfterDataSetCancel(DataSet: TDataSet);
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
    function GetAfterCancel: TNotifyEventsEx;
    function GetAfterDelete: TNotifyEventsEx;
    function GetAfterScrollM: TNotifyEventsEx;
    function GetBeforeOpen: TNotifyEventsEx;
    function GetBeforeClose: TNotifyEventsEx;
    function GetFDDataSet: TFDDataSet;
    function GetHandle: HWND;
    function GetPK: TField;
    function GetRecordCount: Integer;
    procedure ProcessAfterScrollMessage;
    procedure BeforeDataSetPost(DataSet: TDataSet);
    procedure BeforeDataSetDelete(DataSet: TDataSet);
    procedure AfterDataSetPost(DataSet: TDataSet);
    procedure AfterDataSetDelete(DataSet: TDataSet);
    procedure AfterDataSetEdit(DataSet: TDataSet);
    procedure BeforeDataSetClose(DataSet: TDataSet);
    procedure BeforeDataSetOpen(DataSet: TDataSet);
    procedure BeforeDataSetEdit(DataSet: TDataSet);
    function GetAfterEdit: TNotifyEventsEx;
    function GetAfterPostM: TNotifyEventsEx;
    function GetBeforeEdit: TNotifyEventsEx;
    procedure ProcessAfterPostMessage;
    procedure WndProc(var Msg: TMessage);
  protected
    procedure UpdateFields;
    property FDDataSet: TFDDataSet read GetFDDataSet;
    property Handle: HWND read GetHandle;
    property RecHolder: TRecordHolder read FRecHolder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddClone(const AFilter: String): TFDMemTable;
    procedure AfterConstruction; override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>);
      overload; virtual;
    procedure CancelUpdates; virtual;
    procedure ClearFields(AFieldList: TArray<String>; AIDList: TArray<Integer>);
    procedure ClearFilter;
    procedure DeleteAll;
    procedure DropClone(AClone: TFDMemTable);
    function Field(const AFieldName: string): TField;
    function HaveAnyChanges: Boolean;
    function InsertRecord(ARecordHolder: TRecordHolder): Integer;
    function IsRecordModifed(APKValue: Variant): Boolean;
    function IsParamExist(const AParamName: String): Boolean;
    function Load(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>; ATestResult: Integer = -1)
      : Integer; overload;
    function LocateByPK(APKValue: Variant; TestResult: Boolean = False)
      : Boolean;
    procedure RefreshQuery; virtual;
    function RestoreBookmark: Boolean; virtual;
    function SaveBookmark: Boolean;
    procedure SetFieldsReadOnly(AReadOnly: Boolean);
    procedure SetFieldsRequired(ARequired: Boolean);
    procedure SetFieldsVisible(AVisible: Boolean);
    procedure SetParameters(const AParamNames: TArray<String>;
      const AParamValues: TArray<Variant>);
    // TODO: DropClone
    // procedure DropClone(AClone: TFDMemTable);
    procedure SmartRefresh; virtual;
    procedure TryAppend;
    procedure TryCancel;
    function TryEdit: Boolean;
    function TryLocate(AFields: TArray<String>;
      AValues: TArray<Variant>): Integer;
    procedure TryOpen;
    procedure TryPost;
    function UpdateRecord(ARecordHolder: TRecordHolder): Boolean;
    property Active: Boolean read GetActive;
    property AfterOpen: TNotifyEventsEx read GetAfterOpen;
    property AfterClose: TNotifyEventsEx read GetAfterClose;
    property AfterInsert: TNotifyEventsEx read GetAfterInsert;
    property BeforePost: TNotifyEventsEx read GetBeforePost;
    property AfterScroll: TNotifyEventsEx read GetAfterScroll;
    property BeforeDelete: TNotifyEventsEx read GetBeforeDelete;
    property AfterPost: TNotifyEventsEx read GetAfterPost;
    property AfterCancel: TNotifyEventsEx read GetAfterCancel;
    property AfterDelete: TNotifyEventsEx read GetAfterDelete;
    property AfterEdit: TNotifyEventsEx read GetAfterEdit;
    property AfterScrollM: TNotifyEventsEx read GetAfterScrollM;
    property AfterPostM: TNotifyEventsEx read GetAfterPostM;
    property BeforeOpen: TNotifyEventsEx read GetBeforeOpen;
    property BeforeClose: TNotifyEventsEx read GetBeforeClose;
    property BeforeEdit: TNotifyEventsEx read GetBeforeEdit;
    property DataSet: TDataSet read FDataSet;
    property EventList: TObjectList read FEventList;
    property DeletedPKValue: Variant read FDeletedPKValue;
    property PK: TField read GetPK;
    property PKFieldName: string read FPKFieldName write FPKFieldName;
    property RecordCount: Integer read GetRecordCount;
  end;

  TParamWrap = class(TObject)
  private
    FDataSetWrap: TDSWrap;
    FDefaultValue: Variant;
    FFieldName: string;
    FFullName: string;
    FTableName: string;
  public
    constructor Create(ADataSetWrap: TDSWrap; const AFullName: String);
    property DataSetWrap: TDSWrap read FDataSetWrap;
    property DefaultValue: Variant read FDefaultValue write FDefaultValue;
    property FullName: string read FFullName;
    property FieldName: string read FFieldName;
    property TableName: string read FTableName;
  end;

  TFieldWrap = class(TParamWrap)
  private
    FDisplayLabel: string;
    function GetF: TField;
  public
    constructor Create(ADataSetWrap: TDSWrap; const AFullName: String;
      const ADisplayLabel: string = ''; APrimaryKey: Boolean = False);
    property DisplayLabel: string read FDisplayLabel;
    property F: TField read GetF;
  end;

implementation

uses
  FireDAC.Stan.Param, System.Variants, System.StrUtils;

constructor TDSWrap.Create(AOwner: TComponent);
begin
  inherited;

  if not(AOwner is TDataSet) then
    raise Exception.Create
      ('������ ��� �������� TDSWrap. �������� ������ ���� TDataSet.');

  FDataSet := AOwner as TDataSet;
  FFieldsWrap := TObjectList<TParamWrap>.Create;
  FEventList := TObjectList.Create;
  FNEList := TList<TNotifyEventsEx>.Create;
end;

destructor TDSWrap.Destroy;
var
  I: Integer;
begin
  // ������ ��� �����
  if FClones <> nil then
  begin
    for I := FClones.Count - 1 downto 0 do
      DropClone(FClones[I]);
  end;
  Assert(FClones = nil);

  for i := FNEList.Count - 1 downto 0 do
  begin
    FNEList[i].Destroy;
    FNEList.Delete(i);
  end;
  Assert(FNEList.Count = 0);
  FreeAndNil(FNEList);

  FreeAndNil(FFieldsWrap);
  FreeAndNil(FEventList);

  if FHandle <> 0 then
    DeallocateHWnd(FHandle);

  inherited;
end;

function TDSWrap.AddClone(const AFilter: String): TFDMemTable;
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

procedure TDSWrap.AfterConstruction;
begin
  inherited;
  if FFieldsWrap.Count = 0 then
    Exit;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen___, EventList);
  if DataSet.Active then
    UpdateFields;
end;

procedure TDSWrap.AfterDataSetOpen(DataSet: TDataSet);
begin
  FAfterOpen.CallEventHandlers(Self);
end;

procedure TDSWrap.BeforeDataSetPost(DataSet: TDataSet);
begin
  FBeforePost.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetScroll(DataSet: TDataSet);
begin
  // ���� ��������� AfterScroll ��� �� �������� � ���� ����������
  if (FAfterScrollM <> nil) and (FAfterScrollM.Count > 0) and (not FPostASM)
  then
  begin
    FPostASM := True;
    // ���������� ����� ���������
    PostMessage(Handle, WM_DS_AFTER_SCROLL, 0, 0);
  end;

  // �������� ���, ��� ����� �������� ��������� ����������
  if FAfterScroll <> nil then
    FAfterScroll.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetClose(DataSet: TDataSet);
begin
  FAfterClose.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetInsert(DataSet: TDataSet);
begin
  FAfterInsert.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetCancel(DataSet: TDataSet);
begin
  FAfterCancel.CallEventHandlers(Self);
end;

procedure TDSWrap.BeforeDataSetDelete(DataSet: TDataSet);
begin
  if not PKFieldName.IsEmpty then
    FDeletedPKValue := Field(FPKFieldName).Value;

  FBeforeDelete.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetPost(DataSet: TDataSet);
begin
  // ���� ��������� AfterScroll ��� �� �������� � ���� ����������
  if (FAfterPostM <> nil) and (FAfterPostM.Count > 0) and (not FPostAPM)
  then
  begin
    FPostAPM := True;
    // ���������� ����� ���������
    PostMessage(Handle, WM_DS_AFTER_POST, 0, 0);
  end;

  FAfterPost.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetDelete(DataSet: TDataSet);
begin
  FAfterDelete.CallEventHandlers(Self);
end;

procedure TDSWrap.AfterDataSetEdit(DataSet: TDataSet);
begin
  FAfterEdit.CallEventHandlers(Self);
end;

procedure TDSWrap.AppendRows(AFieldName: string; AValues: TArray<String>);
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

procedure TDSWrap.BeforeDataSetOpen(DataSet: TDataSet);
begin
  FBeforeOpen.CallEventHandlers(Self);
end;

procedure TDSWrap.BeforeDataSetClose(DataSet: TDataSet);
begin
  FBeforeClose.CallEventHandlers(Self);
end;

procedure TDSWrap.BeforeDataSetEdit(DataSet: TDataSet);
begin
  FBeforeEdit.CallEventHandlers(Self);
end;

procedure TDSWrap.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  if FDDataSet.CachedUpdates then
  begin
    FDDataSet.CancelUpdates;
  end
end;

procedure TDSWrap.ClearFields(AFieldList: TArray<String>;
  AIDList: TArray<Integer>);
var
  AFieldName: String;
  AID: Integer;
begin
  Assert(Length(AFieldList) > 0);
  Assert(Length(AIDList) > 0);

  DataSet.DisableControls;
  try
    SaveBookmark;
    for AID in AIDList do
    begin
      if not LocateByPK(AID) then
        Continue;
      TryEdit;
      for AFieldName in AFieldList do
        Field(AFieldName).Value := NULL;
      TryPost;
    end;
    RestoreBookmark;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TDSWrap.ClearFilter;
begin
  FDataSet.Filtered := False;
end;

procedure TDSWrap.CloneAfterClose(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �����
  for AClone in FClones do
    AClone.Close;
end;

procedure TDSWrap.CloneAfterOpen(Sender: TObject);
var
  AClone: TFDMemTable;
begin
  // ��������� �������
  for AClone in FClones do
  begin
    CloneCursor(AClone);
  end;
end;

procedure TDSWrap.CloneCursor(AClone: TFDMemTable);
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

procedure TDSWrap.DeleteAll;
begin
  FDDataSet.DisableControls;
  try
    while not FDDataSet.Eof do
      FDDataSet.Delete;
  finally
    FDDataSet.EnableControls;
  end;
end;

procedure TDSWrap.DoAfterOpen___(Sender: TObject);
begin
  UpdateFields;
end;

procedure TDSWrap.DropClone(AClone: TFDMemTable);
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

function TDSWrap.Field(const AFieldName: string): TField;
begin
  Result := FDataSet.FieldByName(AFieldName);
end;

function TDSWrap.GetActive: Boolean;
begin
  Result := FDataSet.Active;
end;

function TDSWrap.GetAfterOpen: TNotifyEventsEx;
begin
  if FAfterOpen = nil then
  begin
    Assert(not Assigned(FDataSet.AfterOpen));
    FAfterOpen := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterOpen);
    FDataSet.AfterOpen := AfterDataSetOpen;
  end;

  Result := FAfterOpen;
end;

function TDSWrap.GetAfterClose: TNotifyEventsEx;
begin
  if FAfterClose = nil then
  begin
    Assert(not Assigned(FDataSet.AfterClose));
    FAfterClose := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterClose);
    FDataSet.AfterClose := AfterDataSetClose;
  end;

  Result := FAfterClose;
end;

function TDSWrap.GetAfterInsert: TNotifyEventsEx;
begin
  if FAfterInsert = nil then
  begin
    Assert(not Assigned(FDataSet.AfterInsert));
    FAfterInsert := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterInsert);
    FDataSet.AfterInsert := AfterDataSetInsert;
  end;

  Result := FAfterInsert;
end;

function TDSWrap.GetBeforePost: TNotifyEventsEx;
begin
  if FBeforePost = nil then
  begin
    Assert(not Assigned(FDataSet.BeforePost));
    FBeforePost := TNotifyEventsEx.Create(Self);
    FNEList.Add(FBeforePost);
    FDataSet.BeforePost := BeforeDataSetPost;
  end;

  Result := FBeforePost;
end;

function TDSWrap.GetAfterScroll: TNotifyEventsEx;
begin
  if FAfterScroll = nil then
  begin
    Assert(not Assigned(FDataSet.AfterScroll));
    FAfterScroll := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterScroll);
    FDataSet.AfterScroll := AfterDataSetScroll;
  end;
  Result := FAfterScroll;
end;

function TDSWrap.GetBeforeDelete: TNotifyEventsEx;
begin
  if FBeforeDelete = nil then
  begin
    Assert(not Assigned(FDataSet.BeforeDelete));
    FBeforeDelete := TNotifyEventsEx.Create(Self);
    FNEList.Add(FBeforeDelete);
    FDataSet.BeforeDelete := BeforeDataSetDelete;
  end;

  Result := FBeforeDelete;
end;

function TDSWrap.GetAfterPost: TNotifyEventsEx;
begin
  if FAfterPost = nil then
  begin
    Assert(not Assigned(FDataSet.AfterPost));
    FAfterPost := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterPost);
    FDataSet.AfterPost := AfterDataSetPost;
  end;

  Result := FAfterPost;
end;

function TDSWrap.GetAfterCancel: TNotifyEventsEx;
begin
  if FAfterCancel = nil then
  begin
    Assert(not Assigned(FDataSet.AfterCancel));
    FAfterCancel := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterCancel);
    FDataSet.AfterCancel := AfterDataSetCancel;
  end;

  Result := FAfterCancel;
end;

function TDSWrap.GetAfterDelete: TNotifyEventsEx;
begin
  if FAfterDelete = nil then
  begin
    Assert(not Assigned(FDataSet.AfterDelete));
    FAfterDelete := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterDelete);
    FDataSet.AfterDelete := AfterDataSetDelete;
  end;

  Result := FAfterDelete;
end;

function TDSWrap.GetAfterEdit: TNotifyEventsEx;
begin
  if FAfterEdit = nil then
  begin
    Assert(not Assigned(FDataSet.AfterEdit));
    FAfterEdit := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterEdit);
    FDataSet.AfterEdit := AfterDataSetEdit;
  end;

  Result := FAfterEdit;
end;

function TDSWrap.GetAfterScrollM: TNotifyEventsEx;
begin
  if FAfterScrollM = nil then
  begin
    if FAfterScroll = nil then
      Assert(not Assigned(FDataSet.AfterScroll));
    // else
    // Assert(FDataSet.AfterScroll = AfterDataSetScroll);

    FAfterScrollM := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterScrollM);
    FDataSet.AfterScroll := AfterDataSetScroll;
  end;
  Result := FAfterScrollM;
end;

function TDSWrap.GetAfterPostM: TNotifyEventsEx;
begin
  if FAfterPostM = nil then
  begin
    if FAfterPost = nil then
      Assert(not Assigned(FDataSet.AfterPost));

    FAfterPostM := TNotifyEventsEx.Create(Self);
    FNEList.Add(FAfterPostM);
    FDataSet.AfterPost := AfterDataSetPost;
  end;
  Result := FAfterPostM;
end;

function TDSWrap.GetBeforeOpen: TNotifyEventsEx;
begin
  if FBeforeOpen = nil then
  begin
    Assert(not Assigned(FDataSet.BeforeOpen));
    FBeforeOpen := TNotifyEventsEx.Create(Self);
    FNEList.Add(FBeforeOpen);
    FDataSet.BeforeOpen := BeforeDataSetOpen;
  end;

  Result := FBeforeOpen;
end;

function TDSWrap.GetBeforeClose: TNotifyEventsEx;
begin
  if FBeforeClose = nil then
  begin
    Assert(not Assigned(FDataSet.BeforeClose));
    FBeforeClose := TNotifyEventsEx.Create(Self);
    FNEList.Add(FBeforeClose);
    FDataSet.BeforeClose := BeforeDataSetClose;
  end;

  Result := FBeforeClose;
end;

function TDSWrap.GetBeforeEdit: TNotifyEventsEx;
begin
  if FBeforeEdit = nil then
  begin
    Assert(not Assigned(FDataSet.BeforeEdit));
    FBeforeEdit := TNotifyEventsEx.Create(Self);
    FNEList.Add(FBeforeEdit);
    FDataSet.BeforeEdit := BeforeDataSetEdit;
  end;

  Result := FBeforeEdit;
end;

function TDSWrap.GetFDDataSet: TFDDataSet;
begin
  Result := FDataSet as TFDDataSet;
end;

function TDSWrap.GetHandle: HWND;
begin
  if FHandle = 0 then
    FHandle := System.Classes.AllocateHWnd(WndProc);

  Result := FHandle;
end;

function TDSWrap.GetPK: TField;
begin
  if FPKFieldName.IsEmpty then
    raise Exception.Create('��� ���������� ����� �� ������');

  Result := Field(FPKFieldName);
end;

procedure TDSWrap.WndProc(var Msg: TMessage);
begin
  with Msg do
    case Msg of
      WM_DS_AFTER_SCROLL:
        ProcessAfterScrollMessage;
      WM_DS_AFTER_POST:
        ProcessAfterPostMessage;
    else
      DefWindowProc(FHandle, Msg, wParam, lParam);
    end;
end;

function TDSWrap.GetRecordCount: Integer;
begin
  Result := FDataSet.RecordCount;
end;

function TDSWrap.HaveAnyChanges: Boolean;
begin
  Result := FDataSet.State in [dsEdit, dsinsert];
end;

function TDSWrap.InsertRecord(ARecordHolder: TRecordHolder): Integer;
var
  AFieldHolder: TFieldHolder;
  F: TField;
begin
  Assert(ARecordHolder <> nil);

  TryAppend;
  try
    for F in DataSet.Fields do
    begin
      // ��������� ���� ��������� �� �����
      if F.FieldName.ToUpper = PKFieldName.ToUpper then
        Continue;

      // ���� ����� ���� � ��������� ����������� ��������
      AFieldHolder := ARecordHolder.Find(F.FieldName);

      // ���� �����
      if (AFieldHolder <> nil) and not VarIsNull(AFieldHolder.Value) then
      begin
        F.Value := AFieldHolder.Value;
      end;

    end;

    TryPost;
    // ��������� ���� ������ �������� ��������
    Assert(not PK.IsNull);

    Result := PK.AsInteger;
  except
    TryCancel;
    raise;
  end;

end;

function TDSWrap.IsRecordModifed(APKValue: Variant): Boolean;
var
  AFDDataSet: TFDDataSet;
  OK: Boolean;
begin
  // ���� ��������� ������� ������
  if PK.Value = APKValue then
    AFDDataSet := FDDataSet
  else
  begin
    // ��� �������� ������ ������ ���� ������� ����
    if FIsRecordModifedClone = nil then
    begin
      // ������ ����
      FIsRecordModifedClone := AddClone('');
    end;
    OK := FIsRecordModifedClone.LocateEx(PKFieldName, APKValue);
    Assert(OK);
    AFDDataSet := FIsRecordModifedClone;
  end;

  Result := AFDDataSet.UpdateStatus in [usModified, usInserted]
end;

function TDSWrap.IsParamExist(const AParamName: String): Boolean;
var
  AFDParam: TFDParam;
begin
  Assert(not AParamName.IsEmpty);
  AFDParam := FDDataSet.FindParam(AParamName);
  Result := AFDParam <> nil;
end;

function TDSWrap.Load(const AParamNames: TArray<String>;
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

function TDSWrap.LocateByPK(APKValue: Variant;
  TestResult: Boolean = False): Boolean;
begin
  Assert(not FPKFieldName.IsEmpty);
  Result := FDDataSet.LocateEx(FPKFieldName, APKValue);
  if TestResult then
  begin
    Assert(Result);
  end;
end;

procedure TDSWrap.ProcessAfterScrollMessage;
begin
  Assert(FAfterScrollM <> nil);
  FAfterScrollM.CallEventHandlers(Self);
  FPostASM := False;
end;

procedure TDSWrap.ProcessAfterPostMessage;
begin
  Assert(FAfterPostM <> nil);
  FAfterPostM.CallEventHandlers(Self);
  FPostAPM := False;
end;

procedure TDSWrap.RefreshQuery;
begin
  FDataSet.DisableControls;
  try
    FDataSet.Close;
    FDataSet.Open();
  finally
    FDataSet.EnableControls;
  end;
end;

function TDSWrap.RestoreBookmark: Boolean;
begin
  Result := False;

  // ���� ���� ���������� ������, � ������� ���� ���������
  // � �������� ��������� ����
  if (FRecHolder <> nil) and (not PKFieldName.IsEmpty) and
    (not VarIsNull(FRecHolder.Field[PKFieldName])) then
    Result := LocateByPK(FRecHolder.Field[PKFieldName]);
end;

function TDSWrap.SaveBookmark: Boolean;
begin
  Result := DataSet.Active and not DataSet.IsEmpty;
  if not Result then
    Exit;

  if FRecHolder = nil then
    FRecHolder := TRecordHolder.Create(DataSet)
  else
    FRecHolder.Attach(DataSet);
end;

procedure TDSWrap.SetFieldsReadOnly(AReadOnly: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDataSet.Fields do
    AField.ReadOnly := AReadOnly;
end;

procedure TDSWrap.SetFieldsRequired(ARequired: Boolean);
var
  AField: TField;
begin
  inherited;
  for AField in FDataSet.Fields do
    AField.Required := ARequired;
end;

procedure TDSWrap.SetFieldsVisible(AVisible: Boolean);
var
  F: TField;
begin
  for F in FDataSet.Fields do
    F.Visible := AVisible;
end;

procedure TDSWrap.SetParameters(const AParamNames: TArray<String>;
  const AParamValues: TArray<Variant>);
var
  I: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  for I := Low(AParamNames) to High(AParamNames) do
  begin
    FDDataSet.ParamByName(AParamNames[I]).Value := AParamValues[I];
  end;
end;

procedure TDSWrap.SmartRefresh;
var
  OK: Boolean;
begin
  // ���������� ������, ��� ������� �� ��������� ������� AfterScroll
  FDDataSet.DisableControls;
  try
    SaveBookmark;

    // ��� ����� ���������� ��������� AfterScroll ��� �������
    FPostASM := True;

    // ������ ��������� ������
    RefreshQuery;

    OK := RestoreBookmark;

    // ���� ������ ������ �� ����������
    if not OK then
    begin
      // ��� ����� ���������� ��������� AfterScroll ��� �� ��������
      FPostASM := False;

      // ������������ �������� ������� AfterScroll
      AfterDataSetScroll(DataSet);
    end;

  finally
    // ��� ���������� ���������� DevExpress ������ �������� ������ � ����� ������ Scroll
    FDDataSet.EnableControls;
  end;

  if OK then
    // ��� ����� ���������� ��������� AfterScroll ��� �������
    FPostASM := False;
end;

procedure TDSWrap.TryAppend;
begin
  Assert(FDataSet.Active);

  if not(FDataSet.State in [dsEdit, dsinsert]) then
    FDataSet.Append;
end;

procedure TDSWrap.TryCancel;
begin
  Assert(FDataSet.Active);

  if FDataSet.State in [dsEdit, dsinsert] then
    FDataSet.Cancel;
end;

function TDSWrap.TryEdit: Boolean;
begin
  Assert(FDataSet.Active);

  Result := False;
  if FDataSet.State in [dsEdit, dsinsert] then
    Exit;

  Assert(FDataSet.RecordCount > 0);
  FDataSet.Edit;
  Result := True;
end;

function TDSWrap.TryLocate(AFields: TArray<String>;
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

procedure TDSWrap.TryOpen;
begin
  if not FDataSet.Active then
    FDataSet.Open;
end;

procedure TDSWrap.TryPost;
begin
  Assert(FDataSet.Active);

  if FDataSet.State in [dsEdit, dsinsert] then
    FDataSet.Post;
end;

procedure TDSWrap.UpdateFields;
var
  F: TField;
  PW: TParamWrap;
  FW: TFieldWrap;
begin
  // ������ ��� ����
  SetFieldsVisible(False);

  // ���������� ������ ��, � ������� ���� DisplayLabel
  for PW in FFieldsWrap do
  begin
    if not(PW is TFieldWrap) then
      Continue;

    FW := PW as TFieldWrap;

    F := FDataSet.FindField(FW.FieldName);
    if F = nil then
      Continue;

    if not FW.DisplayLabel.IsEmpty then
    begin
      F.DisplayLabel := FW.DisplayLabel;
      F.Visible := True;
    end;
  end;
end;

function TDSWrap.UpdateRecord(ARecordHolder: TRecordHolder): Boolean;
var
  AChangedFields: TDictionary<String, Variant>;
  AFieldHolder: TFieldHolder;
  AFieldName: string;
  F: TField;
begin
  Assert(ARecordHolder <> nil);

  // ������ ������� ��� ����� ��� ����� ����� ��������
  AChangedFields := TDictionary<String, Variant>.Create;
  try

    for F in DataSet.Fields do
    begin
      // ��������� ���� ��������� �� �����
      if F.FieldName.ToUpper = PKFieldName.ToUpper then
        Continue;

      // ���� ����� ���� � ��������� ����������� ��������
      AFieldHolder := ARecordHolder.Find(F.FieldName);

      // ���������� � ������� ����� ���� ����� ����� ��������
      if (AFieldHolder <> nil) and (F.Value <> AFieldHolder.Value) then
        AChangedFields.Add(F.FieldName, AFieldHolder.Value);
    end;

    Result := AChangedFields.Count > 0;

    // ���� ���� �� ����, ������� ����� ���������
    if Result then
    begin
      TryEdit;
      try
        // ���� �� ���� ������������ �����
        for AFieldName in AChangedFields.Keys do
        begin
          Field(AFieldName).Value := AChangedFields[AFieldName];
        end;
        TryPost;
      except
        TryCancel;
        raise;
      end;
    end;

  finally
    FreeAndNil(AChangedFields);
  end;
end;

constructor TFieldWrap.Create(ADataSetWrap: TDSWrap; const AFullName: String;
  const ADisplayLabel: string = ''; APrimaryKey: Boolean = False);
begin
  inherited Create(ADataSetWrap, AFullName);

  FDisplayLabel := ADisplayLabel;

  if APrimaryKey then
  begin
    Assert(ADataSetWrap.PKFieldName = '');
    ADataSetWrap.PKFieldName := FFieldName;
  end;
end;

function TFieldWrap.GetF: TField;
begin
  Result := FDataSetWrap.Field(FFieldName);
end;

constructor TParamWrap.Create(ADataSetWrap: TDSWrap; const AFullName: String);
var
  p: Integer;
begin
  inherited Create;

  Assert(ADataSetWrap <> nil);
  Assert(not AFullName.IsEmpty);

  FDataSetWrap := ADataSetWrap;
  FDataSetWrap.FFieldsWrap.Add(Self);

  FTableName := '';

  p := AFullName.IndexOf('.');

  // ���� ��� ���� �������� ����� - �� ��� �� ����� - ��� �������
  if p > 0 then
  begin
    FTableName := AFullName.Substring(0, p);
    FFieldName := AFullName.Substring(p + 1);
  end
  else
    FFieldName := AFullName;

  // �������� ��� ���� "�� ���������"
  FDefaultValue := NULL;
end;

end.
