inherited QueryBodyOptions: TQueryBodyOptions
  inherited Label1: TLabel
    Width = 81
    Caption = 'BodyOptions'
    ExplicitWidth = 81
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BodyOptions'
      'Order by Option')
  end
end
