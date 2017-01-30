inherited QueryBodyTypesTree: TQueryBodyTypesTree
  Width = 270
  Height = 141
  ExplicitWidth = 270
  ExplicitHeight = 141
  inherited Label1: TLabel
    Width = 99
    Caption = 'BodyTypesTree'
    ExplicitWidth = 99
  end
  inline qBodyTypes: TfrmApplyQuery [1]
    Left = 123
    Top = 68
    Width = 126
    Height = 59
    TabOrder = 0
    ExplicitLeft = 123
    ExplicitTop = 68
    ExplicitWidth = 126
    inherited FDQuery: TFDQuery
      SQL.Strings = (
        'select *'
        'from BodyTypes'
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
  inline qBodyVariations: TfrmApplyQuery [2]
    Left = 135
    Top = 3
    Width = 114
    Height = 59
    TabOrder = 1
    ExplicitLeft = 135
    ExplicitTop = 3
    ExplicitWidth = 114
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
  inherited FDQuery: TFDQuery
    OnUpdateRecord = FDQueryUpdateRecord
    SQL.Strings = (
      'select *'
      'from BodyTypesView')
  end
end
