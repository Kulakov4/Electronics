inherited QuerySearchComponentCategory: TQuerySearchComponentCategory
  inherited Label1: TLabel
    Width = 178
    Caption = 'SearchComponentCategory'
    ExplicitWidth = 178
  end
  object fdqBase: TFDQuery
    SQL.Strings = (
      'select ppc.*'
      'from productproductcategories ppc'
      '--join'
      'where 0=0')
    Left = 80
    Top = 25
  end
end
