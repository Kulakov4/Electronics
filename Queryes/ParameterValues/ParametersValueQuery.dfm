inherited QueryParametersValue: TQueryParametersValue
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParametersValue'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ParameterValues pv'
      'where pv.ProductId = :ProductId'
      'and pv.ParameterId = :ParameterId')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
