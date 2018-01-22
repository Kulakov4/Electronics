inherited QueryUniqueParameterValues: TQueryUniqueParameterValues
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParameterValues'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct pv.ParameterId, pv.Value'
      'from ParameterValues pv'
      'join Products p on pv.ProductId = p.ID'
      
        'join ProductProductCategories ppc on  ifnull(p.ParentProductId, ' +
        'p.id) = ppc.ProductId and ppc.ProductCategoryId = :ProductCatego' +
        'ryId'
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
