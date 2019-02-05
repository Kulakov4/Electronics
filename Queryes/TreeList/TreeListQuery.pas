unit TreeListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit,
  SearchCategoryQuery, NotifyEvents, DuplicateCategoryQuery, DSWrap;

type
  TTreeListW = class(TDSWrap)
  private
    FExternalID: TFieldWrap;
    FID: TFieldWrap;
    FParentId: TFieldWrap;
    FqSearchCategory: TQuerySearchCategory;
    FValue: TFieldWrap;
    function GetIsRootFocused: Boolean;
    function GetqSearchCategory: TQuerySearchCategory;
  protected
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddChildCategory(const AValue: string; ALevel: Integer);
    procedure AddRoot;
    function CheckPossibility(const AParentID: Integer;
      const AValue: String): Boolean;
    procedure Delete;
    procedure FilterByExternalID(AExternalID: string);
    function LocateByExternalID(AExternalID: string; AOptions:
        TFDDataSetLocateOptions = []): Boolean;
    procedure LocateToRoot;
    property ExternalID: TFieldWrap read FExternalID;
    property ID: TFieldWrap read FID;
    property IsRootFocused: Boolean read GetIsRootFocused;
    property ParentId: TFieldWrap read FParentId;
    property Value: TFieldWrap read FValue;
  end;

  TQueryTreeList = class(TQueryWithDataSource)
  private
    FAfterSmartRefresh: TNotifyEventsEx;
    FAutoSearchDuplicate: Boolean;
    FNeedRestoreAutoSearch: Boolean;
    FOldAutoSearchDuplicate: Boolean;
    FqDuplicateCategory: TQueryDuplicateCategory;
    FW: TTreeListW;
    function GetqDuplicateCategory: TQueryDuplicateCategory;
    procedure SetAutoSearchDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    procedure DoAfterScroll(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GotoDuplicate;
    procedure SmartRefresh; override;
    property AfterSmartRefresh: TNotifyEventsEx read FAfterSmartRefresh;
    property AutoSearchDuplicate: Boolean read FAutoSearchDuplicate
      write SetAutoSearchDuplicate;
    property qDuplicateCategory: TQueryDuplicateCategory
      read GetqDuplicateCategory;
    property W: TTreeListW read FW;
    { Public declarations }
  end;

implementation

uses System.Generics.Collections, ProjectConst;

{$R *.dfm}

constructor TQueryTreeList.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TTreeListW;
  FAfterSmartRefresh := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterScroll, DoAfterScroll, FEventList);
end;

destructor TQueryTreeList.Destroy;
begin
  FreeAndNil(FAfterSmartRefresh);

  inherited;
end;

function TQueryTreeList.CreateDSWrap: TDSWrap;
begin
  Result := TTreeListW.Create(FDQuery);
end;

procedure TQueryTreeList.DoAfterScroll(Sender: TObject);
begin
  if not FAutoSearchDuplicate then
  begin
    if FNeedRestoreAutoSearch then
    begin
      FNeedRestoreAutoSearch := False;
      FAutoSearchDuplicate := FOldAutoSearchDuplicate;
    end;

    Exit;
  end;

  qDuplicateCategory.Search(PK.AsInteger);
end;

function TQueryTreeList.GetqDuplicateCategory: TQueryDuplicateCategory;
begin
  if FqDuplicateCategory = nil then
    FqDuplicateCategory := TQueryDuplicateCategory.Create(Self);

  Result := FqDuplicateCategory;
end;

procedure TQueryTreeList.GotoDuplicate;
begin
  FOldAutoSearchDuplicate := AutoSearchDuplicate;
  FNeedRestoreAutoSearch := True;
  AutoSearchDuplicate := False;
  LocateByPK(qDuplicateCategory.W.ID.F.AsInteger);
end;

procedure TQueryTreeList.SetAutoSearchDuplicate(const Value: Boolean);
begin
  if FAutoSearchDuplicate = Value then
    Exit;

  FAutoSearchDuplicate := Value;

  if FAutoSearchDuplicate then
    qDuplicateCategory.Search(PK.AsInteger);
end;

procedure TQueryTreeList.SmartRefresh;
var
  rc: Integer;
begin
  rc := FDQuery.RecordCount;
  inherited;

  // Если была одна запись а стало больше
  if (rc = 1) and (FDQuery.RecordCount > 1) then
    FAfterSmartRefresh.CallEventHandlers(Self);
end;

constructor TTreeListW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FExternalID := TFieldWrap.Create(Self, 'ExternalID');
  FParentId := TFieldWrap.Create(Self, 'ParentId');
  FValue := TFieldWrap.Create(Self, 'Value');
end;

procedure TTreeListW.AddChildCategory(const AValue: string; ALevel: Integer);
var
  AParentID: Variant;
  AExternalID: string;
begin
  Assert(DataSet.RecordCount > 0);
  AParentID := PK.Value;

  if not CheckPossibility(AParentID, AValue) then
    Exit;

  DataSet.DisableControls;
  try
    TryPost;
    AExternalID := qSearchCategory.CalculateExternalId(AParentID, ALevel - 1);

    TryAppend;
    Value.F.AsString := AValue;
    ParentId.F.AsInteger := AParentID;
    ExternalID.F.AsString := AExternalID;
    TryPost;
  finally
    DataSet.EnableControls;
  end;
end;

// Добавляет корень дерева
procedure TTreeListW.AddRoot;
begin
  Assert(DataSet.State = dsBrowse);
  if DataSet.RecordCount = 0 then
  begin
    TryAppend;
    Value.F.AsString := sTreeRootNodeName;
    ExternalID.F.AsString := '00000';
    TryPost;
  end;
end;

function TTreeListW.CheckPossibility(const AParentID: Integer;
  const AValue: String): Boolean;
begin
  Assert(DataSet.Active);
  Result := qSearchCategory.SearchByParentAndValue(AParentID, AValue) = 0;
end;

procedure TTreeListW.Delete;
begin
  DataSet.DisableControls;
  try
    DataSet.Delete;
    DataSet.Refresh;

    // Если удалили всё, то заново добавляем корень
    if DataSet.RecordCount = 0 then
      AddRoot;
  finally
    DataSet.EnableControls;
  end;

end;

procedure TTreeListW.FilterByExternalID(AExternalID: string);
begin
  if AExternalID.Length > 0 then
  begin
    DataSet.Filter := Format('%s = ''%s*''', [ExternalID.FieldName,
      AExternalID]);
    DataSet.Filtered := True;
  end
  else
    DataSet.Filtered := False;
end;

function TTreeListW.GetIsRootFocused: Boolean;
begin
  Result := (DataSet.RecordCount > 0) and (ParentId.F.IsNull);
end;

function TTreeListW.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

function TTreeListW.LocateByExternalID(AExternalID: string; AOptions:
    TFDDataSetLocateOptions = []): Boolean;
begin
  Assert(not AExternalID.IsEmpty);
  Result := FDDataSet.LocateEx(ExternalID.FieldName, AExternalID, AOptions);
end;

procedure TTreeListW.LocateToRoot;
begin
  FDDataSet.LocateEx(ParentId.FieldName, NULL, []);
end;

end.
