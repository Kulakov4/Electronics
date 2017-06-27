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
  SearchComponentsByValues, StoreHouseListQuery, NotifyEvents,
  System.Generics.Collections;

type
  TQueryProductsSearch = class(TQueryProductsBase)
    fdqBase: TFDQuery;
  strict private
  private
    FClone: TFDMemTable;
    FGetModeClone: TFDMemTable;
    FMode: TContentMode;
    FOnBeginUpdate: TNotifyEventsEx;
    FOnEndUpdate: TNotifyEventsEx;
    FqStoreHouseList: TQueryStoreHouseList;

  const
    FEmptyAmount = 1;
    function GetCurrentMode: TContentMode;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function GetIsClearEnabled: Boolean;
    function GetIsSearchEnabled: Boolean;
    function GetqStoreHouseList: TQueryStoreHouseList;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function GetExportFileName: string; override;
    function GetHaveAnyChanges: Boolean; override;
    // procedure SetConditionSQL(const AConditionSQL, AMark: String;
    // ANotifyEventRef: TNotifyEventRef = nil);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AFieldName: string; AValues: TArray<String>); override;
    procedure ClearSearchResult;
    procedure DoSearch(ALike: Boolean);
    procedure Search(AValues: TList<String>); overload;
    property IsClearEnabled: Boolean read GetIsClearEnabled;
    property IsSearchEnabled: Boolean read GetIsSearchEnabled;
    property Mode: TContentMode read FMode;
    property OnBeginUpdate: TNotifyEventsEx read FOnBeginUpdate;
    property OnEndUpdate: TNotifyEventsEx read FOnEndUpdate;
    property qStoreHouseList: TQueryStoreHouseList read GetqStoreHouseList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Math, RepositoryDataModule, AbstractSearchByValues,
  System.StrUtils, StrHelper;

constructor TQueryProductsSearch.Create(AOwner: TComponent);
begin
  inherited;

  // � ������ ������ - ���������� ���������
  AutoTransaction := True;

  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, 'where p.ID = 0', '--where');

  // ������ ��� �����
  FGetModeClone := TFDMemTable.Create(Self);
  FClone := TFDMemTable.Create(Self);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);

  FOnBeginUpdate := TNotifyEventsEx.Create(Self);
  FOnEndUpdate := TNotifyEventsEx.Create(Self);
end;

procedure TQueryProductsSearch.AppendRows(AFieldName: string;
  AValues: TArray<String>);
begin
  if Mode = SearchMode then
  begin
    // ������� ������ ������
    if Value.AsString.IsEmpty then
      FDQuery.Delete;

    inherited;
  end;

end;

procedure TQueryProductsSearch.ApplyDelete(ASender: TDataSet);
begin
  if Mode = RecordsMode then
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
  if Mode = RecordsMode then
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
  SetConditionSQL(fdqBase.SQL.Text, 'where p.ID = 0', '--where');
end;

procedure TQueryProductsSearch.DoAfterClose(Sender: TObject);
begin
  FGetModeClone.Close;
  FClone.Close;
end;

procedure TQueryProductsSearch.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  // ��������� �����
  FGetModeClone.CloneCursor(FDQuery);
  FGetModeClone.Filter := 'ID > 0';
  FGetModeClone.Filtered := True;

  FClone.CloneCursor(FDQuery);
  FClone.Filter := 'Value <> null';
  FClone.Filtered := True;

  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  // ��������� ������ ������ ��� ������, ���� ��� ����������
  AutoTransaction := True;

  for I := FDQuery.RecordCount to FEmptyAmount - 1 do
  begin
    FDQuery.Append;
    FDQuery.Fields[1].AsString := '';
    FDQuery.Post;
  end;

  FDQuery.First;

  // ��������� � ����� ����� �� �������
  FMode := GetCurrentMode;

  // �������� ������ ����� ����������
  AutoTransaction := Mode = SearchMode;
end;

procedure TQueryProductsSearch.DoSearch(ALike: Boolean);
var
  AConditionSQL: string;
  AMark: string;
  m: TArray<String>;
  s: string;
begin
  TryPost;

  AMark := '--join';

  // ��������� ����� ������� ������ �� �������� ���� Value
  s := GetFieldValues('Value').Trim([',']);

  if ALike then
  begin
    AConditionSQL := '';
    m := s.Split([',']);
    // ��������� ��������� �������
    for s in m do
    begin
      AConditionSQL := IfThen(AConditionSQL.IsEmpty, '', ' or ');
      AConditionSQL := AConditionSQL + Format('p.Value like %s',
        [QuotedStr(s + '%')]);
    end;
    AConditionSQL := Format(' and (%s)', [AConditionSQL]);
    SetConditionSQL(fdqBase.SQL.Text, AConditionSQL, AMark);
  end
  else
  begin
    AConditionSQL :=
      ' and (instr('',''||:Value||'','', '',''||p.Value||'','') > 0)';
    SetConditionSQL(fdqBase.SQL.Text, AConditionSQL, AMark,
      procedure(Sender: TObject)
      begin
        with FDQuery.ParamByName('Value') do
        begin
          DataType := ftString;
          ParamType := ptInput;
          AsString := s;
        end;
      end);
  end;
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

  case Mode of
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
  Result := (Mode = RecordsMode);

  if not Result then
  begin
    Result := FClone.RecordCount > 0;
  end;
end;

function TQueryProductsSearch.GetIsSearchEnabled: Boolean;
begin
  Result := (Mode = SearchMode) and (FClone.RecordCount > 0);
end;

function TQueryProductsSearch.GetqStoreHouseList: TQueryStoreHouseList;
begin
  if FqStoreHouseList = nil then
  begin
    FqStoreHouseList := TQueryStoreHouseList.Create(Self);
    FqStoreHouseList.RefreshQuery;
  end;
  Result := FqStoreHouseList;
end;

procedure TQueryProductsSearch.Search(AValues: TList<String>);
begin
  FOnBeginUpdate.CallEventHandlers(Self);
  try
    // ������� ��������� ������
    ClearSearchResult;

    // ��������� �� ������, ������� ����� ������ �� ������
    AppendRows(Value.FieldName, AValues.ToArray);

    // ������������ �����
    DoSearch(False);
  finally
    FOnEndUpdate.CallEventHandlers(Self);
  end;
end;

end.
