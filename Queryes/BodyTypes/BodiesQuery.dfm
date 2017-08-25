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
      
        '  ifnull(b.Body0, '#39#39') || ifnull(b.Body1, '#39#39') || ifnull(b.Body2, ' +
        #39#39') || ifnull(b.Body3, '#39#39') || ifnull(b.Body4, '#39#39') || ifnull(b.Bo' +
        'dy5, '#39#39') Body,'
      '  b.Body0,'
      '  b.Body1,'
      '  b.Body2,'
      '  b.Body3,'
      '  b.Body4,'
      '  b.Body5,        '
      '  IDBodyKind'
      'from Bodies b')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODIES'
      '(BODY0, BODY1, BODY2, BODY3, BODY4, '
      '  BODY5, IDBODYKIND)'
      
        'VALUES (:NEW_BODY0, :NEW_BODY1, :NEW_BODY2, :NEW_BODY3, :NEW_BOD' +
        'Y4, '
      '  :NEW_BODY5, :NEW_IDBODYKIND);'
      'SELECT ID, '
      
        '  Body0 || ifnull(Body1, '#39#39') || ifnull(Body2, '#39#39') || ifnull(Body' +
        '3, '#39#39') || ifnull(Body4, '#39#39') || ifnull(Body5, '#39#39') Body, '
      '  BODY0, BODY1, BODY2, BODY3, BODY4, BODY5, IDBODYKIND'
      'FROM BODIES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE BODIES'
      'SET BODY0 = :NEW_BODY0, BODY1 = :NEW_BODY1, BODY2 = :NEW_BODY2, '
      '  BODY3 = :NEW_BODY3, BODY4 = :NEW_BODY4, BODY5 = :NEW_BODY5, '
      '  IDBODYKIND = :NEW_IDBODYKIND'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM BODIES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, '
      
        '  Body0 || ifnull(Body1, '#39#39') || ifnull(Body2, '#39#39') || ifnull(Body' +
        '3, '#39#39') || ifnull(Body4, '#39#39') || ifnull(Body5, '#39#39') Body, '
      '  BODY0, BODY1, BODY2, BODY3, BODY4, BODY5, IDBODYKIND'
      'FROM BODIES'
      'WHERE ID = :ID')
    Left = 72
    Top = 25
  end
end
