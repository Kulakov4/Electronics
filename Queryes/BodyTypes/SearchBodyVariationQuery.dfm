inherited QrySearchBodyVariation: TQrySearchBodyVariation
  inherited Label1: TLabel
    Width = 136
    Caption = 'SearchBodyVariation'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      '('
      'select'
      '    '#39','#39' || GROUP_CONCAT(bv.ID, '#39','#39') || '#39','#39' IDS,'
      '    bv.IDBodyData,'
      '    bv.OutlineDrawing,'
      '    bv.LandPattern,'
      '    '#39','#39' || GROUP_CONCAT(bv.Variation, '#39','#39') || '#39','#39' Variations,'
      '    bv.Image,'
      '    bv.JEDEC,'
      '    bv.OPTIONS,'
      '    bd.IDBody,'
      '    bd.IDProducer,'
      '    bd.BodyData,'
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
      'group by'
      '    IDBodyData,'
      '    OutlineDrawing,'
      '    LandPattern,'
      '    Image,'
      '    JEDEC,'
      '    OPTIONS,'
      '    IDBody,'
      '    IDProducer,'
      '    BodyData,'
      '    Body,'
      '    IDBodyKind'
      ')'
      'where 0=0'
      'order by IDBodyKind, IDBody, IDBodyData')
  end
end
