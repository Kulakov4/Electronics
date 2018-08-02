inherited QueryBodyVariations: TQueryBodyVariations
  inherited Label1: TLabel
    Width = 98
    Caption = 'BodyVariations'
    ExplicitWidth = 98
  end
  inherited FDQuery: TFDQuery
    Active = True
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from BodyVariations2')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODYVARIATIONS2'
      '(IDBODYDATA, OUTLINEDRAWING, LANDPATTERN, VARIATION, '
      '  IMAGE)'
      
        'VALUES (:NEW_IDBODYDATA, :NEW_OUTLINEDRAWING, :NEW_LANDPATTERN, ' +
        ':NEW_VARIATION, '
      '  :NEW_IMAGE);'
      ''
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
      'SELECT ID, IDBODYDATA, OUTLINEDRAWING, LANDPATTERN, '
      '  VARIATION, IMAGE'
      'FROM BODYVARIATIONS2'
      'WHERE ID = :ID')
    Left = 72
    Top = 25
  end
end
