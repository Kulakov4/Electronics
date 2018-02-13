inherited QuerySearchProductParameterValues: TQuerySearchProductParameterValues
  inherited Label1: TLabel
    Width = 208
    Caption = 'SearchProductParameterValues'
    ExplicitWidth = 208
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ParameterValues2'
      
        'where ParamSubParamID = :ParamSubParamID and ProductID = :Produc' +
        'tID')
    ParamData = <
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
