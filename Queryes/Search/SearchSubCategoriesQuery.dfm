inherited QuerySearchSubCategories: TQuerySearchSubCategories
  inherited LabelSearch: TLabel
    Width = 103
    Caption = 'SearchSubCategories'
    ExplicitWidth = 103
  end
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
