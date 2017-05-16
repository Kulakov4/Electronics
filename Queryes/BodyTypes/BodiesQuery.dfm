inherited QueryBodies: TQueryBodies
  inherited Label1: TLabel
    Width = 42
    Caption = 'Bodies'
    ExplicitWidth = 42
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from Bodies')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODIES'
      '(BODY, IDBODYKIND)'
      'VALUES (:NEW_BODY, :NEW_IDBODYKIND);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE BODIES'
      'SET BODY = :NEW_BODY, IDBODYKIND = :NEW_IDBODYKIND'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM BODIES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, BODY, IDBODYKIND'
      'FROM BODIES'
      'WHERE ID = :ID')
    Left = 72
    Top = 25
  end
end
