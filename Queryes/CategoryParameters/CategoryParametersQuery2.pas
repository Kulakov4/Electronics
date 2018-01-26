unit CategoryParametersQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, RecursiveParametersQuery;

type
  TQueryCategoryParameters2 = class(TQueryWithDataSource)
  private
    FInsertedClone: TFDMemTable;
    FMaxOrder: Integer;
    FOn_ApplyUpdates: TNotifyEventsEx;
    FQueryRecursiveParameters: TQueryRecursiveParameters;
    FRefreshQry: TQueryCategoryParameters2;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetCategoryID: TField;
    function GetHaveInserted: Boolean;
    function GetIsAttribute: TField;
    function GetIsEnabled: TField;
    function GetOrd: TField;
    function GetParamSubParamId: TField;
    function GetPosID: TField;
    function GetProductCategoryID: TField;
    function GetQueryRecursiveParameters: TQueryRecursiveParameters;
    function GetRefreshQry: TQueryCategoryParameters2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest; var
        AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest; var
        AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property QueryRecursiveParameters: TQueryRecursiveParameters read
        GetQueryRecursiveParameters;
    property RefreshQry: TQueryCategoryParameters2 read GetRefreshQry;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    property CategoryID: TField read GetCategoryID;
    property HaveInserted: Boolean read GetHaveInserted;
    property IsAttribute: TField read GetIsAttribute;
    property IsEnabled: TField read GetIsEnabled;
    property Ord: TField read GetOrd;
    property ParamSubParamId: TField read GetParamSubParamId;
    property PosID: TField read GetPosID;
    property ProductCategoryID: TField read GetProductCategoryID;
    property On_ApplyUpdates: TNotifyEventsEx read FOn_ApplyUpdates;
    { Public declarations }
  end;


implementation

{$R *.dfm}

constructor TQueryCategoryParameters2.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
  // ����� ��������� � �� ��������� ����������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ������ ����
  FInsertedClone := AddClone('');
  FInsertedClone.FilterChanges := [rtInserted];

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);

  FOn_ApplyUpdates := TNotifyEventsEx.Create(Self);
end;

procedure TQueryCategoryParameters2.ApplyDelete(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  // ���������� ������� �� ��������� ��� ��������
  QueryRecursiveParameters.ExecDeleteSQL( ParamSubParamId.OldValue,
    CategoryID.OldValue);

  // ������� �� ��������� ������������ �������� ����������
//  fdqDeleteSubParameters.ExecSQL;
end;

procedure TQueryCategoryParameters2.ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // ���������� ��������� ������ � ��
  QueryRecursiveParameters.ExecInsertSQL(PosID.Value, Ord.Value,
    ParamSubParamId.Value, CategoryID.Value);

  // �������� ����������� ������ ����� ������ � �������������
  RefreshQry.Load([DetailParameterName, 'ParamSubParamID'],
    [CategoryID.Value, ParamSubParamId.Value]);

  // ������ ���� ������� ������ ���� ������
  // ����� - �������� ����������� ������������
  Assert(RefreshQry.FDQuery.RecordCount = 1);
  Assert(RefreshQry.PK.AsInteger > 0);

  // ��������� ��������� ���� � ����������� ������
  FetchFields([PK.FieldName], [RefreshQry.PK.Value], ARequest, AAction, AOptions);
  //AID.AsInteger := RefreshQry.PK.Value;
end;

procedure TQueryCategoryParameters2.ApplyUpdate(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // ���� ���������� ��������� ��������� ��� ��� �������
  if (PosID.OldValue <> PosID.Value) or (Ord.OldValue <> Ord.Value) or
    (IsAttribute.OldValue <> IsAttribute.NewValue) then
  begin
    QueryRecursiveParameters.ExecUpdateSQL(PosID.OldValue, PosID.Value,
      Ord.OldValue, Ord.Value, IsAttribute.OldValue, IsAttribute.Value,
      ParamSubParamId.AsInteger, CategoryID.AsInteger);
  end;
end;

procedure TQueryCategoryParameters2.ApplyUpdates;
begin
  inherited;
  // ����� � ��������� ��� ��� ���������
  FMaxOrder := 0;
  FOn_ApplyUpdates.CallEventHandlers(Self);
end;

procedure TQueryCategoryParameters2.CancelUpdates;
begin
  inherited;
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters2.DoAfterInsert(Sender: TObject);
begin
  IsEnabled.AsInteger := 1;
  IsAttribute.AsInteger := 1;
end;

procedure TQueryCategoryParameters2.DoAfterOpen(Sender: TObject);
begin
  SetFieldsReadOnly(False);
  FMaxOrder := 0;
end;

procedure TQueryCategoryParameters2.DoBeforePost(Sender: TObject);
begin
  ProductCategoryID.AsInteger := ParentValue;
end;

function TQueryCategoryParameters2.GetCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters2.GetHaveInserted: Boolean;
begin
  Result := FDQuery.Active and (FInsertedClone.RecordCount > 0);
end;

function TQueryCategoryParameters2.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryCategoryParameters2.GetIsEnabled: TField;
begin
  Result := Field('IsEnabled');
end;

function TQueryCategoryParameters2.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryCategoryParameters2.GetParamSubParamId: TField;
begin
  Result := Field('ParamSubParamID');
end;

function TQueryCategoryParameters2.GetPosID: TField;
begin
  Result := Field('PosID');
end;

function TQueryCategoryParameters2.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParameters2.GetQueryRecursiveParameters:
    TQueryRecursiveParameters;
begin
  if FQueryRecursiveParameters = nil then
    FQueryRecursiveParameters := TQueryRecursiveParameters.Create(Self);
  Result := FQueryRecursiveParameters;
end;

function TQueryCategoryParameters2.GetRefreshQry: TQueryCategoryParameters2;
begin
  if FRefreshQry = nil then
  begin
    FRefreshQry := TQueryCategoryParameters2.Create(Self);
    // ��������� � ����� SQL ������� ������� � ����������
    FRefreshQry.SetConditionSQL(FRefreshQry.FDQuery.SQL.Text,
      ' and ParamSubParamId = :ParamSubParamID', '--and');

    FRefreshQry.SetParamType('ParamSubParamID');
  end;

  Result := FRefreshQry;
end;

end.
