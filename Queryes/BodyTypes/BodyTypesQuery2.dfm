inherited QueryBodyTypes2: TQueryBodyTypes2
  Width = 319
  Height = 81
  ExplicitWidth = 319
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
      'select '
      '    GROUP_CONCAT(bv.ID, '#39', '#39') IDS,'
      '    bv.IDBodyData, '
      '    bv.OutlineDrawing,'
      '    bv.LandPattern,'
      '    GROUP_CONCAT(bv.Variation, '#39', '#39') Variations,'
      '    bv.Image,'
      '    bd.IDBody,'
      '    bd.IDProducer,'
      '    bd.BodyData,'
      '    b.Body,'
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join BodyVariations2 bv on bv.IDBodyData = bd.ID'
      'group by '
      '    IDBodyData, '
      '    OutlineDrawing,'
      '    LandPattern,'
      '    Image,'
      '    IDBody,'
      '    IDProducer,'
      '    BodyData,'
      '    Body,'
      '    IDBodyKind'
      'order by IDBodyKind, Body, BodyData')
  end
end
