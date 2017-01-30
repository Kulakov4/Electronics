inherited QueryParameterTypes: TQueryParameterTypes
  Width = 280
  Height = 82
  ExplicitWidth = 280
  ExplicitHeight = 82
  inherited Label1: TLabel
    Width = 107
    Caption = 'ParameterTypes'
    ExplicitWidth = 107
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrd'
        Fields = 'Ord'
      end>
    IndexName = 'idxOrd'
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select pt.* '
      'from ParameterTypes pt'
      'WHERE EXISTS '
      '('
      '    SELECT *'
      '    FROM UnionParameters'
      
        '    WHERE IDParameterType = pt.ID and ParentParameter IS NULL AN' +
        'D IsCustomParameter = 0 AND '
      '    ( (TableName = :TableName) or (:TableName = '#39#39') )'
      ')'
      'order by ParameterType')
    ParamData = <
      item
        Name = 'TABLENAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end>
    object FDQueryID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryParameterType: TWideStringField
      DisplayLabel = #1058#1080#1087
      FieldName = 'ParameterType'
      Origin = 'ParameterType'
      Required = True
      Size = 200
    end
    object FDQueryOrd: TIntegerField
      FieldName = 'Ord'
      Origin = 'Ord'
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PARAMETERTYPES'
      '(PARAMETERTYPE, ORD)'
      'VALUES (:NEW_PARAMETERTYPE, :NEW_ORD);'
      'SELECT ID, ORD'
      'FROM PARAMETERTYPES'
      'WHERE ID = LAST_INSERT_ROWID()')
    ModifySQL.Strings = (
      'UPDATE PARAMETERTYPES'
      'SET PARAMETERTYPE = :NEW_PARAMETERTYPE, ORD = :NEW_ORD'
      'WHERE ID = :OLD_ID;'
      'SELECT ID, ORD'
      'FROM PARAMETERTYPES'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM PARAMETERTYPES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, PARAMETERTYPE, ORD'
      'FROM PARAMETERTYPES'
      'WHERE ID = :ID')
    Left = 144
    Top = 24
  end
  object FDQuery2: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'SELECT pt.*'
      'FROM ParameterTypes pt'
      'WHERE EXISTS '
      '('
      '    SELECT *'
      '    FROM UnionParameters'
      
        '    WHERE IDParameterType = pt.ID and ParentParameter IS NULL AN' +
        'D IsCustomParameter = 0 AND '
      '    tablename IN '
      '    ('
      '        SELECT TableName'
      '        FROM UnionParameters'
      '        WHERE ParentParameter IS NULL AND IsCustomParameter = 0'
      '        GROUP BY TableName'
      '        HAVING count( * ) > 1'
      '    )'
      '    and ( (tablename = :tablename) or (:tablename = '#39#39') )'
      '    ORDER BY IDParameterType, [Order]'
      ')'
      'ORDER BY Ord;')
    Left = 216
    Top = 24
    ParamData = <
      item
        Name = 'TABLENAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = Null
      end>
  end
end
