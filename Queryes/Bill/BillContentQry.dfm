inherited QueryBillContent: TQueryBillContent
  inherited Label1: TLabel
    Width = 92
    Caption = 'BillContentQry'
    ExplicitWidth = 92
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'SELECT -sp.Id - 100000 ID,'
      '      p.Value,'
      '      sp.StorehouseId,'
      '      0 IsGroup,'
      '      sp.IDComponentGroup,'
      '      p.IDProducer,'
      '      sp.Amount,'
      '      sp.Price,'
      '      bc.CalcPriceR,'
      '      sp.ProductId,'
      '      sp.ReleaseDate,'
      '      sp.BatchNumber,'
      '      sp.Packaging,'
      '      sp.OriginCountry,'
      '      sp.CustomsDeclarationNumber,'
      '      sp.Storage,'
      '      sp.DocumentNumber,'
      '      sp.Barcode,'
      '      sp.Seller,'
      '      sp.StoragePlace,'
      '      sp.OriginCountryCode,'
      '      sp.IDCurrency,'
      '      sp.LoadDate,'
      '      sp.DOLLAR,'
      '      sp.EURO,'
      '      bc.RETAIL,'
      '      sp.MinWholeSale,'
      '      bc.WholeSale,'
      '      sp.IDExtraChargeType,'
      '      sp.IDExtraCharge,'
      '      bc.SaleCount,'
      '      bc.Markup,'
      '      p.PackagePins,'
      '      p.Datasheet,'
      '      p.Diagram,'
      '      p.Drawing,'
      '      p.Image,'
      '      p.DescriptionID,'
      '      d.ComponentName DescriptionComponentName,'
      '      d.Description,'
      '      CASE WHEN pr.ID IS NULL THEN 0 ELSE 1 END Checked,'
      '      bc.ID BillContentID,'
      '      bc.BillID,'
      '      case IDCurrency'
      '            when 1 then Price'
      '            when 2 then Price * Dollar'
      '            when 3 then Price * Euro'
      '      end PriceR,'
      '      case IDCurrency'
      '            when 1 then Price / Dollar'
      '            when 2 then Price'
      '            when 3 then Price * Euro / Dollar'
      '      end PriceD,'
      '      case IDCurrency'
      '            when 1 then Price / Euro'
      '            when 2 then Price * Dollar / Euro'
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
      '  FROM StorehouseProducts sp'
      '       JOIN'
      '       Products2 p ON sp.ProductId = p.id'
      '       JOIN'
      '       BillContent bc ON bc.StorehouseProductID = sp.Id'
      '       JOIN'
      '       ('
      '           SELECT bc.BillID,'
      
        '                  sum(bc.CalcPriceR * bc.SaleCount * (1 + bc.Mar' +
        'kup/100.0) ) SumSaleR-- '#1087#1088#1086#1076#1072#1078#1085#1072#1103' '#1094#1077#1085#1072' '#1074' '#1088#1091#1073'.'
      '             FROM BillContent bc'
      '            GROUP BY bc.BillID'
      '       ) bcsum on bcsum.BillID = bc.billid'
      '       LEFT JOIN'
      '       Products pr ON p.Value = pr.Value'
      '       LEFT JOIN'
      '       Descriptions2 d ON p.DescriptionId = d.ID'
      ' WHERE (0=0) AND '
      '       (1=1);')
  end
end
