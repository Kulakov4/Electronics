inherited QueryBodyData: TQueryBodyData
  inherited Label1: TLabel
    Width = 63
    Caption = 'BodyData'
    ExplicitWidth = 63
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from BodyData')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODYDATA'
      '(IDPRODUCER, IDBODY, BODYDATA)'
      'VALUES (:NEW_IDPRODUCER, :NEW_IDBODY, :NEW_BODYDATA);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE BODYDATA'
      
        'SET IDPRODUCER = :NEW_IDPRODUCER, IDBODY = :NEW_IDBODY, BODYDATA' +
        ' = :NEW_BODYDATA'
      'WHERE ID = :OLD_ID;')
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
