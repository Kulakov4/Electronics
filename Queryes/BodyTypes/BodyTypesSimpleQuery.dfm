inherited QueryBodyTypesSimple: TQueryBodyTypesSimple
  inherited Label1: TLabel
    Width = 111
    Caption = 'BodyTypesSimple'
    ExplicitWidth = 111
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    bv.ID IDS,'
      '    bv.IDBodyData, '
      '    bv.OutlineDrawing,'
      '    bv.LandPattern,'
      '    bv.Variation Variations,'
      '    bv.Image,'
      '    bv.JEDEC,'
      '    bv.OPTIONS,'
      '    bd.IDBody,'
      '    bd.IDProducer,'
      '    BodyData,'
      '    b.Body,'
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join '
      '('
      
        '    select bv2.id, bv2.IDBodyData, bv2.OutlineDrawing, bv2.LandP' +
        'attern, bv2.Variation, bv2.Image'
      '    , GROUP_CONCAT(j.JEDEC, '#39'; '#39') JEDEC'
      '    , GROUP_CONCAT(o.Option, '#39'; '#39') Options'
      '    from BodyVariations2 bv2'
      
        '    left join BodyVariationJEDEC bvj on bvj.IDBodyVariation = bv' +
        '2.ID'
      '    left join JEDEC j on bvj.IDJEDEC = j.ID'
      
        '    left join BodyVariationOption bvo on bvo.IdBodyVariation = b' +
        'v2.ID'
      '    left join BodyOptions o on bvo.IdBodyOption = o.ID'
      
        '    group by bv2.id, bv2.IDBodyData, bv2.OutlineDrawing, bv2.Lan' +
        'dPattern, bv2.Variation, bv2.Image'
      ') bv on bv.IDBodyData = bd.ID'
      ''
      'order by IDBodyKind, Body, BodyData')
  end
end
