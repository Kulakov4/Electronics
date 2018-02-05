inherited QueryMainParameters: TQueryMainParameters
  Width = 551
  Height = 86
  ExplicitWidth = 551
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
      SQL.Strings = (
        'select *'
        'from Parameters'
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
        'INSERT INTO PARAMETERS'
        '(VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
        '  TABLENAME, DEFINITION, "ORDER", FIELDTYPE, '
        
          '  PARENTPARAMETER, ISCUSTOMPARAMETER, IDPARAMETERTYPE, IDPARAMET' +
          'ERKIND)'
        
          'VALUES (:NEW_VALUE, :NEW_VALUET, :NEW_CODELETTERS, :NEW_MEASURIN' +
          'GUNIT, '
        '  :NEW_TABLENAME, :NEW_DEFINITION, :NEW_ORDER, :NEW_FIELDTYPE, '
        
          '  :NEW_PARENTPARAMETER, :NEW_ISCUSTOMPARAMETER, :NEW_IDPARAMETER' +
          'TYPE, :NEW_IDPARAMETERKIND);'
        ''
        'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
        
          '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
          'RAMETER, '
        '  ISCUSTOMPARAMETER, IDPARAMETERTYPE, IDPARAMETERKIND'
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
        '  IDPARAMETERTYPE = :NEW_IDPARAMETERTYPE,'
        '  IDPARAMETERKIND = :NEW_IDPARAMETERKIND'
        'WHERE ID = :OLD_ID;'
        ''
        '')
      DeleteSQL.Strings = (
        'DELETE FROM PARAMETERS'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, VALUE, VALUET, CODELETTERS, MEASURINGUNIT, '
        
          '  TABLENAME, DEFINITION, "ORDER" AS "ORDER", FIELDTYPE, PARENTPA' +
          'RAMETER, '
        '  ISCUSTOMPARAMETER, IDPARAMETERTYPE, IDPARAMETERKIND'
        'FROM PARAMETERS'
        'WHERE ID = :ID')
    end
  end
  inherited FDQuery: TFDQuery [2]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDParameterType'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode, uvUpdateNonBaseFields]
  end
  object fdqBase: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      
        'select p.*, IFNULL(cp.id, 0) > 0 Checked, t.ID ParamSubParamID, ' +
        't.IdSubParameter'
      'from Parameters p'
      'LEFT JOIN '
      '('
      '    select psp.ID, psp.IdParameter, psp.IdSubParameter'
      '    from ParamSubParams psp'
      
        '    join SubParameters sp on psp.IdSubParameter = sp.Id and sp.I' +
        'sDefault = 1'
      ') t on t.IdParameter = p.Id'
      ''
      
        'LEFT JOIN CategoryParams2 cp on cp.ProductCategoryId = :ProductC' +
        'ategoryId and cp.ParamSubParamID = t.id '
      
        'where p.ParentParameter is null and p.IDParameterType is not nul' +
        'l'
      '/* ShowDuplicate'
      'and tablename in'
      '('
      '    select TableName'
      '    from Parameters'
      
        '    where ParentParameter is null and IDParameterType is not nul' +
        'l'
      '    group by TableName'
      '    having count(*) > 1'
      ')'
      'ShowDuplicate */'
      'and ( ( p.TableName = :TableName ) or ( :TableName = '#39#39' ) )'
      'order by p.IDParameterType, p.[Order]')
    Left = 136
    Top = 24
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'TABLENAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end>
  end
  object fdqDeleteFromCategoryParams: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'delete from CategoryParams where ParameterID = :ParameterID')
    Left = 400
    Top = 24
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
