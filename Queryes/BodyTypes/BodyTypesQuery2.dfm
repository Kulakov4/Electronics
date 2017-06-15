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
  end
  object fdqBase: TFDQuery
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
      
        '    ifnull(bd.BodyData0, '#39#39') || ifnull(bd.BodyData1, '#39#39') || ifnu' +
        'll(bd.BodyData2, '#39#39') || '
      
        '    ifnull(bd.BodyData3, '#39#39') || ifnull(bd.BodyData4, '#39#39') || ifnu' +
        'll(bd.BodyData5, '#39#39') ||'
      
        '    ifnull(bd.BodyData6, '#39#39') || ifnull(bd.BodyData7, '#39#39') || ifnu' +
        'll(bd.BodyData8, '#39#39') || ifnull(bd.BodyData9, '#39#39') BodyData,'
      '    bd.BodyData0,'
      '    bd.BodyData1,'
      '    bd.BodyData2,'
      '    bd.BodyData3,'
      '    bd.BodyData4,'
      '    bd.BodyData5,'
      '    bd.BodyData6,'
      '    bd.BodyData7,'
      '    bd.BodyData8,'
      '    bd.BodyData9,'
      
        '    ifnull(b.Body0, '#39#39') || ifnull(b.Body1, '#39#39') || ifnull(b.Body2' +
        ', '#39#39') || ifnull(b.Body3, '#39#39') || ifnull(b.Body4, '#39#39') || ifnull(b.' +
        'Body5, '#39#39') Body,'
      '    b.Body0,'
      '    b.Body1,'
      '    b.Body2,'
      '    b.Body3,'
      '    b.Body4,'
      '    b.Body5,'
      '    b.IDBodyKind'
      'from Bodies b'
      'join BodyData bd on bd.IDBody = b.id'
      'join BodyVariations2 bv on bv.IDBodyData = bd.ID '
      '/* ShowDuplicate'
      'and bv.Variation in'
      '('
      '    select Variation'
      '    from BodyVariations2'
      '    where variation <> '#39#39
      '    group by Variation'
      '    having count(*) > 1'
      ')'
      'ShowDuplicate */'
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
    Left = 331
    Top = 25
  end
end
