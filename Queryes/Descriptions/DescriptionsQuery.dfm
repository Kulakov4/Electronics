inherited QueryDescriptions: TQueryDescriptions
  Width = 208
  Height = 84
  ExplicitWidth = 208
  ExplicitHeight = 84
  inherited Label1: TLabel
    Width = 80
    Caption = 'Descriptions'
    ExplicitWidth = 80
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDComponentType;ComponentName'
      end>
    IndexName = 'idxOrder'
    SQL.Strings = (
      'select d.*'
      'from descriptions2 d'
      'where 0=0'
      '/* Filter'
      '    and'
      '    d.ComponentName like :ComponentName'
      'Filter */'
      '/* ShowDuplicate'
      '    and'
      '    d.ComponentName in'
      '    ('
      '        select ComponentName'
      '        from descriptions2 '
      '        group by ComponentName'
      '        having count(*) > 1'
      '    )'
      'ShowDuplicate */')
    object FDQueryID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryComponentName: TWideStringField
      FieldName = 'ComponentName'
      Origin = 'ComponentName'
      Size = 1000
    end
    object FDQueryDescription: TWideMemoField
      FieldName = 'Description'
      Origin = 'Description'
      BlobType = ftWideMemo
    end
    object FDQueryIDComponentType: TIntegerField
      FieldName = 'IDComponentType'
      Origin = 'IDComponentType'
      Required = True
    end
    object FDQueryIDProducer: TIntegerField
      FieldName = 'IDProducer'
      Origin = 'IDProducer'
      Required = True
    end
  end
end
