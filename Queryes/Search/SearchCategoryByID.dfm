inherited QuerySearchCategoryByID: TQuerySearchCategoryByID
  inherited Label1: TLabel
    Width = 135
    Caption = 'SearchCategoryByID'
    ExplicitWidth = 135
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
