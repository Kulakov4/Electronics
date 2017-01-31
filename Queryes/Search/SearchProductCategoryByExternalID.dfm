inherited QuerySearchProductCategoryByExternalID: TQuerySearchProductCategoryByExternalID
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
