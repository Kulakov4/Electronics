inherited QueryBodyKinds: TQueryBodyKinds
  inherited Label1: TLabel
    Width = 66
    Caption = 'BodyKinds'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BodyKinds'
      'order by Ord')
  end
end
