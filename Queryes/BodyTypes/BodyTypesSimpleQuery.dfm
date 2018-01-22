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
      '    BodyData,'
      '    b.Body,'
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join BodyVariations2 bv on bv.IDBodyData = bd.ID'
      'order by IDBodyKind, Body, BodyData')
  end
end
