inherited QueryBillContentExport: TQueryBillContentExport
  inherited Label1: TLabel
    Width = 111
    Caption = 'BillContentExport'
    ExplicitWidth = 111
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      '('
      'select'
      '    cast (b.id as INTEGER) ID,'
      '    1 IsGroup,    '
      
        '    '#39#1057#1095#1105#1090' '#8470#39' || b.Number || '#39' '#1086#1090' '#39' || strftime('#39'%d.%m.%Y'#39', b.Bil' +
        'lDate) || '
      
        '    CASE WHEN b.ShipmentDate IS NULL THEN '#39#39' ELSE '#39' '#1086#1090#1075#1088#1091#1078#1077#1085' '#39' |' +
        '| strftime('#39'%d.%m.%Y'#39',b.ShipmentDate) END  Value,'
      '    NULL BillID,'
      '    b.Number BillNumber,'
      '    b.BillDate,    '
      '    b.ShipmentDate,'
      '    b.Width,'
      '    NULL IDProducer,'
      '    NULL StorehouseId,'
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
      'from Bill b '
      'union'
      'select'
      '       cast (-sp.Id -100000 as INTEGER) ID,'
      '       0 IsGroup,       '
      '       p.Value,'
      '       bc.BillID,'
      '       b.Number BillNumber,'
      '       b.BillDate,'
      '       b.ShipmentDate,'
      '       b.Width,       '
      '       p.IDProducer,'
      '       sp.StorehouseId,       '
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
      '       bc.SaleCount,'
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
      'join Products2 p on sp.ProductId = p.id'
      'join BillContent bc on bc.StorehouseProductID = sp.Id'
      'join Bill b on bc.BillID = b.ID'
      'left join Products pr on p.Value = pr.Value'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      ')'
      'where (0=0) and (1=1)')
  end
end
