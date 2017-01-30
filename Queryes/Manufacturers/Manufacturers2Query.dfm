inherited QueryManufacturers2: TQueryManufacturers2
  Width = 204
  Height = 90
  ExplicitWidth = 204
  ExplicitHeight = 90
  inherited Label1: TLabel
    Width = 104
    Caption = 'Manufacturers2'
    ExplicitWidth = 104
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from manufacturers2'
      'order by Name')
    object FDQueryID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryName: TWideStringField
      DisplayLabel = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      FieldName = 'Name'
      Origin = 'Name'
      Required = True
      Size = 200
    end
    object FDQueryProducts: TWideStringField
      FieldName = 'Products'
      Origin = 'Products'
      Size = 300
    end
  end
  object fdqDropUnused: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'delete from manufacturers2'
      'where id in'
      '('
      '    select m.id'
      '    from manufacturers2 m'
      '    where not exists'
      '    ('
      '        select *'
      '            from descriptions2'
      '            where IDManufacturer = m.id '
      '    )'
      ')')
    Left = 144
    Top = 26
  end
end
