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
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select p.*, psp.id ParamSubParamID '
      'from Parameters p'
      'join ParamSubParams psp on psp.IdParameter = p.Id'
      
        'join SubParameters sp on psp.IdSubParameter = sp.id and sp.IsDef' +
        'ault = 1'
      'where 0=0')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PARAMETERS'
      '(VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      '  TABLENAME, DEFINITION, "ORDER", FIELDTYPE, '
      '  ISCUSTOMPARAMETER, IDPARAMETERTYPE, IDPARAMETERKIND)'
      
        'VALUES (:NEW_VALUE, :NEW_VALUET, :NEW_CODELETTERS, :NEW_MEASURIN' +
        'GUNIT, '
      '  :NEW_TABLENAME, :NEW_DEFINITION, :NEW_ORDER, :NEW_FIELDTYPE, '
      
        '  :NEW_ISCUSTOMPARAMETER, :NEW_IDPARAMETERTYPE, :NEW_IDPARAMETER' +
        'KIND);'
      ''
      'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      
        '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, ISCUSTOM' +
        'PARAMETER, '
      '  IDPARAMETERTYPE, IDPARAMETERKIND'
      'FROM PARAMETERS'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE PARAMETERS'
      
        'SET VALUE = :NEW_VALUE, VALUET = :NEW_VALUET, CODELETTERS = :NEW' +
        '_CODELETTERS, '
      
        '  MEASURINGUNIT = :NEW_MEASURINGUNIT, TABLENAME = :NEW_TABLENAME' +
        ', '
      
        '  DEFINITION = :NEW_DEFINITION, "ORDER" = :NEW_ORDER, FIELDTYPE ' +
        '= :NEW_FIELDTYPE, '
      
        '  ISCUSTOMPARAMETER = :NEW_ISCUSTOMPARAMETER, IDPARAMETERTYPE = ' +
        ':NEW_IDPARAMETERTYPE, '
      '  IDPARAMETERKIND = :NEW_IDPARAMETERKIND'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM PARAMETERS'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT p.ID, p.VALUE, p.VALUET, p.CODELETTERS, p.MEASURINGUNIT, '
      
        '  p.TABLENAME, p.DEFINITION, p."ORDER" AS "ORDER", p.FIELDTYPE, ' +
        'p.ISCUSTOMPARAMETER, '
      '  p.IDPARAMETERTYPE, p.IDPARAMETERKIND, psp.id ParamSubParamID'
      'FROM PARAMETERS p'
      'join ParamSubParams psp on psp.IdParameter = p.Id'
      
        'join SubParameters sp on psp.IdSubParameter = sp.id and sp.IsDef' +
        'ault = 1'
      'WHERE p.ID = :ID')
    Left = 72
    Top = 24
  end
end
