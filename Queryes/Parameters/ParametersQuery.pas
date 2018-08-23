unit ParametersQuery;

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
  TQueryParameters = class(TQueryOrder)
    fdqBase: TFDQuery;
    fdqDeleteFromCategoryParams: TFDQuery;
  strict private
  private
    FCheckClone: TFDMemTable;
    FProductCategoryIDValue: Integer;
    FqSearchParameter: TQuerySearchParameter;
    FShowDuplicate: Boolean;
    FTableNameFilter: string;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetCheckClone: TFDMemTable;
    function GetChecked: TField;
    function GetCodeLetters: TField;
    function GetDefinition: TField;
    function GetIDParameterKind: TField;
    function GetIDParameterType: TField;
    function GetParamSubParamID: TField;
    function GetIsCustomParameter: TField;
    function GetMeasuringUnit: TField;
    function GetqSearchParameter: TQuerySearchParameter;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    procedure SetShowDuplicate(const Value: Boolean);
    procedure SetTableNameFilter(const Value: string);
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure DoBeforePost(Sender: TObject);
    function GetOrd: TField; override;
    property CheckClone: TFDMemTable read GetCheckClone;
    property qSearchParameter: TQuerySearchParameter read GetqSearchParameter;
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedValues(const AFieldName: String): string;
    function Lookup(AValue: string): Integer;
    property Checked: TField read GetChecked;
    property CodeLetters: TField read GetCodeLetters;
    property Definition: TField read GetDefinition;
    property IDParameterKind: TField read GetIDParameterKind;
    property IDParameterType: TField read GetIDParameterType;
    property ParamSubParamID: TField read GetParamSubParamID;
    property IsCustomParameter: TField read GetIsCustomParameter;
    property MeasuringUnit: TField read GetMeasuringUnit;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property TableName: TField read GetTableName;
    property TableNameFilter: string read FTableNameFilter
      write SetTableNameFilter;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder, System.StrUtils, StrHelper,
  BaseQuery, ErrorType, System.Math;

constructor TQueryParameters.Create(AOwner: TComponent);
begin
  inherited;

  // �������� ������� ������ � ���������
  AssignFrom(fdqBase);

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������������� �� �������
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  AutoTransaction := False;
end;

procedure TQueryParameters.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  if PK.AsInteger <= 0 then
    Exit;

  // ���� �������� ������� �������� "�� ���������"
  if IsCustomParameter.AsBoolean then
  begin
    // ���������� �������� "�� ���������" � "������" ���������
    qSearchParameter.SearchByID(PK.AsInteger, True);
    qSearchParameter.TryEdit;
    qSearchParameter.IDParameterType.Value := NULL;
    qSearchParameter.TryPost;

    // ��� ���� ������� ������ �� ���� ��������
    fdqDeleteFromCategoryParams.ParamByName('ParamSubParamId').AsInteger :=
      ParamSubParamID.AsInteger;
    fdqDeleteFromCategoryParams.ExecSQL;
  end
  else
  begin
    qSearchParameter.SearchByID(PK.AsInteger, True);
    qSearchParameter.FDQuery.Delete;
  end;
end;

procedure TQueryParameters.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIsCustomParameter: Boolean;
  i: Integer;
  RH: TRecordHolder;
  AAIsCustomParameter: Integer;
begin
  Assert(ASender = FDQuery);
  Assert(not TableName.AsString.IsEmpty);

  AIsCustomParameter := False;

  RH := TRecordHolder.Create();
  try

    // ���������� ����, ������� �� ������-��� ��������������� �� �������
    RH.Attach(FDQuery, Format('%s;%s;%s;%s;%s',
      [PKFieldName, IsCustomParameter.FieldName, Checked.FieldName,
      ParamSubParamID.FieldName, Ord.FieldName]));

    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := qSearchParameter.SearchByTableName(TableName.AsString, True);
    // ���� ����� �������� �� ��������� � � ������ �����
    if (i > 0) and (PK.AsInteger <> qSearchParameter.PK.AsInteger) then
    begin
      qSearchParameter.TryEdit;
      AIsCustomParameter := True;
    end
    else
    begin
      qSearchParameter.TryAppend;
    end;

    // ������ ����
    RH.Put(qSearchParameter.FDQuery);
    qSearchParameter.IsCustomParameter.AsBoolean := AIsCustomParameter;

    // ��������� �� �������
    qSearchParameter.TryPost;

    AAIsCustomParameter := IfThen(AIsCustomParameter, 1, 0);

    // ���������� ���������� ����� �� ������� �������
    FetchFields([PK.FieldName, IsCustomParameter.FieldName,
      ParamSubParamID.FieldName, '[' + Ord.FieldName + ']'], [qSearchParameter.PK.Value,
      AAIsCustomParameter, qSearchParameter.ParamSubParamID.Value,
      qSearchParameter.Order.Value],
      ARequest, AAction, AOptions);
  finally
    FreeAndNil(RH);
  end;
end;

procedure TQueryParameters.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AID: Integer;
  AIsCustomEdited: Boolean;
  i: Integer;
  RH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  Assert(PK.AsInteger > 0);

  if TableName.AsString.IsEmpty then
    raise EAbort.Create('��������� ��� �� ������ ���� ������');

  RH := TRecordHolder.Create();
  try
    // �������� ���� � �����
    RH.Attach(FDQuery, Format('%s;%s;%s;%s',
      [PKFieldName, IsCustomParameter.FieldName, Checked.FieldName,
      ParamSubParamID.FieldName]));

    // ���� �������� "�� ���������" � �����-�� ��������� ������
    i := qSearchParameter.SearchByTableName(TableName.AsString, True);
    AIsCustomEdited := (i > 0) and
      (PK.AsInteger <> qSearchParameter.PK.AsInteger);

    // ���� �� ������������� �� �������� �� ���������
    if not AIsCustomEdited then
      // ���� �� ������, ������� ������-��� ������������� �� �������
      qSearchParameter.SearchByID(PK.AsInteger, True);

    // ������ ���� �� �������
    qSearchParameter.TryEdit;
    RH.Put(qSearchParameter.FDQuery);
    qSearchParameter.TryPost;
  finally
    FreeAndNil(RH);
  end;

  // ���� �� ������������� �������� �� ���������
  if AIsCustomEdited then
  begin
    AID := qSearchParameter.PK.AsInteger;

    // ������� �� ������, ������� ������-��� ������������� �� �������
    qSearchParameter.SearchByID(PK.AsInteger, True);
    qSearchParameter.FDQuery.Delete;

    // ������ ������������� ��� ������, ��� ������ �� �������
    FetchFields([PK.FieldName, IsCustomParameter.FieldName], [AID, 1], ARequest,
      AAction, AOptions);
  end
end;

procedure TQueryParameters.DoAfterInsert(Sender: TObject);
begin
  FDQuery.FieldByName('IsCustomParameter').AsBoolean := False;
end;

procedure TQueryParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := '������������';
  Value.Required := True;

  Checked.ReadOnly := False;
end;

procedure TQueryParameters.DoBeforeOpen(Sender: TObject);
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

procedure TQueryParameters.DoBeforePost(Sender: TObject);
begin
  // ���� �� ��������� ��������� ���, �� ��������� ��� = ������������
  if TableName.AsString.IsEmpty then
  begin
    TableName.AsString := Value.AsString;
  end;
end;

function TQueryParameters.GetCheckClone: TFDMemTable;
begin
  if FCheckClone = nil then
    FCheckClone := AddClone('');
  Result := FCheckClone;
end;

function TQueryParameters.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryParameters.GetCheckedValues(const AFieldName: String): string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := AddClone(Format('%s = %d', [Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

function TQueryParameters.GetCodeLetters: TField;
begin
  Result := Field('CodeLetters');
end;

function TQueryParameters.GetDefinition: TField;
begin
  Result := Field('Definition');
end;

function TQueryParameters.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQueryParameters.GetIDParameterType: TField;
begin
  Result := Field('IDParameterType');
end;

function TQueryParameters.GetParamSubParamID: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQueryParameters.GetIsCustomParameter: TField;
begin
  Result := Field('IsCustomParameter');
end;

function TQueryParameters.GetMeasuringUnit: TField;
begin
  Result := Field('MeasuringUnit');
end;

function TQueryParameters.GetOrd: TField;
begin
  Result := Field('Order');
end;

function TQueryParameters.GetqSearchParameter: TQuerySearchParameter;
begin
  if FqSearchParameter = nil then
  begin
    FqSearchParameter := TQuerySearchParameter.Create(Self);
  end;

  Result := FqSearchParameter;
end;

function TQueryParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryParameters.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

function TQueryParameters.Lookup(AValue: string): Integer;
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

procedure TQueryParameters.SetShowDuplicate(const Value: Boolean);
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

procedure TQueryParameters.SetTableNameFilter(const Value: string);
begin
  if FTableNameFilter <> Value then
  begin
    FTableNameFilter := Value;
    FDQuery.Close;
    FDQuery.Open;
  end;
end;

end.
