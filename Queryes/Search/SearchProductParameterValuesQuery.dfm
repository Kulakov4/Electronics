inherited QuerySearchProductParameterValues: TQuerySearchProductParameterValues
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
