inherited QueryBodies: TQueryBodies
  inherited Label1: TLabel
    Width = 42
    Caption = 'Bodies'
    ExplicitWidth = 42
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select '
      '  b.ID, '
      '  b.Body,'
      '  IDBodyKind'
      'from Bodies b')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODIES'
      '(BODY, IDBODYKIND)'
      'VALUES (:NEW_BODY, :NEW_IDBODYKIND);'
      ''
      'SELECT ID, BODY, IDBODYKIND'
      'FROM BODIES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE BODIES'
      'SET BODY = :NEW_BODY, IDBODYKIND = :NEW_IDBODYKIND'
      'WHERE ID = :OLD_ID;'
      ''
      'SELECT ID, BODY, IDBODYKIND'
      'FROM BODIES'
      'WHERE ID = :NEW_ID')
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
