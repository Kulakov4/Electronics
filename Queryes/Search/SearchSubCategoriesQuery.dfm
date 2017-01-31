inherited QuerySearchSubCategories: TQuerySearchSubCategories
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from productcategories'
      'where parentid = :ParentID')
    ParamData = <
      item
        Name = 'PARENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
