inherited QueryEmptyFamilyCount: TQueryEmptyFamilyCount
  inherited Label1: TLabel
    Width = 117
    Caption = 'EmptyFamilyCount'
    ExplicitWidth = 117
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select count(*) components_count'
      'from products p'
      'where p.ParentProductId is null'
      'and not exists '
      '('
      '    select p2.* '
      '    from products p2'
      '    where p2.ParentProductId = p.id'
      ')')
  end
end
