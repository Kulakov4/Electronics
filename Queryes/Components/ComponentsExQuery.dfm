inherited QueryComponentsEx: TQueryComponentsEx
  inherited Label1: TLabel
    Width = 94
    Caption = 'ComponentsEx'
    ExplicitWidth = 94
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*, '
      '    '#39#39' Producer, '
      '    pv2.ID AS IDPackagePins,'
      '    pv2.Value AS PackagePins,'
      '    '#39#39' Datasheet,'
      '    '#39#39' Diagram,'
      '    '#39#39' Drawing,'
      '    '#39#39' Image,'
      '    '#39#39' DescriptionComponentName,'
      '    '#39#39' Description,'
      '    case when pa.ProductId is null then 0 else 1 end analog'
      'from Products p'
      
        'LEFT JOIN ParameterValues pv2 ON pv2.ProductID = p.Id AND pv2.Pa' +
        'rameterId = :PackagePinsParameterID'
      'LEFT JOIN ProductsAnalog pa on pa.ProductId = p.Id'
      'where p.ParentProductId in'
      '('
      '    select p.id'
      '    from ProductProductCategories ppc'
      
        '    JOIN Products p ON ppc.ProductId = p.Id AND p.ParentProductI' +
        'd IS NULL'
      '    WHERE ppc.ProductCategoryId = :vProductCategoryId     '
      ')'
      'order by p.ParentProductId, p.Value')
  end
end
