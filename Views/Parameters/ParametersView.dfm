inherited ViewParameters: TViewParameters
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
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clParameterType
        end>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableViewDataControllerSummaryAfterSummary
      DataController.OnDetailExpanded = cxGridDBBandedTableViewDataControllerDetailExpanded
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Appending = True
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Width = 30
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        DataBinding.FieldName = 'ParameterType'
        PropertiesClassName = 'TcxTextEditProperties'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clOrd: TcxGridDBBandedColumn
        Caption = #1055#1086#1088#1103#1076#1086#1082
        DataBinding.FieldName = 'ord'
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
      DragMode = dmAutomatic
      OnDragDrop = cxGridDBBandedTableView2DragDrop
      OnDragOver = cxGridDBBandedTableView2DragOver
      OnKeyDown = cxGridDBBandedTableViewKeyDown
      OnMouseDown = cxGridDBBandedTableViewMouseDown
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
          OnGetText = cxGridDBBandedTableView2TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems0GetText
          Column = clValue2
        end>
      DataController.Summary.SummaryGroups = <>
      DataController.Summary.OnAfterSummary = cxGridDBBandedTableView2DataControllerSummaryAfterSummary
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Appending = True
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.CellAutoHeight = True
      OptionsView.ExpandButtonsForEmptyDetails = False
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
        SortIndex = 0
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clChecked: TcxGridDBBandedColumn
        Caption = 'X'
        DataBinding.FieldName = 'Checked'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        Properties.ImmediatePost = True
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        BestFitMaxWidth = 20
        HeaderAlignmentHorz = taCenter
        Options.IncSearch = False
        Options.AutoWidthSizable = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Width = 20
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clValue2: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxTextEditProperties'
        BestFitMaxWidth = 200
        MinWidth = 100
        Width = 313
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clCodeLetters: TcxGridDBBandedColumn
        Caption = #1041#1091#1082#1074#1077#1085#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'CodeLetters'
        PropertiesClassName = 'TcxTextEditProperties'
        BestFitMaxWidth = 200
        MinWidth = 60
        Width = 148
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clMeasuringUnit: TcxGridDBBandedColumn
        Caption = #1045#1076#1080#1085#1080#1094#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        DataBinding.FieldName = 'MeasuringUnit'
        PropertiesClassName = 'TcxTextEditProperties'
        BestFitMaxWidth = 200
        MinWidth = 100
        Width = 122
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clTableName: TcxGridDBBandedColumn
        Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'TableName'
        PropertiesClassName = 'TcxTextEditProperties'
        BestFitMaxWidth = 200
        MinWidth = 100
        Width = 168
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        PropertiesClassName = 'TcxTextEditProperties'
        BestFitMaxWidth = 200
        MinWidth = 100
        Width = 514
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clDefinition: TcxGridDBBandedColumn
        Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'Definition'
        PropertiesClassName = 'TcxBlobEditProperties'
        MinWidth = 60
        Options.Sorting = False
        Width = 85
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object clIDParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'IDParameterType'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.DropDownListStyle = lsEditList
        Properties.ListColumns = <>
        Properties.OnCloseUp = clIDParameterTypePropertiesCloseUp
        Properties.OnEditValueChanged = clIDParameterTypePropertiesEditValueChanged
        Properties.OnNewLookupDisplayText = clIDParameterTypePropertiesNewLookupDisplayText
        MinWidth = 100
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object clIDParameterKind: TcxGridDBBandedColumn
        Caption = #1042#1080#1076' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        DataBinding.FieldName = 'IDParameterKind'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.ImmediatePost = True
        Properties.ListColumns = <>
        MinWidth = 80
        Position.BandIndex = 0
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView3: TcxGridDBBandedTableView [2]
      Navigator.Buttons.CustomButtons = <>
      OnEditKeyDown = cxGridDBBandedTableView3EditKeyDown
      DataController.DetailKeyFieldNames = 'IDParameter'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Appending = True
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
      object clID3: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clIdParameter: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IdParameter'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clIDSubParameter: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'IDSubParameter'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.ImmediatePost = True
        Properties.ListColumns = <>
        Properties.OnCloseUp = clIDSubParameterPropertiesCloseUp
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clTranslation: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'Translation'
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
    end
    inherited cxGridLevel: TcxGridLevel
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBBandedTableView2
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBBandedTableView3
        end
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
          ItemName = 'dxbbAddType'
        end
        item
          Visible = True
          ItemName = 'dxbbAddMainParameter'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddSubParameter'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnDelete'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmExportImport'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnCommit'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnRollBack'
        end>
    end
    object dxbrSearch: TdxBar [1]
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
          ItemName = 'dxbbSearch'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManagerBar1: TdxBar [2]
      Caption = 'Duplicate'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 233
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbbAddType: TdxBarButton
      Action = actAddParameterType
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbAddMainParameter: TdxBarButton
      Action = actAddMainParameter
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnDelete: TdxBarButton
      Action = actDeleteEx
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
          ItemName = 'dxbrbtnLoadFromExcelDocument'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnLoadFromExcelSheet'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnExportToExcel'
        end>
    end
    object dxbrbtnLoadFromExcelDocument: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxbrbtnLoadFromExcelSheet: TdxBarButton
      Action = actLoadFromExcelSheet
      Category = 0
    end
    object dxbrbtnExportToExcel: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxbrbtnCommit: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnAddSubParameter: TdxBarButton
      Action = actAddSubParameter
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnRollBack: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbSearch: TdxBarButton
      Action = actSearch
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object cxbeiSearch: TcxBarEditItem
      Caption = #1055#1086#1080#1089#1082':'
      Category = 0
      Hint = #1055#1086#1080#1089#1082':'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxTextEditProperties'
      Properties.ValidationOptions = [evoRaiseException, evoAllowLoseFocus]
      Properties.OnEditValueChanged = cxbeiSearchPropertiesEditValueChanged
      Properties.OnValidate = cxbeiSearchPropertiesValidate
      InternalEditValue = ''
    end
    object dxBarButton1: TdxBarButton
      Action = actShowDuplicate
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actFilterByTableName
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actAddParameterType: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      ImageIndex = 1
      OnExecute = actAddParameterTypeExecute
    end
    object actAddMainParameter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 1
      OnExecute = actAddMainParameterExecute
    end
    object actAddSubParameter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 1
      OnExecute = actAddSubParameterExecute
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
    object actSearch: TAction
      Caption = #1053#1072#1081#1090#1080
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actShowDuplicate: TAction
      Caption = #1042#1089#1077' '#1076#1091#1073#1083#1080#1082#1072#1090#1099
      ImageIndex = 9
      OnExecute = actShowDuplicateExecute
    end
    object actFilterByTableName: TAction
      Caption = #1044#1091#1073#1083#1080#1082#1072#1090#1099
      ImageIndex = 9
      OnExecute = actFilterByTableNameExecute
    end
  end
end
