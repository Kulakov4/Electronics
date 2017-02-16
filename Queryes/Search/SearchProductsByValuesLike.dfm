inherited QuerySearchProductsByValuesLike: TQuerySearchProductsByValuesLike
  inherited Label1: TLabel
    Width = 187
    Caption = 'SearchProductsByValuesLike'
    ExplicitWidth = 187
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.ID'
      'from'
      'Products2 p'
      'where '
      '  p.Value like '#39'ICL%'#39' or p.Value like '#39'MAX%'#39)
  end
end
