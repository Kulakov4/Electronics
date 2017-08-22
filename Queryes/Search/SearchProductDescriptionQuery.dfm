inherited QuerySearchProductDescription: TQuerySearchProductDescription
  inherited Label1: TLabel
    Width = 169
    Caption = 'SearchProductDescription'
    ExplicitWidth = 169
  end
  inherited FDQuery: TFDQuery
    Active = True
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select p.*, d.ID as DescrID'
      'from descriptions2 d'
      'join products2 p on d.ComponentName = p.Value')
  end
  object FDUpdateSQL: TFDUpdateSQL
    Connection = DMRepository.dbConnection
    InsertSQL.Strings = (
      'INSERT INTO PRODUCTS2'
      '(DESCRIPTIONID)'
      'VALUES (:NEW_DESCRIPTIONID);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE PRODUCTS2'
      'SET DESCRIPTIONID = :NEW_DESCRIPTIONID'
      'WHERE ID = :OLD_ID;'
      'SELECT ID'
      'FROM PRODUCTS2'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM PRODUCTS2'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, IDPRODUCER, VALUE, DATASHEET, DRAWING, '
      '  DIAGRAM, IMAGE, PACKAGEPINS, DESCRIPTIONID'
      'FROM PRODUCTS2'
      'WHERE ID = :ID')
    Left = 74
    Top = 25
  end
end
