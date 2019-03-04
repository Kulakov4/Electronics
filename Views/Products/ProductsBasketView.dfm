inherited ViewProductsBasket: TViewProductsBasket
  inherited cxDBTreeList: TcxDBTreeList
    Bands = <
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        FixedKind = tlbfLeft
      end
      item
        Caption.Text = #1057#1082#1083#1072#1076
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      end
      item
        Caption.AlignHorz = taCenter
        Caption.MultiLine = True
        Caption.ShowEndEllipsis = False
        Caption.Text = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1093#1077#1084#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1063#1077#1088#1090#1105#1078
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1088#1087#1091#1089
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1059#1087#1072#1082#1086#1074#1082#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1054#1087#1090#1086#1074#1072#1103' '#1094#1077#1085#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072' ('#1079#1072' 1 '#1096#1090'.)'
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1047#1072#1082#1091#1087#1086#1095#1085#1072#1103' '#1094#1077#1085#1072' ('#1073#1077#1079' '#1053#1044#1057')'
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1086#1084#1077#1088' '#1087#1072#1088#1090#1080#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1086#1084#1077#1088' '#1090#1072#1084#1086#1078#1077#1085#1085#1086#1081' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'-'#1087#1088#1086#1076#1072#1074#1077#1094
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1091#1088#1089#1099' '#1074#1072#1083#1102#1090
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1080
        FixedKind = tlbfRight
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        FixedKind = tlbfRight
      end>
    OnAfterSummary = cxDBTreeListAfterSummary
    OnEditing = cxDBTreeListEditing
    inherited clIDProducer: TcxDBTreeListColumn [4]
    end
    inherited clDescription: TcxDBTreeListColumn [5]
    end
    inherited clDatasheet: TcxDBTreeListColumn [6]
    end
    inherited clDiagram: TcxDBTreeListColumn [7]
    end
    inherited clDrawing: TcxDBTreeListColumn [8]
    end
    inherited clImage: TcxDBTreeListColumn [9]
    end
    inherited clPackagePins: TcxDBTreeListColumn [10]
    end
    inherited clReleaseDate: TcxDBTreeListColumn [11]
    end
    inherited clAmount: TcxDBTreeListColumn [12]
    end
    inherited clPackaging: TcxDBTreeListColumn [13]
    end
    inherited clPriceR2: TcxDBTreeListColumn [14]
    end
    inherited clPriceD2: TcxDBTreeListColumn [15]
    end
    inherited clPriceR1: TcxDBTreeListColumn [16]
    end
    inherited clPriceD1: TcxDBTreeListColumn [17]
    end
    inherited clPriceR: TcxDBTreeListColumn [18]
    end
    inherited clPriceD: TcxDBTreeListColumn [19]
    end
    inherited clOriginCountryCode: TcxDBTreeListColumn [20]
    end
    inherited clOriginCountry: TcxDBTreeListColumn [21]
    end
    inherited clBatchNumber: TcxDBTreeListColumn [22]
    end
    inherited clCustomsDeclarationNumber: TcxDBTreeListColumn [23]
    end
    inherited clStorage: TcxDBTreeListColumn [24]
    end
    inherited clStoragePlace: TcxDBTreeListColumn [25]
    end
    inherited clSeller: TcxDBTreeListColumn [26]
    end
    inherited clDocumentNumber: TcxDBTreeListColumn [27]
    end
    inherited clBarcode: TcxDBTreeListColumn [28]
    end
    inherited clIDCurrency: TcxDBTreeListColumn [29]
    end
    inherited clChecked: TcxDBTreeListColumn [30]
    end
    inherited clPriceE: TcxDBTreeListColumn [31]
    end
    inherited clPriceE1: TcxDBTreeListColumn [32]
    end
    inherited clPriceE2: TcxDBTreeListColumn [33]
    end
    inherited clLoadDate: TcxDBTreeListColumn [34]
    end
    inherited clDollar: TcxDBTreeListColumn [35]
    end
    inherited clEuro: TcxDBTreeListColumn [36]
    end
    inherited clSaleCount: TcxDBTreeListColumn [37]
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleCount
          Kind = skSum
        end>
    end
    inherited clSaleR: TcxDBTreeListColumn [38]
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleR
          Kind = skSum
        end>
    end
    inherited clSaleD: TcxDBTreeListColumn [39]
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleD
          Kind = skSum
        end>
    end
    inherited clSaleE: TcxDBTreeListColumn [40]
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleE
          Kind = skSum
        end>
    end
    inherited clStoreHouseID: TcxDBTreeListColumn [41]
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxBarManagerBar1: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'cxbeiSaleR'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actBasketDelete
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actBasketClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object cxbeiSaleR: TcxBarEditItem
      Caption = #1048#1090#1086#1075#1086':'
      Category = 0
      Hint = #1048#1090#1086#1075#1086':'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxCurrencyEditProperties'
    end
    object dxBarButton3: TdxBarButton
      Action = actCalcExecCount
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actApplyBestFit
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actBasketDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actBasketDeleteExecute
    end
    object actBasketClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actBasketClearExecute
    end
    object actCalcExecCount: TAction
      Caption = 'actCalcExecCount'
      OnExecute = actCalcExecCountExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
