inherited QueryBodyData: TQueryBodyData
  inherited Label1: TLabel
    Width = 63
    Caption = 'BodyData'
    ExplicitWidth = 63
  end
  inherited FDQuery: TFDQuery
    Active = True
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select '
      '    ID,'
      '    IDProducer,'
      '    IDBody,'
      
        '    ifnull(BodyData0, '#39#39') || ifnull(BodyData1, '#39#39') || ifnull(Bod' +
        'yData2, '#39#39') || '
      
        '    ifnull(BodyData3, '#39#39') || ifnull(BodyData4, '#39#39') || ifnull(Bod' +
        'yData5, '#39#39') ||'
      
        '    ifnull(BodyData6, '#39#39') || ifnull(BodyData7, '#39#39') || ifnull(Bod' +
        'yData8, '#39#39') || ifnull(BodyData9, '#39#39') BodyData,'
      '    BodyData0,'
      '    BodyData1,'
      '    BodyData2,'
      '    BodyData3,'
      '    BodyData4,'
      '    BodyData5,'
      '    BodyData6,'
      '    BodyData7,'
      '    BodyData8,'
      '    BodyData9'
      'from BodyData')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODYDATA'
      '(IDPRODUCER, IDBODY, BODYDATA0, BODYDATA1, '
      '  BODYDATA2, BODYDATA3, BODYDATA4, BODYDATA5, '
      '  BODYDATA6, BODYDATA7, BODYDATA8, BODYDATA9)'
      
        'VALUES (:NEW_IDPRODUCER, :NEW_IDBODY, :NEW_BODYDATA0, :NEW_BODYD' +
        'ATA1, '
      
        '  :NEW_BODYDATA2, :NEW_BODYDATA3, :NEW_BODYDATA4, :NEW_BODYDATA5' +
        ', '
      
        '  :NEW_BODYDATA6, :NEW_BODYDATA7, :NEW_BODYDATA8, :NEW_BODYDATA9' +
        ');'
      'SELECT ID'
      'FROM BODYDATA'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE BODYDATA'
      
        'SET IDPRODUCER = :NEW_IDPRODUCER, IDBODY = :NEW_IDBODY, BODYDATA' +
        '0 = :NEW_BODYDATA0, '
      '  BODYDATA1 = :NEW_BODYDATA1, BODYDATA2 = :NEW_BODYDATA2, '
      '  BODYDATA3 = :NEW_BODYDATA3, BODYDATA4 = :NEW_BODYDATA4, '
      '  BODYDATA5 = :NEW_BODYDATA5, BODYDATA6 = :NEW_BODYDATA6, '
      '  BODYDATA7 = :NEW_BODYDATA7, BODYDATA8 = :NEW_BODYDATA8, '
      '  BODYDATA9 = :NEW_BODYDATA9'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM BODYDATA'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'select '
      '    ID,'
      '    IDProducer,'
      '    IDBody,'
      
        '    ifnull(BodyData0, '#39#39') || ifnull(BodyData1, '#39#39') || ifnull(Bod' +
        'yData2, '#39#39') || '
      
        '    ifnull(BodyData3, '#39#39') || ifnull(BodyData4, '#39#39') || ifnull(Bod' +
        'yData5, '#39#39') ||'
      
        '    ifnull(BodyData6, '#39#39') || ifnull(BodyData7, '#39#39') || ifnull(Bod' +
        'yData8, '#39#39') || ifnull(BodyData9, '#39#39') BodyData,'
      '    BodyData0,'
      '    BodyData1,'
      '    BodyData2,'
      '    BodyData3,'
      '    BodyData4,'
      '    BodyData5,'
      '    BodyData6,'
      '    BodyData7,'
      '    BodyData8,'
      '    BodyData9'
      'from BodyData'
      'WHERE ID = :ID')
    Left = 73
    Top = 25
  end
end
