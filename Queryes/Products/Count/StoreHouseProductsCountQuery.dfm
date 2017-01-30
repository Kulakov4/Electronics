inherited QueryStoreHouseProductsCount: TQueryStoreHouseProductsCount
  inherited Label1: TLabel
    Width = 172
    Caption = 'StoreHouseProductsCount'
    ExplicitWidth = 172
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select count(*) components_count'
      'from StorehouseProducts sp')
  end
end
