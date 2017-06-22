inherited QuerySearchProduct: TQuerySearchProduct
  inherited Label1: TLabel
    Width = 96
    Caption = 'SearchProduct'
    ExplicitWidth = 96
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from Products2'
      'where 0=0')
  end
end
