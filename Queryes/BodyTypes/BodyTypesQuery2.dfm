inherited QueryBodyTypes2: TQueryBodyTypes2
  Width = 410
  Height = 153
  ExplicitWidth = 410
  ExplicitHeight = 153
  inherited Label1: TLabel
    Width = 78
    Caption = 'BodyTypes2'
    ExplicitWidth = 78
  end
  inline qBodyVariations: TfrmApplyQuery [1]
    Left = 16
    Top = 80
    Width = 129
    Height = 59
    TabOrder = 0
    ExplicitLeft = 16
    ExplicitTop = 80
    inherited FDQuery: TFDQuery
      Active = True
      SQL.Strings = (
        'select *'
        'from BodyVariations'
        'where ID = :ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = Null
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
      InsertSQL.Strings = (
        'INSERT INTO BODYVARIATIONS2'
        '(IDBODYDATA, OUTLINEDRAWING, LANDPATTERN, VARIATION, '
        '  IMAGE)'
        
          'VALUES (:NEW_IDBODYDATA, :NEW_OUTLINEDRAWING, :NEW_LANDPATTERN, ' +
          ':NEW_VARIATION, '
        '  :NEW_IMAGE);'
        'SELECT LAST_INSERT_AUTOGEN() AS ID')
      ModifySQL.Strings = (
        'UPDATE BODYVARIATIONS2'
        
          'SET IDBODYDATA = :NEW_IDBODYDATA, OUTLINEDRAWING = :NEW_OUTLINED' +
          'RAWING, '
        '  LANDPATTERN = :NEW_LANDPATTERN, VARIATION = :NEW_VARIATION, '
        '  IMAGE = :NEW_IMAGE'
        'WHERE ID = :OLD_ID;')
      DeleteSQL.Strings = (
        'DELETE FROM BODYVARIATIONS2'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        
          'SELECT ID, IDBODYDATA, OUTLINEDRAWING, LANDPATTERN, VARIATION, I' +
          'MAGE'
        'FROM BODYVARIATIONS2'
        'WHERE ID = :ID')
    end
  end
  inline qBodies: TfrmApplyQuery [2]
    Left = 146
    Top = 15
    Width = 127
    Height = 59
    TabOrder = 1
    ExplicitLeft = 146
    ExplicitTop = 15
    ExplicitWidth = 127
    inherited FDQuery: TFDQuery
      Active = True
      SQL.Strings = (
        'select *'
        'from Bodies'
        'where ID=:ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = Null
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
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
    end
  end
  inline qBodyData: TfrmApplyQuery
    Left = 160
    Top = 80
    Width = 129
    Height = 59
    TabOrder = 2
    ExplicitLeft = 160
    ExplicitTop = 80
    inherited FDQuery: TFDQuery
      Active = True
      SQL.Strings = (
        'select *'
        'from BodyData'
        'where ID=:ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = Null
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
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
    end
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDBodyKind'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select '
      '    GROUP_CONCAT(bv.ID, '#39', '#39') IDS,'
      '    bv.IDBodyData, '
      '    bv.OutlineDrawing,'
      '    bv.LandPattern,'
      '    GROUP_CONCAT(bv.Variation, '#39', '#39') Variations,'
      '    bv.Image,'
      '    bd.IDBody,'
      '    bd.IDProducer,'
      '    bd.BodyData,'
      '    b.Body,'
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join BodyVariations2 bv on bv.IDBodyData = bd.ID'
      'group by '
      '    IDBodyData, '
      '    OutlineDrawing,'
      '    LandPattern,'
      '    Image,'
      '    IDBody,'
      '    IDProducer,'
      '    BodyData,'
      '    Body,'
      '    IDBodyKind'
      'order by IDBodyKind, Body, BodyData')
  end
  object fdqUnusedBodyTypes: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'select bt.id'
      'from BodyTypes bt'
      'where '
      'bt.level > 0'
      'and not exists'
      '('
      'select bv.*'
      'from BodyVariations bv'
      'where bv.IDBodyType = bt.id'
      ')'
      'and not exists'
      '('
      '    select bt2.*'
      '    from BodyTypes bt2'
      '    where bt2.IDParentBodyType = bt.id'
      ')'
      'and not exists'
      '('
      '    select p.*'
      '    from Products p'
      '    where p.BodyID = bt.id'
      ')')
    Left = 336
    Top = 16
  end
end
