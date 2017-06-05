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
      '    bd.IDBody,'
      '    bd.IDProducer,'
      '    bd.BodyData,'
      
        '    b.Body0 || ifnull(b.Body1, '#39#39') || ifnull(b.Body2, '#39#39') || ifn' +
        'ull(b.Body3, '#39#39') || ifnull(b.Body4, '#39#39') || ifnull(b.Body5, '#39#39') B' +
        'ody,'
      '    b.Body0,'
      '    b.Body1,'
      '    b.Body2,'
      '    b.Body3,'
      '    b.Body4,'
      '    b.Body5,    '
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join BodyVariations2 bv on bv.IDBodyData = bd.ID'
      'order by IDBodyKind, Body, BodyData')
  end
end
