inherited QueryUniqueParameterValues: TQueryUniqueParameterValues
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParameterValues'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct pv.ParamSubParamId, pv.Value'
      'from ParameterValues2 pv'
      'join Products p on pv.ProductId = p.ID'
      
        'join ProductProductCategories ppc on  ifnull(p.ParentProductId, ' +
        'p.id) = ppc.ProductId and ppc.ProductCategoryId = :ProductCatego' +
        'ryId'
      'where pv.ParamSubParamId = :ParamSubParamID')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
