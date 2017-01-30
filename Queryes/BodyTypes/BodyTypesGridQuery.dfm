inherited QueryBodyTypesGrid: TQueryBodyTypesGrid
  inherited Label1: TLabel
    Width = 95
    Caption = 'BodyTypesGrid'
    ExplicitWidth = 95
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select bt1.BodyType BodyType1, bt.BodyType, bv.LandPattern, bv.O' +
        'utlineDrawing, bv.Variation, bv.Image, bt0.BodyType BodyType0'
      'from BodyVariations bv'
      'join BodyTypes bt on bv.IDBodyType = bt.ID'
      'left join BodyTypes bt1 on bt.IDParentBodyType = bt1.ID'
      'left join BodyTypes bt0 on bt1.IDParentBodyType = bt0.ID'
      
        'order by bt0.BodyType, bt1.BodyType, bt.BodyType, bv.LandPattern' +
        ', bv.OutlineDrawing, bv.Variation, bv.Image')
  end
end
