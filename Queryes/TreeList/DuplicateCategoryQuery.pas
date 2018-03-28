unit DuplicateCategoryQuery;

interface

uses
  FireDAC.Comp.Client, System.Classes, Data.DB, SearchCategoryQuery;

type
  TQueryDuplicateCategory = class(TFDMemTable)
  private
    function GetCaption: TField;
    function GetID: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadData(AQuerySearchCategory: TQuerySearchCategory);
    property Caption: TField read GetCaption;
    property ID: TField read GetID;
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
end;

function TQueryDuplicateCategory.GetCaption: TField;
begin
  Result := FieldByName('Caption');
end;

function TQueryDuplicateCategory.GetID: TField;
begin
  Result := FieldByName('ID');
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

end.
