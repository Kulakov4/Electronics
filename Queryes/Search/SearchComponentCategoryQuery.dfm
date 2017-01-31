inherited QuerySearchComponentCategory: TQuerySearchComponentCategory
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from productproductcategories'
      'where ProductID = :ProductID'
      'and ProductCategoryID = :ProductCategoryID')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
end
