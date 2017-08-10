inherited ViewDescriptions: TViewDescriptions
  Width = 991
  Height = 510
  ExplicitWidth = 991
  ExplicitHeight = 510
  inherited cxGrid: TcxGrid
    Width = 991
    Height = 463
    ExplicitWidth = 991
    ExplicitHeight = 463
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableViewDragDrop
      OnDragOver = cxGridDBBandedTableViewDragOver
      OnStartDrag = cxGridDBBandedTableViewStartDrag
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clComponentType
        end>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnVertSizing = False
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clComponentType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ComponentType'
        Width = 200
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
      DataController.DetailKeyFieldNames = 'IDComponentType'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clComponentName
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsBehavior.RecordScrollMode = rsmByPixel
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Appending = True
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.OnGetHeaderStyle = cxGridDBBandedTableView2StylesGetHeaderStyle
      OnColumnHeaderClick = cxGridDBBandedTableView2ColumnHeaderClick
      OnCustomDrawColumnHeader = cxGridDBBandedTableView2CustomDrawColumnHeader
      Bands = <
        item
        end>
      object clID2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clComponentName: TcxGridDBBandedColumn
        Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090
        DataBinding.FieldName = 'ComponentName'
        SortIndex = 0
        SortOrder = soAscending
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clIDProducer: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'IDProducer'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.DropDownListStyle = lsEditList
        Properties.ListColumns = <>
        Properties.OnNewLookupDisplayText = clIDManufacturerPropertiesNewLookupDisplayText
        Options.SortByDisplayText = isbtOn
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clDescription: TcxGridDBBandedColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'Description'
        Options.Sorting = False
        Width = 200
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clIDComponentType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'IDComponentType'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.DropDownListStyle = lsEditList
        Properties.ListColumns = <>
        Properties.OnCloseUp = clIDComponentTypePropertiesCloseUp
        Properties.OnEditValueChanged = clIDComponentTypePropertiesEditValueChanged
        Properties.OnNewLookupDisplayText = clIDComponentTypePropertiesNewLookupDisplayText
        Options.Sorting = False
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
    Top = 491
    Width = 991
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
    ExplicitTop = 491
    ExplicitWidth = 991
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAdd'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddDescription'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnDelete'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnApplyUpdates'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnRollback'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmExportImport'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnShowDuplicate'
        end>
    end
    object dxbrbtnAdd: TdxBarButton
      Action = actAddType
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnAddDescription: TdxBarButton
      Action = actAddDescription
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnDelete: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnLoad: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnApplyUpdates: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnRollback: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnShowDuplicate: TdxBarButton
      Action = actShowDuplicate
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrsbtmExportImport: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090'/'#1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnLoad'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnExportToExcelDocument'
        end>
    end
    object dxbrbtnExportToExcelDocument: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxbrbtn1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
  end
  inherited ActionList: TActionList
    object actAddType: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      ImageIndex = 1
      OnExecute = actAddTypeExecute
    end
    object actAddDescription: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077
      ImageIndex = 1
      OnExecute = actAddDescriptionExecute
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
    object actShowDuplicate: TAction
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1091#1073#1083#1080#1082#1072#1090#1099
      ImageIndex = 9
      OnExecute = actShowDuplicateExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1103
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1103
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
  end
end
