inherited QueryParameterTypes: TQueryParameterTypes
  Width = 203
  Height = 82
  ExplicitWidth = 203
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
      'select * from ParameterTypes'
      'order by ParameterType')
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
end
