inherited QuerySearchMainParameter: TQuerySearchMainParameter
  inherited LabelSearch: TLabel
    Width = 105
    Caption = 'SearchMainParameter'
    ExplicitWidth = 105
  end
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
