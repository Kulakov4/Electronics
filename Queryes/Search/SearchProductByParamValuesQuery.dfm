inherited qSearchProductByParamValues: TqSearchProductByParamValues
  inherited Label1: TLabel
    Width = 196
    Caption = 'SearchProductByParamValues'
    ExplicitWidth = 196
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct pv.ProductId ProductId'
      'from ParameterValues pv'
      
        'join ProductProductCategories ppc on ppc.ProductId = pv.ProductI' +
        'd and ppc.ProductCategoryId = :ProductCategoryId'
      'where '
      '  pv.ParameterID = (0)'
      '  and pv.Value in (1)')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
