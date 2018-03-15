inherited QueryParametersValue: TQueryParametersValue
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParametersValue'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ParameterValues2 pv'
      'where pv.ProductId = :ProductId'
      'and pv.ParamSubParamId = :ParamSubParamId')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
