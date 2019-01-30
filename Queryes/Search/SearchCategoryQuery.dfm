inherited QuerySearchCategory: TQuerySearchCategory
  inherited Label1: TLabel
    Width = 105
    Caption = 'SearchCategory'
    ExplicitWidth = 105
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from productcategories pc'
      'where 0=0 and 1=1')
  end
end
