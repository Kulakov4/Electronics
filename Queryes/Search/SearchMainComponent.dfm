inherited QuerySearchMainComponent: TQuerySearchMainComponent
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*,'
      '    GROUP_CONCAT(pc.ExternalId) subGroup'
      'from Products p'
      'join ProductProductCategories ppc on ppc.ProductId = p.Id'
      'join ProductCategories pc on ppc.ProductCategoryId = pc.Id'
      
        'where p.ParentProductId is null and upper(p.Value) = upper(:vVal' +
        'ue)'
      'group by p.id')
    ParamData = <
      item
        Name = 'VVALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
