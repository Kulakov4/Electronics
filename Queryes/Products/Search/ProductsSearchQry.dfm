inherited QryProductsSearch: TQryProductsSearch
  inherited Label1: TLabel
    Width = 155
    Caption = 'ProductsSearchInternal'
    ExplicitWidth = 155
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      '('
      'select'
      '    cg.id ID,'
      '    cg.ComponentGroup Value,'
      '    NULL StorehouseId,'
      '    NULL StorehouseId2,'
      '    1 IsGroup,'
      '    NULL IDComponentGroup, '
      '    NULL IDProducer, '
      '    NULL Amount,'
      '    NULL Price,'
      '    NULL ProductId,'
      '    NULL ReleaseDate,'
      '    NULL BatchNumber,'
      '    NULL Packaging,'
      '    NULL OriginCountry,'
      '    NULL CustomsDeclarationNumber,'
      '    NULL Storage,'
      '    NULL DocumentNumber,'
      '    NULL Barcode,'
      '    NULL Seller,'
      '    NULL StoragePlace,'
      '    NULL OriginCountryCode,'
      '    NULL IDCurrency,'
      '    NULL LoadDate,'
      '    NULL DOLLAR,'
      '    NULL EURO,'
      '    cast (NULL as INTEGER) RETAIL,'
      '    cast (NULL as INTEGER) MinWholeSale,'
      '    cast (NULL as REAL) SaleCount,'
      '    cast (NULL as REAL) WholeSale,'
      '    cast (NULL as INTEGER) IDExtraChargeType,'
      '    cast (NULL as INTEGER) IDExtraCharge,'
      '    NULL PackagePins,'
      '    NULL Datasheet,'
      '    NULL Diagram,'
      '    NULL Drawing,'
      '    NULL Image,'
      '    NULL DescriptionID,'
      '    NULL DescriptionComponentName,'
      '    NULL Description,'
      '    0 Checked'
      'from StorehouseProducts sp '
      'join Products2 p on sp.ProductId = p.id and (1=1)'
      'join ComponentGroups cg on sp.IDComponentGroup = cg.id'
      'where sp.Amount > 0'
      'union'
      'select'
      '       -sp.Id -100000 ID,'
      '       p.Value,'
      '       sp.StorehouseId,'
      '       sp.StorehouseId StorehouseId2,'
      '       0 IsGroup,       '
      '       sp.IDComponentGroup,'
      '       p.IDProducer,'
      '       sp.Amount,'
      '       sp.Price,'
      '       sp.ProductId,'
      '       sp.ReleaseDate,'
      '       sp.BatchNumber,'
      '       sp.Packaging,'
      '       sp.OriginCountry,'
      '       sp.CustomsDeclarationNumber,'
      '       sp.Storage,'
      '       sp.DocumentNumber,'
      '       sp.Barcode,'
      '       sp.Seller,'
      '       sp.StoragePlace,'
      '       sp.OriginCountryCode,'
      '       sp.IDCurrency,'
      '       sp.LoadDate,'
      '       sp.DOLLAR,'
      '       sp.EURO,'
      '       sp.RETAIL,'
      '       sp.MinWholeSale,'
      '       sp.SaleCount,'
      '       sp.WholeSale,'
      '       sp.IDExtraChargeType,'
      '       sp.IDExtraCharge,'
      '       p.PackagePins,'
      '       p.Datasheet,'
      '       p.Diagram,'
      '       p.Drawing,'
      '       p.Image,'
      '       p.DescriptionID,'
      '       d.ComponentName DescriptionComponentName,'
      '       d.Description,'
      '       case when pr.ID is null then 0 else 1 end Checked'
      'from StorehouseProducts sp'
      'join Products2 p on sp.ProductId = p.id and (2=2)'
      'left join Products pr on p.Value = pr.Value'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'where sp.Amount > 0'
      ')'
      'where 0=0'
      'order by IsGroup desc, Value')
  end
end
