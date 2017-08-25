inherited QuerySearchParameter: TQuerySearchParameter
  Width = 149
  ExplicitWidth = 149
  inherited Label1: TLabel
    Width = 114
    Caption = 'SearchParameter'
    ExplicitWidth = 114
  end
  inherited FDQuery: TFDQuery
    AfterOpen = FDQueryAfterOpen
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from Parameters'
      'where 0=0')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PARAMETERS'
      '(VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      '  TABLENAME, DEFINITION, "ORDER", FIELDTYPE, '
      '  PARENTPARAMETER, ISCUSTOMPARAMETER, IDPARAMETERTYPE)'
      
        'VALUES (:NEW_VALUE, :NEW_VALUET, :NEW_CODELETTERS, :NEW_MEASURIN' +
        'GUNIT, '
      '  :NEW_TABLENAME, :NEW_DEFINITION, :NEW_ORDER, :NEW_FIELDTYPE, '
      
        '  :NEW_PARENTPARAMETER, :NEW_ISCUSTOMPARAMETER, :NEW_IDPARAMETER' +
        'TYPE);'
      'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      
        '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
        'RAMETER, '
      '  ISCUSTOMPARAMETER, IDPARAMETERTYPE'
      'FROM PARAMETERS'
      'WHERE ID = LAST_INSERT_ROWID();')
    ModifySQL.Strings = (
      'UPDATE PARAMETERS'
      
        'SET VALUE = :NEW_VALUE, VALUET = :NEW_VALUET, CODELETTERS = :NEW' +
        '_CODELETTERS, '
      
        '  MEASURINGUNIT = :NEW_MEASURINGUNIT, TABLENAME = :NEW_TABLENAME' +
        ', '
      
        '  DEFINITION = :NEW_DEFINITION, "ORDER" = :NEW_ORDER, FIELDTYPE ' +
        '= :NEW_FIELDTYPE, '
      
        '  PARENTPARAMETER = :NEW_PARENTPARAMETER, ISCUSTOMPARAMETER = :N' +
        'EW_ISCUSTOMPARAMETER, '
      '  IDPARAMETERTYPE = :NEW_IDPARAMETERTYPE'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM PARAMETERS'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      
        '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
        'RAMETER, '
      '  ISCUSTOMPARAMETER, IDPARAMETERTYPE'
      'FROM PARAMETERS'
      'WHERE ID = :ID')
    Left = 72
    Top = 24
  end
end
