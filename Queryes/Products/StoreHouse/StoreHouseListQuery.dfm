inherited QueryStoreHouseList: TQueryStoreHouseList
  inherited Label1: TLabel
    Width = 99
    Caption = 'StoreHouseList'
    ExplicitWidth = 99
  end
  inherited FDQuery: TFDQuery
    OnDeleteError = FDQueryDeleteError
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select * from Storehouse order by Title')
  end
  object FDUpdateSQL: TFDUpdateSQL
    Connection = DMRepository.dbConnection
    InsertSQL.Strings = (
      'INSERT INTO STOREHOUSE'
      '(EXTERNALID, TITLE, RESPONSIBLE, ADDRESS, '
      '  ABBREVIATION)'
      
        'VALUES (:NEW_EXTERNALID, :NEW_TITLE, :NEW_RESPONSIBLE, :NEW_ADDR' +
        'ESS, '
      '  :NEW_ABBREVIATION);'
      ''
      'SELECT ID, EXTERNALID, TITLE, RESPONSIBLE, ADDRESS, ABBREVIATION'
      'FROM STOREHOUSE'
      'WHERE ID = LAST_INSERT_ROWID();')
    ModifySQL.Strings = (
      'UPDATE STOREHOUSE'
      
        'SET EXTERNALID = :NEW_EXTERNALID, TITLE = :NEW_TITLE, RESPONSIBL' +
        'E = :NEW_RESPONSIBLE, '
      '  ADDRESS = :NEW_ADDRESS, ABBREVIATION = :NEW_ABBREVIATION'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM STOREHOUSE'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, EXTERNALID, TITLE, RESPONSIBLE, ADDRESS, ABBREVIATION'
      'FROM STOREHOUSE'
      'WHERE ID = :ID')
    Left = 67
    Top = 25
  end
end
