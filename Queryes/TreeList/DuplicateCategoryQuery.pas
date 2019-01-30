unit DuplicateCategoryQuery;

interface

uses
  FireDAC.Comp.Client, System.Classes, Data.DB, SearchCategoryQuery,
  NotifyEvents, DSWrap;

type
  TDuplicateCategoryW = class(TDSWrap)
  private
    FCaption: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Caption: TFieldWrap read FCaption;
    property ID: TFieldWrap read FID;
  end;

  TQueryDuplicateCategory = class(TFDMemTable)
  private
    FOnDuplicateClick: TNotifyEventsEx;
    FAfterSearch: TNotifyEventsEx;
    FqSearchCategory: TQuerySearchCategory;
    FW: TDuplicateCategoryW;
    function GetqSearchCategory: TQuerySearchCategory;
  protected
    procedure LoadData(AQuerySearchCategory: TQuerySearchCategory);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Search(const AID: Integer);
    property OnDuplicateClick: TNotifyEventsEx read FOnDuplicateClick;
    property AfterSearch: TNotifyEventsEx read FAfterSearch;
    property W: TDuplicateCategoryW read FW;
  end;

implementation

uses
  System.SysUtils;

constructor TQueryDuplicateCategory.Create(AOwner: TComponent);
begin
  inherited;
  FW := TDuplicateCategoryW.Create(Self);
  FieldDefs.Add(W.ID.FieldName, ftInteger, 0, True);
  FieldDefs.Add(W.Caption.FieldName, ftWideString, 50, True);

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
    W.ID.F.Value := AQuerySearchCategory.PK.Value;
    W.Caption.F.AsString := Format('%d совпадение', [i]);
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
  Locate(W.ID.FieldName, AID);

  FAfterSearch.CallEventHandlers(Self);
end;

constructor TDuplicateCategoryW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FCaption := TFieldWrap.Create(Self, 'Caption');
end;

end.
