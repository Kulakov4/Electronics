unit SearchFamilyCategoriesQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchFamilyCategoriesW = class(TDSWrap)
  private
    FID: TFieldWrap;
    FParentProductID: TFieldWrap;
    FCategory: TFieldWrap;
    FExternalID: TFieldWrap;
    FProductCategoryID: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ID: TFieldWrap read FID;
    property ParentProductID: TFieldWrap read FParentProductID;
    property Category: TFieldWrap read FCategory;
    property ExternalID: TFieldWrap read FExternalID;
    property ProductCategoryID: TFieldWrap read FProductCategoryID;
    property Value: TFieldWrap read FValue;
  end;

  TQrySearchFamilyCategories = class(TQueryBase)
  private
    FW: TSearchFamilyCategoriesW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchFamily(const AFamilyName: string): Integer;
    property W: TSearchFamilyCategoriesW read FW;
    { Public declarations }
  end;


implementation

uses
  StrHelper;

constructor TSearchFamilyCategoriesW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FParentProductID := TFieldWrap.Create(Self, 'p.ParentProductID');
  FValue := TFieldWrap.Create(Self, 'p.Value');
  FProductCategoryID := TFieldWrap.Create(Self, 'ppc.ProductCategoryID');
  FCategory := TFieldWrap.Create(Self, 'Category');
  FExternalID := TFieldWrap.Create(Self, 'pp.ExternalId');
end;

constructor TQrySearchFamilyCategories.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchFamilyCategoriesW.Create(FDQuery);
end;

function TQrySearchFamilyCategories.SearchFamily(const AFamilyName : string):
    Integer;
var
  ANewSQL: string;
begin
  Assert(not AFamilyName.IsEmpty);

  // ƒелаем замену в первоначальном SQL запросе
  ANewSQL := ReplaceInSQL(SQL, Format('%s is null',
    [W.ParentProductID.FullName]), 0);

  FDQuery.SQL.Text := ReplaceInSQL(ANewSQL, Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]), 1);

  SetParamType(W.Value.FieldName, ptInput, ftWideString);

  // »щем
  Result := Search([W.Value.FieldName], [AFamilyName]);
end;

{$R *.dfm}

end.
