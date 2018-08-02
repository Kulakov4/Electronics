inherited QueryBodyVariationsJedec: TQueryBodyVariationsJedec
  inherited Label1: TLabel
    Left = 3
    Top = 3
    Width = 135
    Caption = 'BodyVariationsJedec'
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 135
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select Distinct IDJEDEC, Color, J.JEDEC'
      'from BodyVariationJEDEC bvj'
      'join JEDEC j on bvj.IDJEDEC = j.ID'
      'where IDBodyVariation in (0)')
  end
end
