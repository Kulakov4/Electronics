inherited QueryDescriptionsMaster: TQueryDescriptionsMaster
  Width = 216
  Height = 100
  ExplicitWidth = 216
  ExplicitHeight = 100
  inherited Label1: TLabel
    Width = 126
    Caption = 'DescriptionsMaster'
    ExplicitWidth = 126
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from DescriptionComponentTypes'
      'order by ComponentType')
    object FDQueryID: TFDAutoIncField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryComponentType: TWideStringField
      DisplayLabel = #1058#1080#1087
      DisplayWidth = 100
      FieldName = 'ComponentType'
      Origin = 'ComponentType'
      Required = True
      Size = 200
    end
  end
  object FDQuery2: TFDQuery
    SQL.Strings = (
      'select dct.*'
      'from DescriptionComponentTypes dct'
      'where exists'
      '('
      '    select d.*'
      '    from descriptions2 d'
      '    where '
      '    d.ComponentName in'
      '    ('
      '        select ComponentName'
      '        from descriptions2 '
      '        group by ComponentName'
      '        having count(*) > 1'
      '    )'
      ')'
      'order by dct.ComponentType')
    Left = 144
    Top = 26
  end
end
