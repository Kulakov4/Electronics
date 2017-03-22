inherited QueryRecursiveTree: TQueryRecursiveTree
  inherited Label1: TLabel
    Width = 93
    Caption = 'RecursiveTree'
    ExplicitWidth = 93
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'with recursive m(Depth, Path, ID, Value, ParentID, ExternalID) '
      'as '
      '('
      '    select 1, value path, id, value, parentid, externalid'
      '    from ProductCategories '
      '    where parentid is null'
      '    union all'
      
        '    select depth + 1, path || '#39'-'#39' || c.value, c.id, c.value, c.p' +
        'arentid, c.externalid'
      '    from ProductCategories c'
      '    join m on c.parentid = m.id'
      ') '
      'select '
      
        '  m.ExternalID, m.Value, m2.ExternalId as ParentExternalID  -- ,' +
        ' m.depth - 1 "'#1059#1088#1086#1074#1077#1085#1100'", m.Path "'#1055#1091#1090#1100'"'
      'from m'
      'left join m m2 on m.parentid = m2.id and m.parentid <> m.id'
      'order by m.depth, m.externalid')
  end
end
