inherited QueryBodyKinds: TQueryBodyKinds
  Width = 263
  ExplicitWidth = 263
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
    UpdateOptions.AssignedValues = [uvRefreshMode, uvCheckRequired]
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'select bk.*'
      'from BodyKinds bk'
      '/* ShowDuplicate'
      'join Bodies b on b.IDBodyKind = bk.id'
      'join BodyData bd on bd.IDBody = b.id'
      
        'join BodyVariations2 bv on bv.IDBodyData = bd.ID and bv.variatio' +
        'n in'
      '    ('
      '        select Variation'
      '        from BodyVariations2'
      '        where variation <> '#39#39
      '        group by Variation'
      '        having count(*) > 1    '
      '    )'
      'ShowDuplicate */    '
      'order by bk.Ord')
  end
end
