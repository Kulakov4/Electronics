unit MainParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  NotifyEvents, QueryWithDataSourceUnit, SearchMainParameterQuery,
  ApplyQueryFrame;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryMainParameters = class(TQueryWithDataSource)
    fdqBase: TFDQuery;
    ParametersApplyQuery: TfrmApplyQuery;
  private
    FHaveAnyChanges: Boolean;
    FProductCategoryIDValue: Integer;
    FQuerySearchMainParameter: TQuerySearchMainParameter;
    FRecOrderList: TList<TRecOrder>;
    FShowDublicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterCommitOrRollback(Sender: TObject);
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    procedure DoOnDataChange(Sender: TObject);
    function GetChecked: TField;
    function GetIDParameterType: TField;
    function GetIsCustomParameter: TField;
    function GetOrder: TField;
    function GetQuerySearchMainParameter: TQuerySearchMainParameter;
    function GetTableName: TField;
    function GetValue: TField;
    procedure SetShowDublicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    procedure TryCommit;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    procedure DoOnUpdateOrder(ARecOrder: TRecOrder);
    procedure UpdateOrder;
    property QuerySearchMainParameter: TQuerySearchMainParameter
      read GetQuerySearchMainParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedPKValues: string;
    function Locate(const AFieldName, AValue: string): Boolean;
    function Lookup(AValue: string): Integer;
    procedure MoveDSRecord(AStartDrag: TStartDrag; ADropDrag: TDropDrag);
    property Checked: TField read GetChecked;
    property IDParameterType: TField read GetIDParameterType;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property Order: TField read GetOrder;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    property TableName: TField read GetTableName;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DBRecordHolder, System.StrUtils, StrHelper;

constructor TQueryMainParameters.Create(AOwner: TComponent);
begin
  inherited;
  FRecOrderList := TList<TRecOrder>.Create;

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������������� �� �������
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  TNotifyEventWrap.Create(AfterPost, DoAfterPost, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  TNotifyEventWrap.Create(DMRepository.AfterCommit, DoAfterCommitOrRollback,
    FEventList);
  TNotifyEventWrap.Create(DMRepository.AfterRollback, DoAfterCommitOrRollback,
    FEventList);

  TNotifyEventWrap.Create(OnDataChange, DoOnDataChange, FEventList);

  AutoTransaction := False;
end;

procedure TQueryMainParameters.ApplyDelete(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  RH: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  if AID.AsInteger <= 0 then
    Exit;

  // ���� �������� ������� �������� "�� ���������"
  if AIsCustomParameter.AsBoolean then
  begin
    RH := TRecordHolder.Create(ASender);
    try
      RH.Find(IDParameterType.FieldName).Value := NULL;
      ParametersApplyQuery.UpdateRecord(RH);
    finally
      FreeAndNil(RH);
    end;
  end
  else
  begin
    ParametersApplyQuery.DeleteRecord(AID.AsInteger);
  end;
end;

procedure TQueryMainParameters.ApplyInsert(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  ATableName: TField;
  i: Integer;
  RH: TRecordHolder;
  RH2: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  ATableName := ASender.FieldByName(TableName.FieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  // ���� �� ��������� ��������� ���, �� ��������� ��� = ������������
  if ATableName.AsString.IsEmpty then
    ATableName.AsString := Value.AsString;

  RH := TRecordHolder.Create(ASender);
  try
    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := QuerySearchMainParameter.Search(ATableName.AsString, True);
    // ���� ����� � � ������ �����
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PKValue) then
    begin
      // �������� ���� � ����� ����� IsCustomParameter
      RH.Attach(ASender, IsCustomParameter.FieldName);

      RH2 := TRecordHolder.Create(QuerySearchMainParameter.FDQuery);
      try
        // ��������� ������ ����
        RH.UpdateNullValues(RH2);
      finally
        FreeAndNil(RH2);
      end;
      // ��������� ������������� ��� ������, ������� ����� �������������
      RH.Field[AID.FieldName] := QuerySearchMainParameter.PKValue;
      // ��������� ��������� ������ � ��
      ParametersApplyQuery.UpdateRecord(RH);
      // ��������� ����������� ������ �� �������
      RH.Put(ASender);
      AIsCustomParameter.AsBoolean := True;
    end
    else
    begin
      // �������� ���� � �����
      RH.Attach(ASender);
      // ��������� ������ �� ������� � ��������� ID �� �������
      AID.AsInteger := ParametersApplyQuery.InsertRecord(RH);
    end;
    // ��������.
    // PostMessage(Handle, WM_arInsert, AID.AsInteger, 0);
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryMainParameters.ApplyUpdate(ASender: TDataSet);
var
  AID: TField;
  AIsCustomParameter: TField;
  ATableName: TField;
  i: Integer;
  RH: TRecordHolder;
begin
  AID := ASender.FieldByName(PKFieldName);
  ATableName := ASender.FieldByName(TableName.FieldName);
  AIsCustomParameter := ASender.FieldByName(IsCustomParameter.FieldName);

  Assert(AID.AsInteger > 0);

  if ATableName.AsString.IsEmpty then
    raise EAbort.Create('��������� ��� �� ������ ���� ������');

  RH := TRecordHolder.Create();
  try
    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := QuerySearchMainParameter.Search(ATableName.AsString, True);
    // ���� ����� � � ������ �����
    if (i > 0) and (AID.AsInteger <> QuerySearchMainParameter.PKValue) then
    begin
      // ����� ���������� �� ������������ ������ � ���������
      // �������� ���� � �����
      RH.Attach(ASender, Format('%s;%s', [PKFieldName,
        IsCustomParameter.FieldName]));
      if RH.Count > 0 then
      begin
        QuerySearchMainParameter.TryEdit;
        // ������ ����
        RH.Put(QuerySearchMainParameter.FDQuery);
        QuerySearchMainParameter.TryPost;
      end;

      // ������� �� ������, ������� ������-��� ������������� �� �������
      ParametersApplyQuery.DeleteRecord(AID.AsInteger);

      // ������ ������������� ��� ������, ��� ������ �� �������
      AID.AsInteger := QuerySearchMainParameter.PKValue;
      // ��������, ��� �� ����� ���� � ���������� "�� ���������"
      AIsCustomParameter.AsBoolean := True;
      // ��������.
      // PostMessage(Handle, WM_arInsert, AID.AsInteger, 0);

    end
    else
    begin
      // �������� ���� � �����
      RH.Attach(ASender);
      ParametersApplyQuery.UpdateRecord(RH);
    end;
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryMainParameters.DoAfterCommitOrRollback(Sender: TObject);
begin
  FHaveAnyChanges := False;
end;

procedure TQueryMainParameters.DoAfterInsert(Sender: TObject);
begin
  FDQuery.FieldByName('IsCustomParameter').AsBoolean := False;
end;

procedure TQueryMainParameters.DoAfterInsertMessage(var Message: TMessage);
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

procedure TQueryMainParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := '������������';
  Value.Required := True;

  // Checked.FieldKind := fkInternalCalc;
  Checked.ReadOnly := False;

end;

procedure TQueryMainParameters.DoAfterPost(Sender: TObject);
begin
  TryCommit;
end;

procedure TQueryMainParameters.DoBeforeOpen(Sender: TObject);
begin
  SetParameters(['TableName', 'ProductCategoryID'],
    [FTableNameFilter, FProductCategoryIDValue]);

  if FDQuery.FieldCount = 0 then
  begin
    // ��������� �������� �����
    FDQuery.FieldDefs.Update;
    // ������ ���� �� ���������
    CreateDefaultFields(False);
    Checked.FieldKind := fkInternalCalc;
  end;
end;

procedure TQueryMainParameters.DoBeforePost(Sender: TObject);
var
  AField: TField;
begin
  if FHaveAnyChanges then
    Exit;

  for AField in FDQuery.Fields do
  begin
    if (AField <> Checked) and (AField.OldValue <> AField.Value) then
    begin
      FHaveAnyChanges := True;
      break;
    end;
  end;
end;

procedure TQueryMainParameters.DoOnDataChange(Sender: TObject);
begin
  // TryCommit;
end;

procedure TQueryMainParameters.DoOnUpdateOrder(ARecOrder: TRecOrder);
begin
  Order.Value := ARecOrder.Order;
end;

function TQueryMainParameters.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryMainParameters.GetCheckedPKValues: string;
var
  AClone: TFDMemTable;
begin
  Result := '';
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    // ��������� �����
    AClone.Filter := Format('%s = %d', [Checked.FieldName, 1]);
    AClone.Filtered := True;
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',');
      Result := Result + AClone.FieldByName(PKFieldName).AsString;
      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TQueryMainParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryMainParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryMainParameters.GetOrder: TField;
begin
  Result := Field('Order');
end;

function TQueryMainParameters.GetQuerySearchMainParameter
  : TQuerySearchMainParameter;
begin
  if FQuerySearchMainParameter = nil then
  begin
    FQuerySearchMainParameter := TQuerySearchMainParameter.Create(Self);
  end;

  Result := FQuerySearchMainParameter;
end;

function TQueryMainParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryMainParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryMainParameters.Locate(const AFieldName, AValue: string): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := FDQuery.LocateEx(AFieldName , AValue,
    [lxoCaseInsensitive, lxoPartialKey]);
end;

function TQueryMainParameters.Lookup(AValue: string): Integer;
var
  V: Variant;
begin
  V := FDQuery.LookupEx(Value.FieldName, AValue, PKFieldName,
    [lxoCaseInsensitive]);
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

procedure TQueryMainParameters.MoveDSRecord(AStartDrag: TStartDrag;
  ADropDrag: TDropDrag);
var
  AClone: TFDMemTable;
  AKeyField: TField;
  ANewOrderValue: Integer;
  AOrderField: TField;
  // ARecOrder: TRecOrder;
  i: Integer;
  IsDown: Boolean;
  IsUp: Boolean;
  Sign: Integer;
begin

  // ��������� �������� ������� ����������
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;

    // ���� ��� ������� �����
    IsUp := (ADropDrag.OrderValue < AStartDrag.MinOrderValue);
    // ���� ��� ������� ����
    IsDown := not IsUp;

    AOrderField := AClone.FieldByName(Order.FieldName);
    AKeyField := AClone.FieldByName(PKFieldName);

    while not AClone.Eof do
    begin
      Sign := 0;

      // ���� ������������� �����
      if IsUp and (AOrderField.AsInteger >= ADropDrag.OrderValue) and
        (AOrderField.AsInteger < AStartDrag.MinOrderValue) then
        Sign := 1;

      // ���� ������������� ����
      if IsDown and (AOrderField.AsInteger <= ADropDrag.OrderValue) and
        (AOrderField.AsInteger > AStartDrag.MaxOrderValue) then
        Sign := -1;

      // ���� ������� ������ ����� ��������
      if Sign <> 0 then
      begin
        // ����������, ��� ����� ��������
        FRecOrderList.Add(TRecOrder.Create(AKeyField.AsInteger,
          AOrderField.AsInteger + Sign * Length(AStartDrag.Keys)));
      end;

      AClone.Next;
    end;

    ANewOrderValue := ADropDrag.OrderValue;
    if IsDown then
      ANewOrderValue := ADropDrag.OrderValue - Length(AStartDrag.Keys) + 1;

    for i := Low(AStartDrag.Keys) to High(AStartDrag.Keys) do
    begin
      // ����������, ��� ����� ��������
      FRecOrderList.Add(TRecOrder.Create(AStartDrag.Keys[i],
        ANewOrderValue + i));
    end;
  finally
    FreeAndNil(AClone);
  end;

  // ��������� ��� ���������
  UpdateOrder;

end;

procedure TQueryMainParameters.SetShowDublicate(const Value: Boolean);
var
  ASQL: String;
  S: string;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    S := 'and tablename in '#13#10 + '( '#13#10 + 'select TableName'#13#10 +
      'from Parameters'#13#10 +
      'where ParentParameter is null and IDParameterType is not null'#13#10 +
      'group by TableName'#13#10 + 'having count(*) > 1'#13#10 + ')';

    ASQL := fdqBase.SQL.Text;
    if FShowDublicate then
      ASQL := Replace(ASQL, S, '-- and tablename in');

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
  end;
end;

procedure TQueryMainParameters.SetTableNameFilter(const Value: string);
begin
  if FTableNameFilter <> Value then
  begin
    FTableNameFilter := Value;
    FDQuery.Close;
    FDQuery.Open;
  end;
end;

procedure TQueryMainParameters.TryCommit;
begin
  // ���� ������� ��������� ����� ������� �� �������
  if (not AutoTransaction) and (not FHaveAnyChanges) and
    (FDQuery.Connection.InTransaction) then
  begin
    FDQuery.Connection.Commit;
  end;
end;

procedure TQueryMainParameters.UpdateOrder;
var
  APKValue: Integer;
  i: Integer;
  Ok: Boolean;
begin
  if FRecOrderList.Count = 0 then
  begin
    Exit;
  end;

  FDQuery.DisableControls;
  try
    APKValue := PKValue;
    try
      // ������ �������� �������
      for i := 0 to FRecOrderList.Count - 1 do
      begin
        Ok := FDQuery.Locate(PKFieldName, FRecOrderList[i].Key, []);
        Assert(Ok);

        FDQuery.Edit;
        DoOnUpdateOrder(FRecOrderList[i]);
        FDQuery.Post;
      end;

      for i := 0 to FRecOrderList.Count - 1 do
        FRecOrderList[i].Free;
      FRecOrderList.Clear;
    finally
      FDQuery.Locate(PKFieldName, APKValue, []);
    end;
  finally
    FDQuery.EnableControls;
  end;

end;

end.
