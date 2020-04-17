unit UpdateStoreHouseProductsCategoryQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQryUpdateStoreHouseProductsCategory = class(TQueryBase)
  private
    { Private declarations }
  public
    class procedure Update(AStoreHouseId, ANewCategoryId, AOldCategoryId
      : Integer); static;
    procedure UpdateStoreHouseProductsCategory(AStoreHouseId, ANewCategoryId,
      AOldCategoryId: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

class procedure TQryUpdateStoreHouseProductsCategory.Update(AStoreHouseId,
  ANewCategoryId, AOldCategoryId: Integer);
var
  Q: TQryUpdateStoreHouseProductsCategory;
begin
  Q := TQryUpdateStoreHouseProductsCategory.Create(nil);
  try
    Q.UpdateStoreHouseProductsCategory(AStoreHouseId, ANewCategoryId,
      AOldCategoryId);
  finally
    FreeAndNil(Q);
  end;
end;

procedure TQryUpdateStoreHouseProductsCategory.UpdateStoreHouseProductsCategory
  (AStoreHouseId, ANewCategoryId, AOldCategoryId: Integer);
begin
  Assert(AStoreHouseId > 0);
  Assert(ANewCategoryId > 0);
  Assert(AOldCategoryId > 0);

  FDQuery.ExecSQL('', [ANewCategoryId, AOldCategoryId, AStoreHouseId],
    [ftInteger, ftInteger, ftInteger]);
end;

end.
