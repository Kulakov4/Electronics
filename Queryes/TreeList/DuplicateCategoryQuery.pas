unit DuplicateCategoryQuery;

interface

uses
  FireDAC.Comp.Client, System.Classes, Data.DB, SearchCategoryQuery,
  NotifyEvents;

type
  TQueryDuplicateCategory = class(TFDMemTable)
  private
    FOnDuplicateClick: TNotifyEventsEx;
    FAfterSearch: TNotifyEventsEx;
    FqSearchCategory: TQuerySearchCategory;
    function GetCaption: TField;
    function GetID: TField;
    function GetqSearchCategory: TQuerySearchCategory;
  protected
    procedure LoadData(AQuerySearchCategory: TQuerySearchCategory);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Search(const AID: Integer);
    property Caption: TField read GetCaption;
    property ID: TField read GetID;
    property OnDuplicateClick: TNotifyEventsEx read FOnDuplicateClick;
    property AfterSearch: TNotifyEventsEx read FAfterSearch;
  end;

implementation

uses
  System.SysUtils;

constructor TQueryDuplicateCategory.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger, 0, True);
  FieldDefs.Add('Caption', ftWideString, 50, True);

  CreateDataSet;

  FOnDuplicateClick := TNotifyEventsEx.Create(Self);
  FAfterSearch := TNotifyEventsEx.Create(Self);
end;

destructor TQueryDuplicateCategory.Destroy;
begin
  FreeAndNil(FAfterSearch);
  FreeAndNil(FOnDuplicateClick);
  inherited;
end;

function TQueryDuplicateCategory.GetCaption: TField;
begin
  Result := FieldByName('Caption');
end;

function TQueryDuplicateCategory.GetID: TField;
begin
  Result := FieldByName('ID');
end;

function TQueryDuplicateCategory.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

procedure TQueryDuplicateCategory.LoadData(AQuerySearchCategory:
    TQuerySearchCategory);
var
  i: Integer;
begin
  Assert(AQuerySearchCategory <> nil);

  i := 0;
  EmptyDataSet;
  AQuerySearchCategory.FDQuery.First;
  while not AQuerySearchCategory.FDQuery.Eof do
  begin
    Inc(i);
    Append;
    ID.Value := AQuerySearchCategory.PK.Value;
    Caption.AsString := Format('%d совпадение', [i]);
    Post;

    AQuerySearchCategory.FDQuery.Next;
  end;

end;

procedure TQueryDuplicateCategory.Search(const AID: Integer);
var
  rc: Integer;
begin
  rc := qSearchCategory.SearchDuplicate(AID);
  Assert(rc > 0);

  LoadData(qSearchCategory);
  Locate(ID.FieldName, AID);

  FAfterSearch.CallEventHandlers(Self);
end;

end.
