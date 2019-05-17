inherited ViewParameters2: TViewParameters2
  inherited cxGrid: TcxGrid
    Top = 56
    Height = 416
    ExplicitTop = 56
    ExplicitHeight = 416
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableViewDragDrop
      OnDragOver = cxGridDBBandedTableViewDragOver
      OnStartDrag = cxGridDBBandedTableViewStartDrag
      DataController.KeyFieldNames = 'ID'
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clParameterType
        end>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      OptionsBehavior.IncSearch = True
      OptionsBehavior.ImmediateEditor = False
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        DataBinding.FieldName = 'ParameterType'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clOrd: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Ord'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableView2DragDrop
      OnDragOver = cxGridDBBandedTableView2DragOver
      OnKeyDown = cxGridDBBandedTableView2KeyDown
      OnMouseDown = cxGridDBBandedTableView2MouseDown
      OnStartDrag = cxGridDBBandedTableView2StartDrag
      Navigator.Buttons.CustomButtons = <>
      OnEditKeyDown = cxGridDBBandedTableView2EditKeyDown
      DataController.DetailKeyFieldNames = 'IDParameterType'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clValue
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsBehavior.ImmediateEditor = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.BandHeaders = False
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
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Order'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clChecked: TcxGridDBBandedColumn
        Caption = 'X'
        DataBinding.FieldName = 'Checked'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        Properties.OnEditValueChanged = clCheckedPropertiesEditValueChanged
        Visible = False
        BestFitMaxWidth = 30
        VisibleForCustomization = False
        Width = 25
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clCodeLetters: TcxGridDBBandedColumn
        Caption = #1041#1091#1082#1074#1077#1085#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'CodeLetters'
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clMeasuringUnit: TcxGridDBBandedColumn
        Caption = #1045#1076#1080#1085#1080#1094#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        DataBinding.FieldName = 'MeasuringUnit'
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clTableName: TcxGridDBBandedColumn
        Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'TableName'
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clDefinition: TcxGridDBBandedColumn
        Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'Definition'
        PropertiesClassName = 'TcxBlobEditProperties'
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object clIDParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'IDParameterType'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.DropDownSizeable = True
        Properties.DropDownWidth = 300
        Properties.ListColumns = <>
        Properties.OnCloseUp = clIDParameterTypePropertiesCloseUp
        Properties.OnEditValueChanged = clIDParameterTypePropertiesEditValueChanged
        Properties.OnNewLookupDisplayText = clIDParameterTypePropertiesNewLookupDisplayText
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object clIDParameterKind: TcxGridDBBandedColumn
        Caption = #1042#1080#1076' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        DataBinding.FieldName = 'IDParameterKind'
        Position.BandIndex = 0
        Position.ColIndex = 10
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
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end>
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = 'Search'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 903
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxbeiSearch'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton20'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar3: TdxBar [2]
      Caption = 'Test'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 56
      DockingStyle = dsTop
      FloatLeft = 903
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      OneOnRow = True
      Row = 2
      UseOwnFont = False
      Visible = False
      WholeRow = False
    end
    object dxBarManagerBar4: TdxBar [3]
      Caption = 'Duplicate2'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 257
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 373
      FloatTop = 104
      FloatClientWidth = 89
      FloatClientHeight = 72
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbbClearFilter'
        end
        item
          Visible = True
          ItemName = 'dxbbAllDuplicate'
        end
        item
          Visible = True
          ItemName = 'dxbbDuplicate'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarButton1: TdxBarButton
      Action = actExpand
      Category = 0
    end
    object cxbeiSearch: TcxBarEditItem
      Caption = #1055#1086#1080#1089#1082':'
      Category = 0
      Hint = #1055#1086#1080#1089#1082
      Visible = ivAlways
      OnEnter = cxbeiSearchEnter
      ShowCaption = True
      PropertiesClassName = 'TcxTextEditProperties'
      Properties.OnChange = cxbeiSearchPropertiesChange
      Properties.OnEditValueChanged = cxbeiSearchPropertiesEditValueChanged
    end
    object dxBarButton2: TdxBarButton
      Action = actSearch
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actAddParameterType
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actAddParameter
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton5: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090'/'#1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end>
    end
    object dxBarButton6: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actLoadFromExcelSheet
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton10: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton13: TdxBarButton
      Action = actDisableControls
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = actReopen
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = actEnableControls
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = actCheckDetailView
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = actApplyBestFit
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = actDeleteParameterType
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = actClearSelection
      Category = 0
    end
    object dxBarButton20: TdxBarButton
      Action = actPaste
      Category = 0
    end
    object dxbbClearFilter: TdxBarButton
      Action = actClearFilter
      Category = 0
      ButtonStyle = bsChecked
      DropDownEnabled = False
      GroupIndex = 1
    end
    object dxbbAllDuplicate: TdxBarButton
      Action = actAllDuplicate
      Category = 0
      ButtonStyle = bsChecked
      DropDownEnabled = False
      GroupIndex = 1
    end
    object dxbbDuplicate: TdxBarButton
      Action = actDuplicate
      Category = 0
      ButtonStyle = bsChecked
      DropDownEnabled = False
      GroupIndex = 1
    end
  end
  inherited ActionList: TActionList
    object actAddParameterType: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      ImageIndex = 1
      OnExecute = actAddParameterTypeExecute
    end
    object actAddParameter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 1
      OnExecute = actAddParameterExecute
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
    object actExpand: TAction
      Caption = 'actRefresh'
      OnExecute = actExpandExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actLoadFromExcelSheet: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1083#1080#1089#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actLoadFromExcelSheetExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actSearch: TAction
      Caption = #1053#1072#1081#1090#1080
      Hint = #1055#1086#1080#1089#1082
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actDisableControls: TAction
      Caption = 'actDisableControls'
      OnExecute = actDisableControlsExecute
    end
    object actEnableControls: TAction
      Caption = 'actEnableControls'
      OnExecute = actEnableControlsExecute
    end
    object actReopen: TAction
      Caption = 'actReopen'
      OnExecute = actReopenExecute
    end
    object actCheckDetailView: TAction
      Caption = 'actCheckDetailView'
      OnExecute = actCheckDetailViewExecute
    end
    object actApplyBestFit: TAction
      Caption = 'actApplyBestFit'
      ImageIndex = 13
      OnExecute = actApplyBestFitExecute
    end
    object actDeleteParameterType: TAction
      Caption = 'actDeleteParameterType'
      OnExecute = actDeleteParameterTypeExecute
    end
    object actClearSelection: TAction
      Caption = 'actClearSelection'
      OnExecute = actClearSelectionExecute
    end
    object actPaste: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      OnExecute = actPasteExecute
    end
    object actClearFilter: TAction
      Caption = #1041#1077#1079' '#1092#1080#1083#1100#1090#1088#1072
      Checked = True
      GroupIndex = 1
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1079#1072#1087#1080#1089#1080
      OnExecute = actClearFilterExecute
    end
    object actAllDuplicate: TAction
      Caption = #1042#1089#1077' '#1076#1091#1073#1083#1080#1082#1072#1090#1099
      GroupIndex = 1
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1076#1091#1073#1083#1080#1088#1091#1102#1097#1080#1077#1089#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      OnExecute = actAllDuplicateExecute
    end
    object actDuplicate: TAction
      Caption = #1044#1091#1073#1083#1080#1082#1072#1090
      GroupIndex = 1
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1091#1073#1083#1080#1082#1072#1090' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
      OnExecute = actDuplicateExecute
    end
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 184
    Top = 256
    PixelsPerInch = 96
    object cxStyleNotFound: TcxStyle
      AssignedValues = [svColor]
      Color = 8421631
    end
  end
end
