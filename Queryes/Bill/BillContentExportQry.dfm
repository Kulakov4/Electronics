inherited QryBillContentExport: TQryBillContentExport
  inherited Label1: TLabel
    Width = 111
    Caption = 'BillContentExport'
    ExplicitWidth = 111
  end
  inherited FDQuery: TFDQuery
    OnCalcFields = FDQueryCalcFields
    SQL.Strings = (
      'select'
      '       bc.BillID || '#39'_'#39' || sp.Id ID,'
      
        '--       '#39#1057#1095#1105#1090' '#8470#39' || b.Number || '#39' '#1086#1090' '#39' || strftime('#39'%d.%m.%Y'#39', ' +
        'b.BillDate) || '
      
        '--       CASE WHEN b.ShipmentDate IS NULL THEN '#39#39' ELSE '#39' '#1086#1090#1075#1088#1091#1078#1077 +
        #1085' '#39' || strftime('#39'%d.%m.%Y'#39',b.ShipmentDate) END  BillTitle,'
      '       p.Value,'
      '       bc.BillID,'
      '       b.Number BillNumber,'
      '       b.BillDate,'
      '       b.ShipmentDate,'
      '       b.Width,       '
      '       p.IDProducer,'
      '       sp.StorehouseId,'
      '       sh.Abbreviation StoreHouse,'
      '       prod.Name Producer,'
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
      '       case when pr.ID is null then 0 else 1 end Checked,'
      '      case IDCurrency'
      '            when 1 then Price'
      '            when 2 then Price * sp.Dollar'
      '            when 3 then Price * sp.Euro'
      '      end PriceR,'
      '      case IDCurrency'
      '            when 1 then Price / sp.Dollar'
      '            when 2 then Price'
      '            when 3 then Price * sp.Euro / sp.Dollar'
      '      end PriceD,'
      '      case IDCurrency'
      '            when 1 then Price / sp.Euro'
      '            when 2 then Price * sp.Dollar / sp.Euro'
      '            when 3 then Price'
      '      end PriceE,'
      
        '      bc.CalcPriceR * (1 + bc.Retail/100.0) PriceR1,-- '#1088#1086#1079#1085' '#1094#1077#1085#1072 +
        ' '#1074' '#1088#1091#1073'.'
      
        '      bc.CalcPriceR / sp.Dollar * (1 + bc.Retail/100.0) PriceD1,' +
        '-- '#1088#1086#1079#1085' '#1094#1077#1085#1072' '#1074' '#1076#1086#1083'.'
      
        '      bc.CalcPriceR / sp.Euro * (1 + bc.Retail/100.0) PriceE1,--' +
        ' '#1088#1086#1079#1085' '#1094#1077#1085#1072' '#1074' '#1077#1074#1088#1086'.'
      
        '      bc.CalcPriceR * (1 + bc.WholeSale/100.0) PriceR2,-- '#1086#1087#1090' '#1094#1077 +
        #1085#1072' '#1074' '#1088#1091#1073'.'
      
        '      bc.CalcPriceR / sp.Dollar * (1 + bc.WholeSale/100.0) Price' +
        'D2,-- '#1086#1087#1090' '#1094#1077#1085#1072' '#1074' '#1076#1086#1083'.'
      
        '      bc.CalcPriceR / sp.Euro * (1 + bc.WholeSale/100.0) PriceE2' +
        ',-- '#1086#1087#1090' '#1094#1077#1085#1072' '#1074' '#1077#1074#1088#1086'.'
      
        '      bc.CalcPriceR * bc.SaleCount * (1 + bc.Markup/100.0) SaleR' +
        ',-- '#1087#1088#1086#1076#1072#1078#1085#1072#1103' '#1094#1077#1085#1072' '#1074' '#1088#1091#1073'.'
      
        '      bc.CalcPriceR * bc.SaleCount / sp.Dollar * (1 + bc.Markup/' +
        '100.0) SaleD,-- '#1087#1088#1086#1076#1072#1078#1085#1072#1103' '#1094#1077#1085#1072' '#1074' '#1076#1086#1083'.'
      
        '      bc.CalcPriceR * bc.SaleCount / sp.Euro * (1 + bc.Markup/10' +
        '0.0) SaleE,-- '#1087#1088#1086#1076#1072#1078#1085#1072#1103' '#1094#1077#1085#1072' '#1074' '#1077#1074#1088#1086'.'
      '      bcsum.SumSaleR'
      'from StorehouseProducts sp'
      'join Storehouse sh on sp.StorehouseId = sh.Id'
      'join Producers prod on p.IDProducer = prod.Id'
      'join Products2 p on sp.ProductId = p.id'
      'join BillContent bc on bc.StorehouseProductID = sp.Id'
      'join Bill b on bc.BillID = b.ID'
      'left join Products pr on p.Value = pr.Value'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'JOIN'
      '('
      '           SELECT bc.BillID,'
      
        '                  sum(bc.CalcPriceR * bc.SaleCount * (1 + bc.Mar' +
        'kup/100.0) ) SumSaleR-- '#1087#1088#1086#1076#1072#1078#1085#1072#1103' '#1094#1077#1085#1072' '#1074' '#1088#1091#1073'.'
      '             FROM BillContent bc'
      '            GROUP BY bc.BillID'
      ') bcsum on bcsum.BillID = bc.billid'
      'where (0=0) and (1=1)'
      'order by BillNumber desc, p.Value')
  end
end
