inherited QueryParameterTypes: TQueryParameterTypes
  Width = 320
  Height = 82
  ExplicitWidth = 320
  ExplicitHeight = 82
  inherited Label1: TLabel
    Width = 107
    Caption = 'ParameterTypes'
    ExplicitWidth = 107
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'SELECT pt.*'
      'FROM ParameterTypes pt'
      'WHERE EXISTS '
      '('
      '    SELECT *'
      '    FROM Parameters'
      
        '    WHERE IDParameterType = pt.ID and IDParameterType is not nul' +
        'l '
      '    /* ShowDuplicate    '
      '    AND tablename IN '
      '    ('
      '        SELECT TableName'
      '        FROM Parameters'
      '        GROUP BY TableName'
      '        HAVING count( * ) > 1'
      '    )'
      '    ShowDuplicate */    '
      '    AND ( (tablename = :tablename) or (:tablename = '#39#39') )'
      '    ORDER BY IDParameterType, [Order]'
      ')'
      'ORDER BY Ord;')
    ParamData = <
      item
        Name = 'TABLENAME'
        ParamType = ptInput
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
  object fdqDeleteNotUsedPT: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'delete'
      'from ParameterTypes'
      'where not exists'
      '('
      '    select p.id'
      '    from Parameters p'
      '    where p.IDParameterType = ParameterTypes.id'
      ')')
    Left = 240
    Top = 24
  end
end
