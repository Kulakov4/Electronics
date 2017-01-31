inherited QuerySearchMainParameter: TQuerySearchMainParameter
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from UnionParameters'
      'where upper(TableName) = upper(:TableName)'
      'and ParentParameter is null')
    ParamData = <
      item
        Name = 'TABLENAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
