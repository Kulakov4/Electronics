inherited ViewProductsBase2: TViewProductsBase2
  Width = 1092
  Height = 598
  ExplicitWidth = 1092
  ExplicitHeight = 598
  inherited cxDBTreeList: TcxDBTreeList
    Top = 54
    Width = 1092
    Height = 544
    Bands = <
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        FixedKind = tlbfLeft
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      end
      item
        Caption.AlignHorz = taCenter
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
        Caption.Text = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1047#1072#1082#1091#1087#1086#1095#1085#1072#1103' '#1094#1077#1085#1072
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
        Caption.Text = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103' '#1087#1088#1086#1076#1072#1074#1077#1094
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      end>
    DataController.ParentField = 'IDComponentGroup'
    DataController.KeyField = 'ID'
    OptionsSelection.MultiSelect = True
    OptionsView.Bands = True
    OptionsView.CategorizedColumn = clValue
    OptionsView.PaintStyle = tlpsCategorized
    OnFocusedNodeChanged = cxDBTreeListFocusedNodeChanged
    OnIsGroupNode = cxDBTreeListIsGroupNode
    ExplicitTop = 54
    ExplicitWidth = 1092
    ExplicitHeight = 544
    object clID: TcxDBTreeListColumn
      Visible = False
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'ID'
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
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDProducer: TcxDBTreeListColumn
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.ListColumns = <>
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'IDProducer'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDescription: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Description'
      Width = 100
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 2
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
      Caption.Text = ' '
      DataBinding.FieldName = 'Datasheet'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 3
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
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 4
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
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
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 5
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
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
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 6
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPackagePins: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'PackagePins'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 7
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clYYYY: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'YYYY'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 8
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clMM: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'MM'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 8
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clWW: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      DataBinding.FieldName = 'WW'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 8
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clAmount: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Amount'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 9
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPackaging: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Packaging'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 10
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR2: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR2'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 11
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD2: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD2'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 11
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR1'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 12
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD1'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 12
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceR: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #8381
      DataBinding.FieldName = 'PriceR'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 13
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPriceD: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = '$'
      DataBinding.FieldName = 'PriceD'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 13
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountryCode: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      DataBinding.FieldName = 'OriginCountryCode'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 14
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountry: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'OriginCountry'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 14
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBatchNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'BatchNumber'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 15
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clCustomsDeclarationNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'CustomsDeclarationNumber'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 16
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStorage: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1057#1090#1077#1083#1083#1072#1078' '#8470
      DataBinding.FieldName = 'Storage'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 17
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStoragePlace: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = #1052#1077#1089#1090#1086' '#8470
      DataBinding.FieldName = 'StoragePlace'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 17
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSeller: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Seller'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 18
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clDocumentNumber: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'DocumentNumber'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 19
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBarcode: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.Text = ' '
      DataBinding.FieldName = 'Barcode'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 20
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      54
      0)
    inherited dxBarManagerBar1: TdxBar
      Images = DMRepository.cxImageList
    end
    object dxBarManagerBar2: TdxBar
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
      ItemLinks = <
        item
          UserDefine = [udWidth]
          UserWidth = 97
          Visible = True
          ItemName = 'cxbeiRate'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 80
          Visible = True
          ItemName = 'dxbcRate2'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 74
          Visible = True
          ItemName = 'dxbcRate1'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbcRate1: TdxBarCombo
      Caption = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcRate1Change
      ShowCaption = True
      Text = '100'
      OnDrawItem = dxbcRate1DrawItem
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
    object dxbcRate2: TdxBarCombo
      Caption = #1054#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1054#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcRate2Change
      ShowCaption = True
      Text = '100'
      OnDrawItem = dxbcRate1DrawItem
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
    object cxbeiRate: TcxBarEditItem
      Caption = #1050#1091#1088#1089' $'
      Category = 0
      Hint = #1050#1091#1088#1089' $'
      Visible = ivAlways
      OnChange = cxbeiRateChange
      ShowCaption = True
      PropertiesClassName = 'TcxCalcEditProperties'
    end
  end
  inherited ActionList: TActionList
    Images = DMRepository.cxImageList
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1072' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1042' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actOpenInParametricTable: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 34
      OnExecute = actOpenInParametricTableExecute
    end
    object actAddCategory: TAction
      Caption = #1043#1088#1091#1087#1087#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      ImageIndex = 1
      OnExecute = actAddCategoryExecute
    end
    object actAddComponent: TAction
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090
      ImageIndex = 1
      OnExecute = actAddComponentExecute
    end
    object actDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actOpenDatasheet: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      ImageIndex = 7
      OnExecute = actOpenDatasheetExecute
    end
    object actLoadDatasheet: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      OnExecute = actLoadDatasheetExecute
    end
    object actOpenImage: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 8
      OnExecute = actOpenImageExecute
    end
    object actLoadImage: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      OnExecute = actLoadImageExecute
    end
    object actOpenDiagram: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      ImageIndex = 16
      OnExecute = actOpenDiagramExecute
    end
    object actLoadDiagram: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1080#1072#1075#1088#1072#1084#1084#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1080#1072#1075#1088#1072#1084#1084#1091
      OnExecute = actLoadDiagramExecute
    end
    object actOpenDrawing: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      ImageIndex = 17
      OnExecute = actOpenDrawingExecute
    end
    object actLoadDrawing: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      OnExecute = actLoadDrawingExecute
    end
  end
end
