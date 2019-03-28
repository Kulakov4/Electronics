inherited QueryBodyData: TQueryBodyData
  inherited Label1: TLabel
    Width = 63
    Caption = 'BodyData'
    ExplicitWidth = 63
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select '
      '    ID,'
      '    IDProducer,'
      '    IDBody,'
      '    BodyData'
      'from BodyData')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODYDATA'
      '(IDPRODUCER, IDBODY, BODYDATA)'
      'VALUES (:NEW_IDPRODUCER, :NEW_IDBODY, :NEW_BODYDATA);'
      ''
      'SELECT ID, IDPRODUCER, IDBODY, BODYDATA'
      'FROM BODYDATA'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE BODYDATA'
      
        'SET IDPRODUCER = :NEW_IDPRODUCER, IDBODY = :NEW_IDBODY, BODYDATA' +
        ' = :NEW_BODYDATA'
      'WHERE ID = :OLD_ID;'
      ''
      'SELECT ID, IDPRODUCER, IDBODY, BODYDATA'
      'FROM BODYDATA'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM BODYDATA'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, IDPRODUCER, IDBODY, BODYDATA'
      'FROM BODYDATA'
      'WHERE ID = :ID')
    Left = 73
    Top = 25
  end
end
