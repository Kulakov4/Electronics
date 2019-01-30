inherited QuerySearchStorehouseProduct: TQuerySearchStorehouseProduct
  inherited Label1: TLabel
    Width = 120
    Caption = 'SearchStorehouse'
    ExplicitWidth = 120
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from storehouseproducts'
      'where (0=0) and (1=1)')
  end
end
