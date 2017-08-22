inherited QuerySearchDescriptions: TQuerySearchDescriptions
  Width = 219
  ExplicitWidth = 219
  inherited Label1: TLabel
    Width = 125
    Caption = 'SearchDescriptions'
    ExplicitWidth = 125
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
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
    Left = 72
    Top = 25
  end
  object fdqBase: TFDQuery
    SQL.Strings = (
      'select p.*, d.ID as DescrID'
      'from descriptions2 d'
      
        'join products p on d.ComponentName = p.Value and p.ParentProduct' +
        'Id is null'
      '/* ProductCategory'
      
        'join productproductcategories ppc on ppc.ProductId = p.Id and pp' +
        'c.ProductCategoryId = :ProductCategoryId'
      'ProductCategory */')
    Left = 144
    Top = 25
  end
end
