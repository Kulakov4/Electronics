unit MainParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections,
  NotifyEvents, QueryWithDataSourceUnit, SearchParameterQuery,
  ApplyQueryFrame, OrderQuery;

type
  TQueryMainParameters = class(TQueryOrder)
    fdqBase: TFDQuery;
    ParametersApplyQuery: TfrmApplyQuery;
    fdqDeleteFromCategoryParams: TFDQuery;
  private
    FProductCategoryIDValue: Integer;
    FqSearchParameter: TQuerySearchParameter;
    FShowDuplicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetChecked: TField;
    function GetIDParameterKind: TField;
    function GetIDParameterType: TField;
    function GetIsCustomParameter: TField;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetTableName: TField;
    function GetValue: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function GetOrd: TField; override;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedPKValues: string;
    function Lookup(AValue: string): Integer;
    property Checked: TField read GetChecked;
    property IDParameterKind: TField read GetIDParameterKind;
    property IDParameterType: TField read GetIDParameterType;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
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

  // �������� ������� ������ � ���������
  AssignFrom(fdqBase);

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������������� �� �������
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

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

      // ��� ���� ������� ������ �� ���� ��������
      fdqDeleteFromCategoryParams.ParamByName('ParameterID').AsInteger :=
        AID.AsInteger;
      fdqDeleteFromCategoryParams.ExecSQL;
    finally
      FreeAndNil(RH);
    end;
  end
  else
  begin
    ParametersApplyQuery.DeleteRecord(AID.AsInteger);
  end;
end;

procedure TQueryMainParameters.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AID: Integer;
  i: Integer;
  RH: TRecordHolder;
  RH2: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  // ���� �� ��������� ��������� ���, �� ��������� ��� = ������������
  if TableName.AsString.IsEmpty then
    TableName.AsString := Value.AsString;

  RH := TRecordHolder.Create(ASender);
  try
    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := qSearchParameter.SearchMain(TableName.AsString, True);
    // ���� ����� � � ������ �����
    if (i > 0) and (PK.AsInteger <> qSearchParameter.PK.AsInteger) then
    begin
      // �������� ���� � ����� ����� IsCustomParameter
      RH.Attach(ASender, IsCustomParameter.FieldName);

      RH2 := TRecordHolder.Create(qSearchParameter.FDQuery);
      try
        // ��������� ������ ����
        RH.UpdateNullValues(RH2);
      finally
        FreeAndNil(RH2);
      end;
      // ��������� ������������� ��� ������, ������� ����� �������������
      RH.Field[PK.FieldName] := qSearchParameter.PK.Value;
      // ��������� ��������� ������ � ��
      ParametersApplyQuery.UpdateRecord(RH);
      // ��������� ����������� ������ �� �������
      RH.Put(ASender);
      IsCustomParameter.AsBoolean := True;
    end
    else
    begin
      // �������� ���� � �����
      RH.Attach(ASender);
      // ��������� ������ �� ������� � ��������� ID �� �������
      AID := ParametersApplyQuery.InsertRecord(RH);
      FetchFields([PK.FieldName], [AID], ARequest, AAction, AOptions);
    end;
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryMainParameters.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  i: Integer;
  RH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  Assert(PK.AsInteger > 0);

  if TableName.AsString.IsEmpty then
    raise EAbort.Create('��������� ��� �� ������ ���� ������');

  RH := TRecordHolder.Create();
  try
    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := qSearchParameter.SearchMain(TableName.AsString, True);
    // ���� ����� � � ������ �����
    if (i > 0) and (PK.AsInteger <> qSearchParameter.PK.AsInteger) then
    begin
      // ����� ���������� �� ������������ ������ � ���������
      // �������� ���� � �����
      RH.Attach(ASender, Format('%s;%s', [PKFieldName,
        IsCustomParameter.FieldName]));
      if RH.Count > 0 then
      begin
        qSearchParameter.TryEdit;
        // ������ ����
        RH.Put(qSearchParameter.FDQuery);
        qSearchParameter.TryPost;
      end;

      // ������� �� ������, ������� ������-��� ������������� �� �������
      ParametersApplyQuery.DeleteRecord(PK.AsInteger);

      // ������ ������������� ��� ������, ��� ������ �� �������
      FetchFields([PK.FieldName], [qSearchParameter.PK.Value], ARequest, AAction, AOptions);
      //AID.Value := qSearchParameter.PK.Value;
      // ��������, ��� �� ����� ���� � ���������� "�� ���������"
      IsCustomParameter.AsBoolean := True;
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

procedure TQueryMainParameters.DoAfterInsert(Sender: TObject);
begin
  FDQuery.FieldByName('IsCustomParameter').AsBoolean := False;
end;

procedure TQueryMainParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := '������������';
  Value.Required := True;

  Checked.ReadOnly := False;
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

function TQueryMainParameters.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQueryMainParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryMainParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryMainParameters.GetOrd: TField;
begin
  Result := Field('Order');
end;

function TQueryMainParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
  begin
    FqSearchParameter := TQuerySearchParameter.Create(Self);
  end;

  Result := FqSearchParameter;
end;

function TQueryMainParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryMainParameters.GetValue: TField;
begin
  Result := Field('Value');
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

procedure TQueryMainParameters.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate <> Value then
  begin
    FShowDuplicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDuplicate then
    begin
      ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
      ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
    end;

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

end.
