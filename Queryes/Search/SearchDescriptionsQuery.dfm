inherited QuerySearchDescriptions: TQuerySearchDescriptions
  Width = 157
  ExplicitWidth = 157
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select p.*, d.ID as DescrID'
      'from descriptions2 d'
      
        'join products p on d.ComponentName = p.Value and p.ParentProduct' +
        'Id is null'
      
        '--join productproductcategories ppc on ppc.ProductId = p.Id and ' +
        'ppc.ProductCategoryId = :ProductCategoryId')
  end
  object FDUpdateSQL: TFDUpdateSQL
    ModifySQL.Strings = (
      'UPDATE PRODUCTS'
      'SET DESCRIPTIONID = :NEW_DESCRIPTIONID'
      'WHERE ID = :OLD_ID;'
      ''
      'SELECT ID, VALUE, DESCRIPTIONID, PARENTPRODUCTID'
      'FROM PRODUCTS'
      'WHERE ID = :NEW_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, VALUE, DESCRIPTIONID, PARENTPRODUCTID'
      'FROM PRODUCTS'
      'WHERE ID = :ID')
    Left = 96
    Top = 24
  end
end
