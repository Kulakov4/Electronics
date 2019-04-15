inherited ViewProducers: TViewProducers
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableViewDragDrop
      OnDragOver = cxGridDBBandedTableViewDragOver
      OnStartDrag = cxGridDBBandedTableViewStartDrag
      DataController.KeyFieldNames = 'ID'
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clProducerType
        end>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      OptionsBehavior.CellHints = True
      OptionsView.HeaderAutoHeight = True
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clProducerType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ProducerType'
        MinWidth = 100
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Ord'
        Visible = False
        SortIndex = 0
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      OnKeyDown = cxGridDBBandedTableViewKeyDown
      OnMouseDown = cxGridDBBandedTableViewMouseDown
      Navigator.Buttons.CustomButtons = <>
      OnEditKeyDown = cxGridDBBandedTableView2EditKeyDown
      DataController.DetailKeyFieldNames = 'ProducerTypeID'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clName2
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.CellHints = True
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.CellEndEllipsis = True
      OptionsView.CellAutoHeight = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.OnGetHeaderStyle = cxGridDBBandedTableView2StylesGetHeaderStyle
      Bands = <
        item
        end>
      object clID2: TcxGridDBBandedColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clName2: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        BestFitMaxWidth = 350
        MinWidth = 100
        SortIndex = 0
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clProducts2: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
        DataBinding.FieldName = 'Products'
        PropertiesClassName = 'TcxMemoProperties'
        BestFitMaxWidth = 350
        MinWidth = 100
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clCount2: TcxGridDBBandedColumn
        Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074' '#1074' '#1041#1044
        DataBinding.FieldName = 'Cnt'
        MinWidth = 60
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clProducerTypeID: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ProducerTypeID'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.ListColumns = <>
        Properties.OnCloseUp = clProducerTypeIDPropertiesCloseUp
        Properties.OnEditValueChanged = clProducerTypeIDPropertiesEditValueChanged
        Properties.OnNewLookupDisplayText = clProducerTypeIDPropertiesNewLookupDisplayText
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
    end
    inherited cxGridLevel: TcxGridLevel
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBBandedTableView2
      end
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 150
      end>
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
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
          ItemName = 'dxbbAdd'
        end
        item
          Visible = True
          ItemName = 'dxbbDelete'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnCommit'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnRollback'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmExportImport'
        end>
    end
    object dxbbAdd: TdxBarButton
      Action = actAdd
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbDelete: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnCommit: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnRollback: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrsbtmExportImport: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090'/'#1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnExport'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnImport'
        end>
    end
    object dxbrbtnExport: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxbrbtnImport: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actAddType
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actAddType: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      ImageIndex = 1
      OnExecute = actAddTypeExecute
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actRefresh: TAction
      Caption = 'actRefresh'
      OnExecute = actRefreshExecute
    end
  end
end
