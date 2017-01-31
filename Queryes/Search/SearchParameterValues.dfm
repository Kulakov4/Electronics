inherited QuerySearchParameterValues: TQuerySearchParameterValues
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct Value'
      'from ProductUnionParameters pup '
      'where pup.UnionParameterId = :ParameterId'
      'order by Value')
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
end
