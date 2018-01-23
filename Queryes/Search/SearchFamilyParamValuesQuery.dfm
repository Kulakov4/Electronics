inherited QueryFamilyParamValues: TQueryFamilyParamValues
  inherited Label1: TLabel
    Width = 123
    Caption = 'FamilyParamValues'
    ExplicitWidth = 123
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct Value'
      'from ParameterValues'
      'where ParameterID = :ParameterID'
      'and productId in'
      '('
      '    select id'
      '    from Products'
      '    where ParentProductId = :ParentProductId'
      ')'
      'and Value is not null')
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARENTPRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
