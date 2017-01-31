inherited QueryCustomComponents: TQueryCustomComponents
  Width = 266
  Height = 84
  ExplicitWidth = 266
  ExplicitHeight = 84
  inherited Label1: TLabel
    Width = 128
    Caption = 'CustomComponents'
    ExplicitWidth = 128
  end
  inline qProducts: TfrmApplyQuery [1]
    Left = 132
    Top = 19
    Width = 117
    Height = 54
    TabOrder = 0
    ExplicitLeft = 132
    ExplicitTop = 19
    ExplicitWidth = 117
    ExplicitHeight = 54
    inherited FDQuery: TFDQuery
      SQL.Strings = (
        'select *'
        'from Products'
        'where ID = :ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = 0
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
      InsertSQL.Strings = (
        'INSERT INTO PRODUCTS(VALUE, DESCRIPTIONID, PARENTPRODUCTID)'
        'VALUES (:NEW_VALUE, :NEW_DESCRIPTIONID, :NEW_PARENTPRODUCTID );'
        ''
        'SELECT ID, VALUE, DESCRIPTIONID, PARENTPRODUCTID '
        'FROM PRODUCTS'
        'WHERE ID = LAST_INSERT_ROWID();')
      ModifySQL.Strings = (
        'UPDATE PRODUCTS'
        'SET '
        '  VALUE = :NEW_VALUE,  '
        '  DESCRIPTIONID = :NEW_DESCRIPTIONID, '
        '  PARENTPRODUCTID = :NEW_PARENTPRODUCTID'
        'WHERE ID = :OLD_ID;'
        ''
        'SELECT ID, VALUE, DESCRIPTIONID, PARENTPRODUCTID'
        'FROM PRODUCTS'
        'WHERE ID = :NEW_ID')
      DeleteSQL.Strings = (
        'DELETE FROM PRODUCTS'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, VALUE, DESCRIPTIONID, PARENTPRODUCTID'
        'FROM PRODUCTS'
        'WHERE ID = :ID')
    end
  end
  inherited FDQuery: TFDQuery [2]
  end
end
