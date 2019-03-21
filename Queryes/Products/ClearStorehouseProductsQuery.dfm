inherited QryClearStoreHouseProducts: TQryClearStoreHouseProducts
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'update StorehouseProducts'
      'set '
      '    SaleCount = null,'
      '    WholeSale = null,'
      '    IDExtraCharge = null,'
      '    IDExtraChargeType = null')
  end
end
