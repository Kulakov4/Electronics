inherited QueryBodyTypes2: TQueryBodyTypes2
  Width = 293
  Height = 151
  ExplicitWidth = 293
  ExplicitHeight = 151
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
        'INSERT INTO BODYVARIATIONS'
        '(IDBODYTYPE, OUTLINEDRAWING, LANDPATTERN, VARIATION, '
        '  IMAGE)'
        
          'VALUES (:NEW_IDBODYTYPE, :NEW_OUTLINEDRAWING, :NEW_LANDPATTERN, ' +
          ':NEW_VARIATION, '
        '  :NEW_IMAGE);'
        ''
        'SELECT ID, IDBODYTYPE, OUTLINEDRAWING, LANDPATTERN, '
        '  VARIATION, IMAGE'
        'FROM BODYVARIATIONS'
        'WHERE ID = LAST_INSERT_AUTOGEN()')
      ModifySQL.Strings = (
        'UPDATE BODYVARIATIONS'
        
          'SET IDBODYTYPE = :NEW_IDBODYTYPE, OUTLINEDRAWING = :NEW_OUTLINED' +
          'RAWING, '
        '  LANDPATTERN = :NEW_LANDPATTERN, VARIATION = :NEW_VARIATION, '
        '  IMAGE = :NEW_IMAGE'
        'WHERE ID = :OLD_ID;'
        
          'SELECT ID, IDBODYTYPE, OUTLINEDRAWING, LANDPATTERN, VARIATION, I' +
          'MAGE'
        'FROM BODYVARIATIONS'
        'WHERE ID = :NEW_ID')
      DeleteSQL.Strings = (
        'DELETE FROM BODYVARIATIONS'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, IDBODYTYPE, OUTLINEDRAWING, LANDPATTERN, '
        '  VARIATION, IMAGE'
        'FROM BODYVARIATIONS'
        'WHERE ID = :ID')
    end
  end
  inline qBodyTypes: TfrmApplyQuery [2]
    Left = 146
    Top = 15
    Width = 127
    Height = 59
    TabOrder = 1
    ExplicitLeft = 146
    ExplicitTop = 15
    ExplicitWidth = 127
    inherited FDQuery: TFDQuery
      SQL.Strings = (
        'select *'
        'from BodyTypes'
        'where id = :id')
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
        'INSERT INTO BODYTYPES'
        '(BODYTYPE, IDPARENTBODYTYPE, LEVEL)'
        'VALUES (:NEW_BODYTYPE, :NEW_IDPARENTBODYTYPE, :NEW_LEVEL);'
        ''
        'SELECT ID, BODYTYPE, IDPARENTBODYTYPE, LEVEL'
        'FROM BODYTYPES'
        'WHERE ID = LAST_INSERT_AUTOGEN()')
      ModifySQL.Strings = (
        'UPDATE BODYTYPES'
        
          'SET BODYTYPE = :NEW_BODYTYPE, IDPARENTBODYTYPE = :NEW_IDPARENTBO' +
          'DYTYPE, '
        '  LEVEL = :NEW_LEVEL'
        'WHERE ID = :OLD_ID;'
        'SELECT ID, BODYTYPE, IDPARENTBODYTYPE, LEVEL'
        'FROM BODYTYPES'
        'WHERE ID = :NEW_ID')
      DeleteSQL.Strings = (
        'DELETE FROM BODYTYPES'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, BODYTYPE, IDPARENTBODYTYPE, LEVEL'
        'FROM BODYTYPES'
        'WHERE ID = :ID')
    end
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDParentBodyType1'
      end>
    IndexName = 'idxOrder'
    OnUpdateRecord = FDQueryUpdateRecord
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select '
      
        '    bv.ID + 0 ID, bv.IDBodyType, bv.OutlineDrawing, bv.LandPatte' +
        'rn, bv.Variation, bv.Image,'
      
        '    bt1.ID + 0 ID1, bt1.BodyType BodyType1, bt1.IDParentBodyType' +
        ' IDParentBodyType1,'
      
        '    bt2.ID + 0 ID2, bt2.BodyType BodyType2, bt2.IDParentBodyType' +
        ' IDParentBodyType2'
      'from BodyTypes bt1'
      'join BodyTypes bt2 on bt2.IDParentBodyType = bt1.ID'
      'left join BodyVariations bv on bv.IDBodyType = bt2.ID'
      'where bt1.Level = 1'
      'order by IDParentBodyType1')
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
    Left = 208
    Top = 88
  end
end
