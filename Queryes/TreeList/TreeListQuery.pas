unit TreeListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit,
  SearchCategoryQuery, NotifyEvents, DuplicateCategoryQuery;

type
  TQueryTreeList = class(TQueryWithDataSource)
  private
    FAfterSmartRefresh: TNotifyEventsEx;
    FAutoSearchDuplicate: Boolean;
    FNeedRestoreAutoSearch: Boolean;
    FOldAutoSearchDuplicate: Boolean;
    FqDuplicateCategory: TQueryDuplicateCategory;
    FqSearchCategory: TQuerySearchCategory;
    function GetExternalID: TField;
    function GetIsRootFocused: Boolean;
    function GetParentID: TField;
    function GetqDuplicateCategory: TQueryDuplicateCategory;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetValue: TField;
    procedure SetAutoSearchDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    procedure DoAfterScroll(Sender: TObject);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddChildCategory(const AValue: string; ALevel: Integer);
    procedure AddRoot;
    function CheckPossibility(const AParentID: Integer;
      const AValue: String): Boolean;
    procedure Delete;
    procedure FilterByExternalID(AExternalID: string);
    function LocateByExternalID(AExternalID: string; AOptions: TFDDataSetLocateOptions = []): Boolean;
    procedure LocateToRoot;
    procedure GotoDuplicate;
    procedure SmartRefresh; override;
    property ExternalID: TField read GetExternalID;
    property IsRootFocused: Boolean read GetIsRootFocused;
    property AfterSmartRefresh: TNotifyEventsEx read FAfterSmartRefresh;
    property AutoSearchDuplicate: Boolean read FAutoSearchDuplicate write
        SetAutoSearchDuplicate;
    property ParentId: TField read GetParentID;
    property qDuplicateCategory: TQueryDuplicateCategory
      read GetqDuplicateCategory;
    property value: TField read GetValue;
    { Public declarations }
  end;

implementation

uses System.Generics.Collections, ProjectConst;

{$R *.dfm}

constructor TQueryTreeList.Create(AOwner: TComponent);
begin
  inherited;
  FAfterSmartRefresh := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterScroll, DoAfterScroll, FEventList);
end;

procedure TQueryTreeList.AddChildCategory(const AValue: string;
  ALevel: Integer);
var
  AParentID: Variant;
  AExternalID: string;
begin
  Assert(FDQuery.RecordCount > 0);
  AParentID := PK.value;

  if not CheckPossibility(AParentID, AValue) then
    Exit;

  FDQuery.DisableControls;
  try
    TryPost;
    // AExternalID := CalculateExternalId(AParentID, ALevel);
    AExternalID := qSearchCategory.CalculateExternalId(AParentID, ALevel - 1);

    TryAppend;
    value.AsString := AValue;
    ParentId.AsInteger := AParentID;
    ExternalID.AsString := AExternalID;
    TryPost;
  finally
    FDQuery.EnableControls;
  end;
end;

// Добавляет корень дерева
procedure TQueryTreeList.AddRoot;
begin
  Assert(FDQuery.State = dsBrowse);
  if FDQuery.RecordCount = 0 then
  begin
    TryAppend;
    value.AsString := sTreeRootNodeName;
    ExternalID.AsString := '00000';
    TryPost;
  end;
end;

function TQueryTreeList.CheckPossibility(const AParentID: Integer;
  const AValue: String): Boolean;
begin
  Assert(FDQuery.Active);
  Result := qSearchCategory.SearchByParentAndValue(AParentID, AValue) = 0;
end;

procedure TQueryTreeList.Delete;
begin
  FDQuery.DisableControls;
  try
    FDQuery.Delete;
    FDQuery.Refresh;

    // Если удалили всё, то заново добавляем корень
    if FDQuery.RecordCount = 0 then
      AddRoot;
  finally
    FDQuery.EnableControls;
  end;

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

procedure TQueryTreeList.FilterByExternalID(AExternalID: string);
begin
  if AExternalID.Length > 0 then
  begin
    FDQuery.Filter := Format('ExternalID = ''%s*''', [AExternalID]);
    FDQuery.Filtered := True;
  end
  else
    FDQuery.Filtered := False;
end;

function TQueryTreeList.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryTreeList.GetIsRootFocused: Boolean;
begin
  Result := (FDQuery.RecordCount > 0) and (ParentId.IsNull);
end;

function TQueryTreeList.GetParentID: TField;
begin
  Result := Field('ParentID');
end;

function TQueryTreeList.GetqDuplicateCategory: TQueryDuplicateCategory;
begin
  if FqDuplicateCategory = nil then
    FqDuplicateCategory := TQueryDuplicateCategory.Create(Self);

  Result := FqDuplicateCategory;
end;

function TQueryTreeList.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

function TQueryTreeList.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryTreeList.LocateByExternalID(AExternalID: string; AOptions: TFDDataSetLocateOptions = []): Boolean;
begin
  Assert(not AExternalID.IsEmpty);
  Result := FDQuery.LocateEx(ExternalID.FieldName, AExternalID, AOptions);
end;

procedure TQueryTreeList.LocateToRoot;
begin
  FDQuery.LocateEx(ParentId.FieldName, NULL, []);
end;

procedure TQueryTreeList.GotoDuplicate;
begin
  FOldAutoSearchDuplicate := AutoSearchDuplicate;
  FNeedRestoreAutoSearch := True;
  AutoSearchDuplicate := False;
  LocateByPK(qDuplicateCategory.ID.AsInteger);
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

end.
