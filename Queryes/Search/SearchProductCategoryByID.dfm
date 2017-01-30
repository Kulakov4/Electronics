inherited QuerySearchProductCategoryByID: TQuerySearchProductCategoryByID
  inherited LabelSearch: TLabel
    Width = 138
    Caption = 'SearchProductCategoryByID'
    ExplicitWidth = 138
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from productcategories pc'
      'where pc.ID = :ID')
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
