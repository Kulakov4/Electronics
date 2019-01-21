inherited QueryBodyTypes2: TQueryBodyTypes2
  Width = 400
  Height = 81
  ExplicitWidth = 400
  ExplicitHeight = 81
  inherited Label1: TLabel
    Width = 78
    Caption = 'BodyTypes2'
    ExplicitWidth = 78
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDBodyKind'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select'
      '    GROUP_CONCAT(bv.ID, '#39', '#39') IDS,'
      '    bv.IDBodyData,'
      '    bv.OutlineDrawing,'
      '    bv.LandPattern,'
      '    GROUP_CONCAT(bv.Variation, '#39', '#39') Variations,'
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
      'order by IDBodyKind, Body, BodyData')
  end
end
