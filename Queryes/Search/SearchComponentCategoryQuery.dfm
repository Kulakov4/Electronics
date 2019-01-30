inherited QuerySearchComponentCategory: TQuerySearchComponentCategory
  inherited Label1: TLabel
    Width = 178
    Caption = 'SearchComponentCategory'
    ExplicitWidth = 178
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ppc.*'
      'from productproductcategories ppc'
      '/* productCategories'
      'join productCategories pc on ppc.ProductCategoryId = pc.id'
      'productCategories */'
      'where (0=0) and (1=1)')
  end
end
