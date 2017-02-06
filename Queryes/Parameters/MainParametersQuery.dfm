inherited QueryMainParameters: TQueryMainParameters
  Width = 337
  Height = 86
  ExplicitWidth = 337
  ExplicitHeight = 86
  inherited Label1: TLabel
    Width = 106
    Caption = 'MainParameters'
    ExplicitWidth = 106
  end
  inline ParametersApplyQuery: TfrmApplyQuery [1]
    Left = 192
    Top = 16
    Width = 129
    Height = 59
    TabOrder = 0
    ExplicitLeft = 192
    ExplicitTop = 16
    inherited FDQuery: TFDQuery
      Active = True
      SQL.Strings = (
        'select *'
        'from UnionParameters'
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
        'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
        
          '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
          'RAMETER, '
        '  ISCUSTOMPARAMETER, IDPARAMETERTYPE'
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
        '')
      DeleteSQL.Strings = (
        'DELETE FROM UNIONPARAMETERS'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
        
          '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
          'RAMETER, '
        '  ISCUSTOMPARAMETER, IDPARAMETERTYPE'
        'FROM UNIONPARAMETERS'
        'WHERE ID = :ID')
    end
  end
  inherited FDQuery: TFDQuery [2]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDParameterType;Order'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode, uvUpdateNonBaseFields]
    SQL.Strings = (
      'select up.* '
      'from UnionParameters up'
      'where up.ParentParameter is null and IDParameterType is not null'
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
  object FDQuery2: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'select *'
      'from UnionParameters'
      'where ParentParameter is null and IDParameterType is not null'
      'and tablename in'
      '('
      '    select TableName'
      '    from UnionParameters'
      
        '    where ParentParameter is null and IDParameterType is not nul' +
        'l'
      '    group by TableName'
      '    having count(*) > 1'
      ')'
      'and ( ( TableName = :TableName ) or ( :TableName = '#39#39' ) )'
      'order by IDParameterType, `Order`')
    Left = 136
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
