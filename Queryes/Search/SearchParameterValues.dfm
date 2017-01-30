inherited QuerySearchParameterValues: TQuerySearchParameterValues
  inherited LabelSearch: TLabel
    Width = 114
    Caption = 'SearchParameterValues'
    ExplicitWidth = 114
  end
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
