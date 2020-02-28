inherited ViewProductsBase2: TViewProductsBase2
  Width = 1177
  Height = 598
  ExplicitWidth = 1177
  ExplicitHeight = 598
  inherited cxDBTreeList: TcxDBTreeList
    Top = 56
    Width = 1177
    Height = 523
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
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      end>
    DataController.ParentField = 'IDComponentGroup'
    DataController.KeyField = 'ID'
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    OptionsBehavior.ImmediateEditor = False
    OptionsCustomizing.ColumnMoving = False
    OptionsCustomizing.NestedBands = False
    OptionsCustomizing.StackedColumns = False
    OptionsView.Bands = True
    OptionsView.CategorizedColumn = clValue
    OptionsView.Footer = True
    OptionsView.GridLines = tlglBoth
    OptionsView.HeaderAutoHeight = True
    OptionsView.PaintStyle = tlpsCategorized
    OptionsView.TreeLineStyle = tllsNone
    Styles.OnGetBandHeaderStyle = nil
    OnAfterSummary = cxDBTreeListAfterSummary
    OnBandHeaderClick = cxDBTreeListBandHeaderClick
    OnColumnHeaderClick = cxDBTreeListColumnHeaderClick
    OnExpanded = cxDBTreeListExpanded
    OnInitEditValue = cxDBTreeListInitEditValue
    OnIsGroupNode = cxDBTreeListIsGroupNode
    OnSelectionChanged = cxDBTreeListSelectionChanged
    ExplicitTop = 56
    ExplicitWidth = 1177
    ExplicitHeight = 523
    object clID: TcxDBTreeListColumn
      Visible = False
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'ID'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIsGroup: TcxDBTreeListColumn
      Visible = False
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'IsGroup'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDComponentGroup: TcxDBTreeListColumn
      Visible = False
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'IDComponentGroup'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clValue: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Value'
      Options.VertSizing = False
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      SortOrder = soAscending
      SortIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStoreHouseID: TcxDBTreeListColumn
      Caption.Text = ' '
      DataBinding.FieldName = 'StorehouseId'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDProducer: TcxDBTreeListColumn
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.ListColumns = <>
      Properties.OnNewLookupDisplayText = clIDProducerPropertiesNewLookupDisplayText
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'IDProducer'
      Options.VertSizing = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 2
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDescription: TcxDBTreeListColumn
      PropertiesClassName = 'TcxPopupEditProperties'
      Properties.OnInitPopup = clDescriptionPropertiesInitPopup
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'DescriptionComponentName'
      Options.VertSizing = False
      Options.Sorting = False
      Width = 100
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 3
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDatasheet: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Action = actOpenDatasheet
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actLoadDatasheet
          Kind = bkEllipsis
        end>
      Properties.Images = DMRepository.cxImageList
      Caption.AlignHorz = taCenter
      Caption.ShowEndEllipsis = False
      Caption.Text = ' '
      DataBinding.FieldName = 'Datasheet'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 4
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
      OnGetDisplayText = clDatasheetGetDisplayText
    end
    object clDiagram: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Action = actOpenDiagram
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actLoadDiagram
          Kind = bkEllipsis
        end>
      Properties.Images = DMRepository.cxImageList
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Diagram'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 5
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
      OnGetDisplayText = clDatasheetGetDisplayText
    end
    object clDrawing: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Action = actOpenDrawing
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actLoadDrawing
          Kind = bkEllipsis
        end>
      Properties.Images = DMRepository.cxImageList
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Drawing'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 6
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
      OnGetDisplayText = clDatasheetGetDisplayText
    end
    object clImage: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Action = actOpenImage
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actLoadImage
          Kind = bkEllipsis
        end>
      Properties.Images = DMRepository.cxImageList
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Image'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 7
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
      OnGetDisplayText = clDatasheetGetDisplayText
    end
    object clPackagePins: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'PackagePins'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 8
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clReleaseDate: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'ReleaseDate'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 9
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clAmount: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Amount'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 10
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPackaging: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Packaging'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 11
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR2: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR2'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 12
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD2: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD2'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 12
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR1'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 13
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD1'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 13
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 14
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 14
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountryCode: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      DataBinding.FieldName = 'OriginCountryCode'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 15
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountry: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'OriginCountry'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 15
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBatchNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'BatchNumber'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 16
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clCustomsDeclarationNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'CustomsDeclarationNumber'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 17
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStorage: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1057#1090#1077#1083#1083#1072#1078' '#8470
      DataBinding.FieldName = 'Storage'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 18
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStoragePlace: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1052#1077#1089#1090#1086' '#8470
      DataBinding.FieldName = 'StoragePlace'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 18
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSeller: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Seller'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 19
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDocumentNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'DocumentNumber'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 20
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBarcode: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Barcode'
      Options.VertSizing = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 21
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDCurrency: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'IDCurrency'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 2
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clChecked: TcxDBTreeListColumn
      Visible = False
      Caption.Text = 'X'
      DataBinding.FieldName = 'Checked'
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceE: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8364
      DataBinding.FieldName = 'PriceE'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 14
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceE1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8364
      DataBinding.FieldName = 'PriceE1'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 13
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceE2: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8364
      DataBinding.FieldName = 'PriceE2'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 12
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clLoadDate: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'LoadDate'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 22
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDollar: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'Dollar'
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 23
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clEuro: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8364
      DataBinding.FieldName = 'Euro'
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 23
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSaleCount: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'SaleCount'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 24
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          Kind = skSum
        end>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSaleR: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'SaleR'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 25
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          Kind = skSum
        end>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSaleD: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'SaleD'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 25
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          Kind = skSum
        end>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSaleE: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8364
      DataBinding.FieldName = 'SaleE'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 25
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          Kind = skSum
        end>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  inherited StatusBar: TStatusBar
    Top = 579
    Width = 1177
    ExplicitTop = 579
    ExplicitWidth = 1177
  end
  inherited dxBarManager: TdxBarManager
    ShowHint = False
    UseSystemFont = False
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      56
      0)
    inherited dxBarManagerBar1: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'cxbeiDate'
        end
        item
          Visible = True
          ItemName = 'cxbeiDollar'
        end
        item
          Visible = True
          ItemName = 'cxbeiEuro'
        end
        item
          Visible = True
          ItemName = 'dxbbRefreshCources'
        end
        item
          Visible = True
          ItemName = 'dxbbCreateBill'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end>
    end
    object dxBarManagerBar2: TdxBar [1]
      Caption = 'Price'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 1102
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxbeiExtraChargeType'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 84
          Visible = True
          ItemName = 'cxbeiExtraCharge'
        end
        item
          Visible = True
          ItemName = 'dxbcWholeSale'
        end
        item
          Visible = True
          ItemName = 'dxbcMinWholeSale'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 74
          Visible = True
          ItemName = 'dxbcRetail'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = True
      Visible = True
      WholeRow = False
    end
    object dxbcRetail: TdxBarCombo
      Caption = #1056#1086#1079#1085'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1056#1086#1079#1085'. '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcRetailChange
      ShowCaption = True
      Width = 70
      Text = '100'
      OnDrawItem = dxbcRetailDrawItem
      Items.Strings = (
        '5'
        '10'
        '15'
        '20'
        '25'
        '30'
        '35'
        '40'
        '45'
        '50'
        '55'
        '60'
        '65'
        '70'
        '75'
        '80'
        '85'
        '90'
        '95'
        '100')
      ItemIndex = -1
    end
    object cxbeiDollar: TcxBarEditItem
      Caption = #1050#1091#1088#1089' $'
      Category = 0
      Hint = #1050#1091#1088#1089' $'
      Visible = ivAlways
      OnChange = cxbeiDollarChange
      ShowCaption = True
      Width = 70
      PropertiesClassName = 'TcxMaskEditProperties'
      Properties.BeepOnError = True
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '(\d+\,?\d?\d?\d?\d?)'
      Properties.OnValidate = cxbeiDollarPropertiesValidate
    end
    object dxbbRefreshCources: TdxBarButton
      Action = actRefreshCources
      Category = 0
    end
    object cxbeiEuro: TcxBarEditItem
      Caption = #1050#1091#1088#1089' '#8364
      Category = 0
      Hint = #1050#1091#1088#1089' '#8364
      Visible = ivAlways
      OnChange = cxbeiEuroChange
      ShowCaption = True
      Width = 70
      PropertiesClassName = 'TcxMaskEditProperties'
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '(\d+\,?\d?\d?\d?\d?)'
      Properties.OnValidate = cxbeiDollarPropertiesValidate
    end
    object cxbeiExtraCharge: TcxBarEditItem
      Caption = #1050#1086#1083'-'#1074#1086
      Category = 0
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090'.'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxPopupEditProperties'
      Properties.PopupAutoSize = False
      Properties.PopupHeight = 300
      Properties.PopupMinWidth = 350
      Properties.PopupSysPanelStyle = True
      Properties.PopupWidth = 400
      Properties.ReadOnly = True
    end
    object dxbcWholeSale: TdxBarCombo
      Caption = #1054#1087#1090'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1054#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcWholeSaleChange
      ShowCaption = True
      Width = 70
      OnDrawItem = dxbcRetailDrawItem
      Items.Strings = (
        '')
      ItemIndex = -1
    end
    object cxbeiExtraChargeType: TcxBarEditItem
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Category = 0
      Hint = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.ListColumns = <>
      Properties.ListOptions.ShowHeader = False
      Properties.OnChange = cxbeiExtraChargeTypePropertiesChange
    end
    object dxbcMinWholeSale: TdxBarCombo
      Caption = #1052#1080#1085'. '#1086#1087#1090'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1086#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcMinWholeSaleChange
      ShowCaption = True
      Width = 70
      Text = '10'
      OnDrawItem = dxbcRetailDrawItem
      Items.Strings = (
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15')
      ItemIndex = 2
    end
    object dxBarButton11: TdxBarButton
      Action = actClearPrice
      Category = 0
    end
    object dxbbCreateBill: TdxBarButton
      Action = actCreateBill
      Category = 0
    end
    object cxbeiDate: TcxBarEditItem
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      Category = 0
      Hint = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
    end
    object cxbeiTotalR: TcxBarEditItem
      Caption = #1048#1090#1086#1075#1086':'
      Category = 0
      Hint = #1048#1090#1086#1075#1086':'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxCurrencyEditProperties'
    end
    object dxbbRubToDollar: TdxBarButton
      Action = actRubToDollar
      Category = 0
      ButtonStyle = bsChecked
    end
  end
  inherited ActionList: TActionList
    Images = DMRepository.cxImageList
    object actCommit: TAction [0]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction [1]
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1072' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actOpenInParametricTable: TAction [2]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 34
      OnExecute = actOpenInParametricTableExecute
    end
    object actAddCategory: TAction [3]
      Caption = #1043#1088#1091#1087#1087#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      ImageIndex = 1
      OnExecute = actAddCategoryExecute
    end
    object actAddComponent: TAction [4]
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      ImageIndex = 1
      OnExecute = actAddComponentExecute
    end
    object actDelete: TAction [5]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actOpenDatasheet: TAction [6]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      ImageIndex = 7
      OnExecute = actOpenDatasheetExecute
    end
    object actLoadDatasheet: TAction [7]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      OnExecute = actLoadDatasheetExecute
    end
    object actOpenImage: TAction [8]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 8
      OnExecute = actOpenImageExecute
    end
    object actLoadImage: TAction [9]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      OnExecute = actLoadImageExecute
    end
    object actOpenDiagram: TAction [10]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      ImageIndex = 16
      OnExecute = actOpenDiagramExecute
    end
    object actLoadDiagram: TAction [11]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1093#1077#1084#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1093#1077#1084#1091
      OnExecute = actLoadDiagramExecute
    end
    object actOpenDrawing: TAction [12]
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      ImageIndex = 17
      OnExecute = actOpenDrawingExecute
    end
    object actLoadDrawing: TAction [13]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      OnExecute = actLoadDrawingExecute
    end
    inherited actCopy: TAction
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
    end
    object actRefreshCources: TAction
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1082#1091#1088#1089#1086#1074' '#1074#1072#1083#1102#1090
      Hint = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1082#1091#1088#1089#1086#1074' '#1074#1072#1083#1102#1090
      ImageIndex = 26
      OnExecute = actRefreshCourcesExecute
    end
    object actBandWidth: TAction
      Caption = #1064#1080#1088#1080#1085#1072' '#1073#1101#1085#1076#1072
      OnExecute = actBandWidthExecute
    end
    object actColumnAutoWidth: TAction
      Caption = #1040#1074#1090#1086#1096#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1082#1080
      OnExecute = actColumnAutoWidthExecute
    end
    object actColumnWidth: TAction
      Caption = #1064#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1082#1080
      OnExecute = actColumnWidthExecute
    end
    object actApplyBestFit: TAction
      Caption = #1054#1087#1090#1080#1084#1072#1083#1100#1085#1072#1103' '#1096#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1086#1082
      Hint = #1055#1086#1076#1086#1073#1088#1072#1090#1100' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1091#1102' '#1096#1080#1088#1080#1085#1091' '#1082#1086#1083#1086#1085#1086#1082
      ImageIndex = 13
      OnExecute = actApplyBestFitExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1089#1082#1083#1072#1076#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1105' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1089#1082#1083#1072#1076#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actColumnFilter: TAction
      Caption = #1056#1072#1079#1088#1077#1096#1105#1085' '#1083#1080' '#1092#1080#1083#1100#1090#1088
      OnExecute = actColumnFilterExecute
    end
    object actClearPrice: TAction
      Caption = #1054#1095#1080#1089#1090#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081
      Hint = #1054#1095#1080#1089#1090#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081
      ImageIndex = 10
      OnExecute = actClearPriceExecute
    end
    object actCreateBill: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1105#1090
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1105#1090
      ImageIndex = 45
      OnExecute = actCreateBillExecute
    end
    object actClearSelection: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 46
      OnExecute = actClearSelectionExecute
    end
    object actRubToDollar: TAction
      Caption = #8381'-$'
      Hint = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' '#1079#1072#1082#1091#1087#1086#1095#1085#1099#1077' '#1094#1077#1085#1099' '#1074' '#8381' '#1082' '#1082#1091#1088#1089#1091'$'
      OnExecute = actRubToDollarExecute
    end
    object actCopyColumnHeader: TAction
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1079#1072#1075#1086#1083#1086#1074#1082#1072
      OnExecute = actCopyColumnHeaderExecute
    end
  end
  inherited PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    object N5: TMenuItem
      Action = actCopyColumnHeader
    end
    object N2: TMenuItem
      Action = actBandWidth
      Visible = False
    end
    object N4: TMenuItem
      Action = actColumnWidth
      Visible = False
    end
    object N3: TMenuItem
      Action = actColumnAutoWidth
      Visible = False
    end
    object actColumnFilter1: TMenuItem
      Action = actColumnFilter
      Visible = False
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 200
    Top = 264
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = clHighlight
    end
    object cxNormalStyle: TcxStyle
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = clGrayText
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor]
      Color = clGreen
    end
    object cxslFocusedColumn: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clHighlight
      TextColor = clHighlightText
    end
    object cxslSelectedColumn: TcxStyle
      AssignedValues = [svColor]
      Color = clInfoBk
    end
    object cxslOtherColumn: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clWindow
      TextColor = clWindowText
    end
    object cxslHighlited: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 10092441
      TextColor = clBlack
    end
    object cxslSelectedColumn2: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clHighlight
      TextColor = clHighlightText
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 72
    Top = 200
  end
end
