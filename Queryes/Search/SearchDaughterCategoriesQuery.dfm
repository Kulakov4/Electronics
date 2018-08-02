inherited QuerySearchDaughterCategories: TQuerySearchDaughterCategories
  inherited Label1: TLabel
    Width = 131
    Caption = 'DaughterCategories'
    ExplicitWidth = 131
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'with recursive m(ID, Value, Path, Depth) as'
      '('
      '    select ID, Value, '#39#39' as Path, 1 as Depth'
      '    from ProductCategories '
      '    where ID = :ID'
      '    '
      '    union'
      '    '
      
        '    select pc.ID, pc.Value, m.Path || '#39'\'#39' || pc.Value, m.Depth +' +
        ' 1'
      '    from ProductCategories pc, m'
      '    where pc.ParentID = m.ID'
      ')'
      'select m.id, m.value, trim(m.path, '#39'\'#39') path, m.depth'
      'from m')
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
