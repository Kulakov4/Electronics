inherited QueryProductParameters: TQueryProductParameters
  inherited Label1: TLabel
    Top = 11
    Width = 127
    Caption = 'ProductParameters'
    ExplicitTop = 11
    ExplicitWidth = 127
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select pv.Id, pv.ParamSubParamID, pv.Value, pv.ProductId, p.Pare' +
        'ntProductId'
      'from'
      'ParameterValues2 pv'
      'join Products p on pv.ProductId = p.Id'
      'where '
      'pv.ProductId in'
      '('
      '    select distinct p.Id'
      '    from ProductProductCategories ppc'
      '    join products f on ppc.ProductId = f.id'
      '    join products p on p.ParentProductId = f.Id'
      '    where ppc.ProductCategoryId = :ProductCategoryId'
      '    union'
      '    select distinct ProductId'
      '    from ProductProductCategories ppc'
      '    where ppc.ProductCategoryId = :ProductCategoryId'
      ')'
      'order by pv.ProductID, pv.ParamSubParamID, pv.ID')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
