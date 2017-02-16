inherited QuerySearchComponentsByValuesLike: TQuerySearchComponentsByValuesLike
  inherited Label1: TLabel
    Width = 209
    Caption = 'SearchComponentsByValuesLike'
    ExplicitWidth = 209
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.ID,'
      '    p.ParentProductId '
      'from'
      'Products p'
      'where '
      '  p.Value like '#39'ICL%'#39' or p.Value like '#39'MAX%'#39)
  end
end
