inherited QueryProducts: TQueryProducts
  Width = 139
  Height = 77
  ExplicitWidth = 139
  ExplicitHeight = 77
  inherited Label1: TLabel
    Width = 58
    Caption = 'Products'
    ExplicitWidth = 58
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      '('
      'select'
      '    cast (cg.id as INTEGER) ID,'
      '    cg.ComponentGroup Value,'
      '    sp.StorehouseId,'
      '    1 IsGroup,'
      '    NULL IDComponentGroup,'
      '    NULL IDProducer,'
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
      '    NULL PackagePins,'
      '    NULL Datasheet,'
      '    NULL Diagram,'
      '    NULL Drawing,'
      '    NULL Image,'
      '    NULL DescriptionID,'
      '    NULL DescriptionComponentName,'
      '    NULL Description,'
      '    0 Checked'
      'from StorehouseProducts sp'
      'join ComponentGroups cg on sp.IDComponentGroup = cg.id'
      'union'
      'select'
      '       cast (-sp.Id -100000 as INTEGER) ID,'
      '       p.Value,'
      '       sp.StorehouseId,'
      '       0 IsGroup,'
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
      'join Products2 p on sp.ProductId = p.id'
      'left join Products pr on p.Value = pr.Value'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      ')'
      'where (0=0) and (1=1)')
  end
end
