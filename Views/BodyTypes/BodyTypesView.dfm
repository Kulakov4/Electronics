inherited ViewBodyTypes: TViewBodyTypes
  Width = 942
  Height = 600
  ExplicitWidth = 942
  ExplicitHeight = 600
  inherited cxGrid: TcxGrid
    Top = 56
    Width = 942
    Height = 525
    ExplicitTop = 56
    ExplicitWidth = 942
    ExplicitHeight = 525
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableViewDragDrop
      OnDragOver = cxGridDBBandedTableViewDragOver
      OnStartDrag = cxGridDBBandedTableViewStartDrag
      DataController.KeyFieldNames = 'ID'
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clBodyKind
        end>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      DataController.OnDetailExpanded = cxGridDBBandedTableViewDataControllerDetailExpanded
      OptionsBehavior.CellHints = True
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clBodyKind: TcxGridDBBandedColumn
        Caption = #1058#1080#1087' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'BodyKind'
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clOrd: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Ord'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        SortIndex = 0
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      OnKeyDown = cxGridDBBandedTableView2KeyDown
      OnMouseDown = cxGridDBBandedTableView2MouseDown
      Navigator.Buttons.CustomButtons = <>
      OnEditKeyDown = cxGridDBBandedTableView2EditKeyDown
      DataController.DetailKeyFieldNames = 'IDBodyKind'
      DataController.KeyFieldNames = 'IDS'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clBody
        end>
      DataController.Summary.SummaryGroups = <>
      DataController.OnCompare = cxGridDBBandedTableView2DataControllerCompare
      OptionsBehavior.CellHints = True
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Styles.OnGetHeaderStyle = cxGridDBBandedTableView2StylesGetHeaderStyle
      OnColumnHeaderClick = cxGridDBBandedTableView2ColumnHeaderClick
      OnCustomDrawColumnHeader = cxGridDBBandedTableView2CustomDrawColumnHeader
      Bands = <
        item
        end>
      object clIDS: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDS'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clIDBodyData: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDBodyData'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clBody: TcxGridDBBandedColumn
        Caption = #1050#1086#1088#1087#1091#1089
        DataBinding.FieldName = 'Body'
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clBodyData: TcxGridDBBandedColumn
        Caption = #1050#1086#1088#1087#1091#1089#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
        DataBinding.FieldName = 'BodyData'
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clOutlineDrawing: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'OutlineDrawing'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenOutlineDrawing
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadOutlineDrawing
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clOutlineDrawingGetDataText
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clLandPattern: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
        DataBinding.FieldName = 'LandPattern'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenLandPattern
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadLandPattern
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clOutlineDrawingGetDataText
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clVariations: TcxGridDBBandedColumn
        Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
        DataBinding.FieldName = 'Variations'
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clImage: TcxGridDBBandedColumn
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'Image'
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
        OnGetDataText = clOutlineDrawingGetDataText
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clIDBody: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDBody'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object clIDBodyKind: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'IDBodyKind'
        Visible = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object clIDProducer: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'IDProducer'
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object clJEDEC: TcxGridDBBandedColumn
        Caption = 'JEDEC '#1050#1086#1076
        DataBinding.FieldName = 'JEDEC'
        Position.BandIndex = 0
        Position.ColIndex = 11
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
    Top = 581
    Width = 942
    Panels = <
      item
        Width = 150
      end
      item
        Width = 100
      end
      item
        Width = 150
      end>
    ExplicitTop = 581
    ExplicitWidth = 942
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      56
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxbbAdd'
        end
        item
          Visible = True
          ItemName = 'dxbbAddBody'
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
        end>
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 952
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrsbtmExportImport'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
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
    object dxbbAddBody: TdxBarButton
      Action = actAddBody
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
          ItemName = 'dxbbLoadFromExcelDocument'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnExport'
        end>
    end
    object dxbbLoadFromExcelDocument: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxbrbtnExport: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
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
    object dxBarButton1: TdxBarButton
      Action = actSettings
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actShowDuplicate
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1082#1086#1088#1087#1091#1089#1072
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actAddBody: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1088#1087#1091#1089
      ImageIndex = 1
      OnExecute = actAddBodyExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
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
    object actSettings: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 18
      OnExecute = actSettingsExecute
    end
    object actOpenOutlineDrawing: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
      ImageIndex = 17
      OnExecute = actOpenOutlineDrawingExecute
    end
    object actOpenLandPattern: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
      ImageIndex = 16
      OnExecute = actOpenLandPatternExecute
    end
    object actOpenImage: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 8
      OnExecute = actOpenImageExecute
    end
    object actShowDuplicate: TAction
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1091#1073#1083#1080#1082#1072#1090#1099
      ImageIndex = 9
      OnExecute = actShowDuplicateExecute
    end
    object actLoadOutlineDrawing: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
      ImageIndex = 17
      OnExecute = actLoadOutlineDrawingExecute
    end
    object actLoadLandPattern: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
      ImageIndex = 16
      OnExecute = actLoadLandPatternExecute
    end
    object actLoadImage: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 8
      OnExecute = actLoadImageExecute
    end
  end
end
