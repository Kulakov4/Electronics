inherited QuerySearchProductParameterValues: TQuerySearchProductParameterValues
  inherited LabelSearch: TLabel
    Width = 151
    Caption = 'SearchProductParameterValues'
    ExplicitWidth = 151
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ProductUnionParameters'
      'where UnionParameterId = :ParameterID and ProductID = :ProductID')
    ParamData = <
      item
        Name = 'PARAMETERID'
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
