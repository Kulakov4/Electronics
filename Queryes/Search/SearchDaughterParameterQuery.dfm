inherited QuerySearchDaughterParameter: TQuerySearchDaughterParameter
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from UnionParameters'
      'where upper(Value) = upper(:Value)'
      'and ParentParameter = :ParentParameter')
    ParamData = <
      item
        Name = 'VALUE'
        ParamType = ptInput
      end
      item
        Name = 'PARENTPARAMETER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
