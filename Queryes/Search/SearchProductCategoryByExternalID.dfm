inherited QuerySearchProductCategoryByExternalID: TQuerySearchProductCategoryByExternalID
  inherited LabelSearch: TLabel
    Width = 115
    Caption = 'SearchProductCategory'
    ExplicitWidth = 115
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from productcategories pc'
      'where pc.ExternalId = :vExternalId')
    ParamData = <
      item
        Name = 'VEXTERNALID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
