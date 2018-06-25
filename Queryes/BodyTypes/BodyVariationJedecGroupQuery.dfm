inherited QueryBodyVariationJEDECGroup: TQueryBodyVariationJEDECGroup
  inherited Label1: TLabel
    Width = 166
    Caption = 'BodyVariationJEDECGroup'
    ExplicitWidth = 166
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select GROUP_CONCAT(JEDEC, '#39'; '#39') JEDEC'
      'from'
      '('
      '    select distinct JEDEC'
      '    from BodyVariationJEDEC bvj'
      '    join '
      '    ('
      '        select *'
      '            from JEDEC'
      '            order by ID asc'
      '    ) j on bvj.IDJEDEC = j.ID'
      '    where IDBodyVariation in (0)'
      ')')
  end
end
