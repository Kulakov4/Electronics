inherited QueryBodyKinds: TQueryBodyKinds
  inherited Label1: TLabel
    Width = 66
    Caption = 'BodyKinds'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'Ord'
      end>
    IndexName = 'idxOrder'
    SQL.Strings = (
      'select *'
      'from BodyKinds'
      'order by Ord')
  end
end
