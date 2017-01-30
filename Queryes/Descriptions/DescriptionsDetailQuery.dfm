inherited QueryDescriptionsDetail: TQueryDescriptionsDetail
  Width = 208
  Height = 84
  ExplicitWidth = 208
  ExplicitHeight = 84
  inherited Label1: TLabel
    Width = 117
    Caption = 'DescriptionsDetail'
    ExplicitWidth = 117
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
      'select *'
      'from descriptions2')
    object FDQueryID: TFDAutoIncField
      AutoGenerateValue = arDefault
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
    end
    object FDQueryIDManufacturer: TIntegerField
      FieldName = 'IDManufacturer'
      Origin = 'IDManufacturer'
    end
  end
  object FDQuery2: TFDQuery
    SQL.Strings = (
      'select d.*'
      'from descriptions2 d'
      'where '
      'd.ComponentName in'
      '('
      'select ComponentName'
      'from descriptions2 '
      'group by ComponentName'
      'having count(*) > 1'
      ')')
    Left = 144
    Top = 24
  end
end
