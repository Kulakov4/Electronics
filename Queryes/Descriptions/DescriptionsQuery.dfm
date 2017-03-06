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
      'select *'
      'from descriptions2')
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
