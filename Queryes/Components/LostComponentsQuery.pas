unit LostComponentsQuery;

interface

uses
  FireDAC.Comp.Client, System.Classes;

type
  TDeleteLostComponentsQuery = class(TFDQuery)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TDeleteLostComponentsQuery.Create(AOwner: TComponent);
begin
  inherited;
  SQL.Clear;
  SQL.Add('DELETE FROM products');
  SQL.Add('WHERE id IN');
  SQL.Add('(');
  SQL.Add('  SELECT p.Id');
  SQL.Add('  FROM products p');
  SQL.Add('  WHERE ');
  SQL.Add('    p.ParentProductID is null');
  SQL.Add('    AND NOT EXISTS');
  SQL.Add('    (');
  SQL.Add('      SELECT *');
  SQL.Add('      FROM ProductProductCategories ppc');
  SQL.Add('      WHERE ppc.ProductId = p.Id');
  SQL.Add('    )');
  SQL.Add('    AND NOT EXISTS');
  SQL.Add('    (');
  SQL.Add('      SELECT *');
  SQL.Add('      FROM StoreHouseProducts sp');
  SQL.Add('      WHERE sp.ProductId = p.id');
  SQL.Add('    )');
  SQL.Add(')');
end;

end.
