inherited QueryStoreHouseList: TQueryStoreHouseList
  Width = 208
  Height = 86
  ExplicitWidth = 208
  ExplicitHeight = 86
  inherited Label1: TLabel
    Width = 99
    Caption = 'StoreHouseList'
    ExplicitWidth = 99
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select * from Storehouse order by Title')
  end
  object FDUpdateSQL: TFDUpdateSQL
    Connection = DMRepository.dbConnection
    InsertSQL.Strings = (
      'INSERT INTO STOREHOUSE'
      '(TITLE, RESPONSIBLE, ADDRESS)'
      'VALUES (:NEW_TITLE, :NEW_RESPONSIBLE, :NEW_ADDRESS);'
      ''
      'SELECT LAST_INSERT_AUTOGEN() AS ID, TITLE, RESPONSIBLE, ADDRESS'
      'FROM STOREHOUSE'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE STOREHOUSE'
      
        'SET TITLE = :NEW_TITLE, RESPONSIBLE = :NEW_RESPONSIBLE, ADDRESS ' +
        '= :NEW_ADDRESS'
      'WHERE ID = :OLD_ID;'
      'SELECT ID, TITLE, RESPONSIBLE, ADDRESS'
      'FROM STOREHOUSE'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM STOREHOUSE'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      
        'SELECT LAST_INSERT_AUTOGEN() AS ID, EXTERNALID, TITLE, RESPONSIB' +
        'LE, '
      '  ADDRESS'
      'FROM STOREHOUSE'
      'WHERE ID = :ID')
    Left = 152
    Top = 24
  end
end
