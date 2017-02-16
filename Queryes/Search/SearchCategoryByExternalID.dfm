inherited QuerySearchCategoryByExternalID: TQuerySearchCategoryByExternalID
  inherited Label1: TLabel
    Width = 188
    Caption = 'SearchCategoryByExternalID'
    ExplicitWidth = 188
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
