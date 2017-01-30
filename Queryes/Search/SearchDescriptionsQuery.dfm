inherited QuerySearchDescriptions: TQuerySearchDescriptions
  Width = 157
  ExplicitWidth = 157
  inherited LabelSearch: TLabel
    Width = 91
    Caption = 'SearchDescriptions'
    ExplicitWidth = 91
  end
  inherited FDQuery: TFDQuery
    Active = True
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select p.*, d.ID as DescrID'
      'from descriptions2 d'
      'join products p on upper(d.ComponentName) = upper(p.Value)')
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
    Top = 48
  end
end
