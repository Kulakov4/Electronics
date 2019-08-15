inherited QrySearchFamilyCategories: TQrySearchFamilyCategories
  inherited Label1: TLabel
    Width = 154
    Caption = 'SearchFamilyCategories'
    ExplicitWidth = 154
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select p.*, ppc.*, pp.Value Category, pp.ExternalId'
      'from Products p'
      'join ProductProductCategories ppc on ppc.ProductId = p.Id'
      'join ProductCategories pp on ppc.ProductCategoryId = pp.id'
      'where (0=0) and (1=1)')
  end
end
