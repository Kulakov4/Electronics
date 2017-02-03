inherited QueryMainParameters: TQueryMainParameters
  Width = 284
  Height = 84
  ExplicitWidth = 284
  ExplicitHeight = 84
  inherited Label1: TLabel
    Width = 106
    Caption = 'MainParameters'
    ExplicitWidth = 106
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDParameterType;Order'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode, uvUpdateNonBaseFields]
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select up.* '
      'from UnionParameters up'
      'where up.ParentParameter is null and up.IsCustomParameter = 0'
      'and ( ( TableName = :TableName ) or ( :TableName = '#39#39' ) )'
      'order by up.IDParameterType, up.`Order`')
    ParamData = <
      item
        Name = 'TABLENAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end>
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO UNIONPARAMETERS'
      '(VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
      '  TABLENAME, DEFINITION, "ORDER", FIELDTYPE, '
      '  PARENTPARAMETER, ISCUSTOMPARAMETER, IDPARAMETERTYPE)'
      
        'VALUES (:NEW_VALUE, :NEW_VALUET, :NEW_CODELETTERS, :NEW_MEASURIN' +
        'GUNIT, '
      '  :NEW_TABLENAME, :NEW_DEFINITION, :NEW_ORDER, :NEW_FIELDTYPE, '
      
        '  :NEW_PARENTPARAMETER, :NEW_ISCUSTOMPARAMETER, :NEW_IDPARAMETER' +
        'TYPE);'
      ''
      'SELECT LAST_INSERT_ROWID() AS ID, "ORDER" AS "ORDER"'
      'FROM UNIONPARAMETERS'
      'WHERE ID = LAST_INSERT_ROWID();')
    ModifySQL.Strings = (
      'UPDATE UNIONPARAMETERS'
      
        'SET VALUE = :NEW_VALUE, VALUET = :NEW_VALUET, CODELETTERS = :NEW' +
        '_CODELETTERS, '
      
        '  MEASURINGUNIT = :NEW_MEASURINGUNIT, TABLENAME = :NEW_TABLENAME' +
        ', '
      
        '  DEFINITION = :NEW_DEFINITION, "ORDER" = :NEW_ORDER, FIELDTYPE ' +
        '= :NEW_FIELDTYPE, '
      
        '  PARENTPARAMETER = :NEW_PARENTPARAMETER, ISCUSTOMPARAMETER = :N' +
        'EW_ISCUSTOMPARAMETER, '
      '  IDPARAMETERTYPE = :NEW_IDPARAMETERTYPE'
      'WHERE ID = :OLD_ID;'
      'SELECT ID, "ORDER" AS "ORDER"'
      'FROM UNIONPARAMETERS'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM UNIONPARAMETERS'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      
        'SELECT LAST_INSERT_ROWID() AS ID, VALUE, VALUET, CODELETTERS, ME' +
        'ASURINGUNIT, '
      
        '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
        'RAMETER, '
      '  ISCUSTOMPARAMETER, IDPARAMETERTYPE'
      'FROM UNIONPARAMETERS'
      'WHERE ID = :ID')
    Left = 152
    Top = 24
  end
  object FDQuery2: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'select *'
      'from UnionParameters'
      'where ParentParameter is null and IsCustomParameter = 0'
      'and tablename in'
      '('
      '    select TableName'
      '    from UnionParameters'
      '    where ParentParameter is null and IsCustomParameter = 0'
      '    group by TableName'
      '    having count(*) > 1'
      ')'
      'and ( ( TableName = :TableName ) or ( :TableName = '#39#39' ) )'
      'order by IDParameterType, `Order`')
    Left = 224
    Top = 24
    ParamData = <
      item
        Name = 'TABLENAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end>
  end
end
