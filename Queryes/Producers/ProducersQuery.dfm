inherited QueryProducers: TQueryProducers
  Width = 204
  Height = 78
  ExplicitWidth = 204
  ExplicitHeight = 78
  inherited Label1: TLabel
    Width = 66
    Caption = 'Producers'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*'
      '    ,('
      '        select count(*)'
      '        from ProductUnionParameters pup '
      
        '        where pup.UnionParameterId = :ProducerParameterID and pu' +
        'p.Value = p.Name'
      '    ) Cnt'
      'from Producers p'
      'order by p.Name')
    ParamData = <
      item
        Name = 'PRODUCERPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object FDQueryID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object FDQueryName: TWideStringField
      FieldName = 'Name'
      Origin = 'Name'
      Required = True
      Size = 200
    end
    object FDQueryProducts: TWideStringField
      FieldName = 'Products'
      Origin = 'Products'
      Size = 1000
    end
    object FDQueryProducerType: TWideStringField
      FieldName = 'ProducerType'
      Origin = 'ProducerType'
      Size = 500
    end
    object FDQueryCnt: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'Cnt'
      Origin = 'Cnt'
      ProviderFlags = []
      ReadOnly = True
      OnGetText = FDQueryCntGetText
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
    Top = 24
  end
end
