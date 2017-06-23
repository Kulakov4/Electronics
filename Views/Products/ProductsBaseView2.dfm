inherited ViewProductsBase2: TViewProductsBase2
  Width = 641
  Height = 410
  ExplicitWidth = 641
  ExplicitHeight = 410
  inherited cxDBTreeList: TcxDBTreeList
    Width = 641
    Height = 382
    Bands = <
      item
        FixedKind = tlbfLeft
      end
      item
      end
      item
        Caption.Text = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
      end
      item
      end
      item
        Caption.Text = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      end
      item
      end>
    DataController.ParentField = 'IDComponentGroup'
    DataController.KeyField = 'ID'
    OptionsView.Bands = True
    OptionsView.CategorizedColumn = clValue
    OptionsView.PaintStyle = tlpsCategorized
    OnEdited = cxDBTreeListEdited
    OnFocusedNodeChanged = cxDBTreeListFocusedNodeChanged
    OnIsGroupNode = cxDBTreeListIsGroupNode
    ExplicitLeft = 0
    ExplicitTop = 28
    ExplicitWidth = 641
    ExplicitHeight = 382
    object clID: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ID'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clValue: TcxDBTreeListColumn
      Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'Value'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDProducer: TcxDBTreeListColumn
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.ListColumns = <>
      Caption.Text = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      DataBinding.FieldName = 'IDProducer'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIsGroup: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'IsGroup'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clIDComponentGroup: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'IDComponentGroup'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPackagePins: TcxDBTreeListColumn
      Caption.Text = #1050#1086#1088#1087#1091#1089
      DataBinding.FieldName = 'PackagePins'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clAmount: TcxDBTreeListColumn
      Caption.Text = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      DataBinding.FieldName = 'Amount'
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clPackaging: TcxDBTreeListColumn
      Caption.Text = #1059#1087#1072#1082#1086#1074#1082#1072
      DataBinding.FieldName = 'Packaging'
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountry: TcxDBTreeListColumn
      Caption.Text = #1053#1072#1079#1074#1072#1085#1080#1077
      DataBinding.FieldName = 'OriginCountry'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 2
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOriginCountryCode: TcxDBTreeListColumn
      Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      DataBinding.FieldName = 'OriginCountryCode'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 2
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBatchNumber: TcxDBTreeListColumn
      Caption.Text = #1053#1086#1084#1077#1088' '#1087#1072#1088#1090#1080#1080
      DataBinding.FieldName = 'BatchNumber'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 3
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clCustomsDeclarationNumber: TcxDBTreeListColumn
      Caption.Text = #1053#1086#1084#1077#1088' '#1090#1072#1084#1086#1078#1077#1085#1085#1086#1081' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1080
      DataBinding.FieldName = 'CustomsDeclarationNumber'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 3
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStorage: TcxDBTreeListColumn
      Caption.Text = #1057#1090#1077#1083#1083#1072#1078' '#8470
      DataBinding.FieldName = 'Storage'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 4
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clStoragePlace: TcxDBTreeListColumn
      Caption.Text = #1052#1077#1089#1090#1086' '#8470
      DataBinding.FieldName = 'StoragePlace'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 4
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clSeller: TcxDBTreeListColumn
      Caption.Text = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103' '#1087#1088#1086#1076#1072#1074#1077#1094
      DataBinding.FieldName = 'Seller'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 5
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clBarcode: TcxDBTreeListColumn
      Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076' ('#1096#1090#1088#1080#1093'-'#1082#1086#1076')'
      DataBinding.FieldName = 'Barcode'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 5
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxBarManagerBar1: TdxBar
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actAddCategory
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton2: TdxBarButton
      Action = actAddComponent
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actDelete
      Category = 0
      PaintStyle = psCaptionGlyph
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
  end
end
