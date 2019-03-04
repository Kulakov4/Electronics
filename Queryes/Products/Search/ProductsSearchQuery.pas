unit ProductsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ProductsBaseQuery, SearchInterfaceUnit, ApplyQueryFrame,
  StoreHouseListQuery, NotifyEvents, System.Generics.Collections, DSWrap;

type
  TProductSearchW = class(TProductW)
  private
    FMode: TContentMode;
  public
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    property Mode: TContentMode read FMode;
  end;

  TQueryProductsSearch = class(TQueryProductsBase)
  strict private
  private
    FClone: TFDMemTable;
    FGetModeClone: TFDMemTable;
    FOnBeginUpdate: TNotifyEventsEx;
    FOnEndUpdate: TNotifyEventsEx;
    FX: Integer;

  const
    FEmptyAmount = 1;
    function GetCurrentMode: TContentMode;
    procedure DoAfterOpen(Sender: TObject);
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    function GetProductSearchW: TProductSearchW;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoBeforePost(Sender: TObject); override;
    function GetExportFileName: string; override;
    function GetHaveAnyChanges: Boolean; override;
    // procedure SetConditionSQL(const AConditionSQL, AMark: String;
    // ANotifyEventRef: TNotifyEventRef = nil);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ClearSearchResult;
    procedure DoSearch(ALike: Boolean);
    procedure Search(AValues: TList<String>); overload;
    procedure SetSQLForSearch;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    property OnBeginUpdate: TNotifyEventsEx read FOnBeginUpdate;
    property OnEndUpdate: TNotifyEventsEx read FOnEndUpdate;
    property ProductSearchW: TProductSearchW read GetProductSearchW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Math, RepositoryDataModule, System.StrUtils, StrHelper;

constructor TQueryProductsSearch.Create(AOwner: TComponent);
begin
  inherited;

  // � ������ ������ - ���������� ���������
  AutoTransaction := True;

  // ������ ��� �����
  FGetModeClone := W.AddClone(Format('%s < %d', [W.PKFieldName,
    FVirtualIDOffset]));
  FClone := W.AddClone(Format('%s <> null', [W.Value.FieldName]));

  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);

  FOnBeginUpdate := TNotifyEventsEx.Create(Self);
  FOnEndUpdate := TNotifyEventsEx.Create(Self);
end;

destructor TQueryProductsSearch.Destroy;
begin
  FreeAndNil(FOnBeginUpdate);
  FreeAndNil(FOnEndUpdate);
  inherited;
end;

procedure TQueryProductsSearch.AfterConstruction;
begin
  // ��������� �������������� SQL
  inherited;

  SetSQLForSearch;
end;

procedure TQueryProductsSearch.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ProductSearchW.Mode = RecordsMode then
    inherited;
end;

procedure TQueryProductsSearch.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // ������ �� ������
end;

procedure TQueryProductsSearch.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  if ProductSearchW.Mode = RecordsMode then
    inherited;
end;

function TQueryProductsSearch.GetCurrentMode: TContentMode;
begin
  if (FDQuery.RecordCount = 0) or (FGetModeClone.RecordCount > 0) then
    Result := RecordsMode
  else
    Result := SearchMode;
end;

procedure TQueryProductsSearch.ClearSearchResult;
begin
  SetSQLForSearch;
  W.RefreshQuery;
end;

function TQueryProductsSearch.CreateDSWrap: TDSWrap;
begin
  Result := TProductSearchW.Create(FDQuery);
end;

procedure TQueryProductsSearch.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  W.SetFieldsRequired(False);
  W.SetFieldsReadOnly(False);

  // ��������� ������ ������ ��� ������, ���� ��� ����������
//  AutoTransaction := True;

  for I := FDQuery.RecordCount to FEmptyAmount - 1 do
  begin
    FDQuery.Append;
    W.Value.F.AsString := '';
    FDQuery.Post;
    FDQuery.ApplyUpdates();
    FDQuery.CommitUpdates;
  end;

  FDQuery.First;

  // ��������� � ����� ����� �� �������
  ProductSearchW.FMode := GetCurrentMode;

  // �������� ������ ����� ����������
//  AutoTransaction := ProductSearchW.Mode = SearchMode;
end;

procedure TQueryProductsSearch.DoBeforePost(Sender: TObject);
begin
;
  // ������������ ��� ��� ������
  // ������ �� ����� �� ����������� � �������� �� �����!!!
end;

procedure TQueryProductsSearch.DoSearch(ALike: Boolean);
var
  AConditionSQL: string;
  ANewSQL: string;
  m: TArray<String>;
  p: Integer;
  s: string;
begin
  W.TryPost;

  // ��������� ����� ������� ������ �� �������� ���� Value
  s := W.Value.AllValues;

  // ���� ����� �� ������ ������
  if s = '' then
    ALike := True;

  if ALike then
  begin
    AConditionSQL := '';
    m := s.Split([',']);
    // ��������� ��������� �������
    for s in m do
    begin
      AConditionSQL := IfThen(AConditionSQL.IsEmpty, '', ' or ');
      AConditionSQL := AConditionSQL + Format('%s like %s',
        [W.Value.FullName, QuotedStr(s + '%')]);
    end;

    // if not AConditionSQL.IsEmpty then
    // AConditionSQL := Format(' and (%s)', [AConditionSQL]);
  end
  else
  begin
    AConditionSQL := Format('instr('',''||:%s||'','', '',''||%s||'','') > 0',
      [W.Value.FieldName, W.Value.FullName]);
    // ' and (instr('',''||:Value||'','', '',''||p.Value||'','') > 0)';
  end;

  p := SQL.IndexOf('1=1');
  Assert(p > 0);
  ANewSQL := SQL.Replace('1=1', AConditionSQL);
  p := ANewSQL.IndexOf('2=2');
  Assert(p > 0);
  ANewSQL := ANewSQL.Replace('2=2', AConditionSQL);

  FDQuery.Close;
  FDQuery.SQL.Text := ANewSQL;

  if not ALike then
  begin
    SetParamTypeEx(W.Value.FieldName, s, ptInput, ftWideString);
  end;

  FDQuery.Open;
end;

function TQueryProductsSearch.GetExportFileName: string;
begin
  Result := Format('����� %s.xls', [FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
end;

// ����-�� ��������� �� ���������� � ��
function TQueryProductsSearch.GetHaveAnyChanges: Boolean;
begin
  Result := False;

  case ProductSearchW.Mode of
    RecordsMode:
      Result := inherited;
    SearchMode:
      Result := False;
  else
    Assert(False);
  end;
end;

function TQueryProductsSearch.GetIsClearEnabled: Boolean;
begin
  Result := (ProductSearchW.Mode = RecordsMode);

  if not Result then
  begin
    Result := FClone.RecordCount > 0;
  end;
end;

function TQueryProductsSearch.GetIsSearchEnabled: Boolean;
begin
  Result := (ProductSearchW.Mode = SearchMode) and (FClone.RecordCount > 0);
end;

function TQueryProductsSearch.GetProductSearchW: TProductSearchW;
begin
  Result := W as TProductSearchW;
end;

procedure TQueryProductsSearch.Search(AValues: TList<String>);
begin
  FOnBeginUpdate.CallEventHandlers(Self);
  try
    // ������� ��������� ������
    ClearSearchResult;

    // ��������� �� ������, ������� ����� ������ �� ������
    ProductSearchW.AppendRows(W.Value.FieldName, AValues.ToArray);

    // ������������ �����
    DoSearch(False);
  finally
    FOnEndUpdate.CallEventHandlers(Self);
  end;
end;

procedure TQueryProductsSearch.SetSQLForSearch;
var
  p: Integer;
begin
  // ������ ������ ����� ���������� �� ���������� �� ����� ������
  p := SQL.IndexOf('0=0');
  Assert(p > 0);
  FDQuery.SQL.Text := SQL.Replace('0=0', Format('%s=0', [W.ID.FieldName]));
end;

procedure TProductSearchW.AppendRows(AFieldName: string;
  AValues: TArray<String>);
begin
  if Length(AValues) = 0 then
    Exit;

  if Mode = SearchMode then
  begin
    // ������� ������ ������
    if Value.F.AsString.IsEmpty then
      DataSet.Delete;

    inherited;
  end;

end;

end.
