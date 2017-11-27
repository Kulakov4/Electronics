inherited QueryUniqueParameterValues: TQueryUniqueParameterValues
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParameterValues'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct Value'
      'from ParameterValues pv'
      
        'join ProductProductCategories ppc on ppc.ProductId = pv.ProductI' +
        'd and ppc.ProductCategoryId = :ProductCategoryId'
      'where ParameterId = :ParameterID')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
