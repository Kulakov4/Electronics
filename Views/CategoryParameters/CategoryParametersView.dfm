inherited ViewCategoryParameters: TViewCategoryParameters
  Width = 1037
  ExplicitWidth = 1037
  inherited cxGrid: TcxGrid
    Width = 1037
    OnFocusedViewChanged = cxGridFocusedViewChanged
    ExplicitTop = 56
    ExplicitWidth = 1037
    ExplicitHeight = 416
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnEditing = cxGridDBBandedTableViewEditing
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      DataController.DataSource = dsParameters
      DataController.KeyFieldNames = 'VID'
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = False
      OptionsView.ExpandButtonsForEmptyDetails = False
      OptionsView.HeaderAutoHeight = True
      Styles.OnGetContentStyle = cxGridDBBandedTableViewStylesGetContentStyle
      Styles.OnGetHeaderStyle = nil
      object clVID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'VID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clID: TcxGridDBBandedColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ID'
        Visible = False
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clTableName: TcxGridDBBandedColumn
        Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'TableName'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ParameterType'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clPosID: TcxGridDBBandedColumn
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'PosID'
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        SortIndex = 0
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Ord'
        Visible = False
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        SortIndex = 1
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clIsAttribute: TcxGridDBBandedColumn
        Caption = #1040#1082#1090#1080#1074#1085#1099#1081
        DataBinding.FieldName = 'IsAttribute'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object clIDParameter: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDParameter'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      OnKeyDown = cxGridDBBandedTableView2KeyDown
      OnMouseDown = cxGridDBBandedTableView2MouseDown
      Navigator.Buttons.CustomButtons = <>
      OnEditing = cxGridDBBandedTableView2Editing
      DataController.DataSource = dsSubParameters
      DataController.DetailKeyFieldNames = 'IDParent'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'VID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.BandHeaders = False
      Styles.OnGetContentStyle = cxGridDBBandedTableView2StylesGetContentStyle
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
      object clIDParent: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDParent'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clName: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
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
      object clIsAttribute2: TcxGridDBBandedColumn
        Caption = #1040#1082#1090#1080#1074#1085#1099#1081
        DataBinding.FieldName = 'IsAttribute'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        MinWidth = 50
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clPosID2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'PosID'
        Visible = False
        SortIndex = 0
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clOrd2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Ord'
        Visible = False
        SortIndex = 1
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 6
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
    Width = 1037
    ExplicitWidth = 1037
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
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 1047
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
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
          ItemName = 'dxBarButton19'
        end
        item
          Visible = True
          ItemName = 'dxBarButton20'
        end
        item
          Visible = True
          ItemName = 'dxBarButton21'
        end
        item
          Visible = True
          ItemName = 'dxBarButton22'
        end
        item
          Visible = True
          ItemName = 'dxBarButton23'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = False
      WholeRow = False
    end
    object dxBarButton1: TdxBarButton
      Action = actPosBegin
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actPosEnd
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actPosCenter
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUp
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actDown
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actApplyUpdates
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton7: TdxBarButton
      Action = actCancelUpdates
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton8: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end>
    end
    object dxBarButton9: TdxBarButton
      Action = actAddToBegin
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actAddToCenter
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actAddToEnd
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actAddSubParameter
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton13: TdxBarButton
      Caption = 'Dis coll'
      Category = 0
      Hint = 'Dis coll'
      Visible = ivAlways
      OnClick = dxBarButton13Click
    end
    object dxBarButton14: TdxBarButton
      Caption = 'En coll'
      Category = 0
      Hint = 'En coll'
      Visible = ivAlways
      OnClick = dxBarButton14Click
    end
    object dxBarButton15: TdxBarButton
      Caption = 'BU'
      Category = 0
      Hint = 'BU'
      Visible = ivAlways
      OnClick = dxBarButton15Click
    end
    object dxBarButton16: TdxBarButton
      Caption = 'EU'
      Category = 0
      Hint = 'EU'
      Visible = ivAlways
      OnClick = dxBarButton16Click
    end
    object dxBarButton17: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      OnClick = dxBarButton17Click
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      OnClick = dxBarButton18Click
    end
    object dxBarButton19: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      OnClick = dxBarButton19Click
    end
    object dxBarButton20: TdxBarButton
      Caption = 'DisableSyncMode'
      Category = 0
      Hint = 'DisableSyncMode'
      Visible = ivAlways
      OnClick = dxBarButton20Click
    end
    object dxBarButton21: TdxBarButton
      Caption = 'EnableSyncMode'
      Category = 0
      Hint = 'EnableSyncMode'
      Visible = ivAlways
      OnClick = dxBarButton21Click
    end
    object dxBarButton22: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarButton23: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      OnClick = dxBarButton23Click
    end
  end
  inherited ActionList: TActionList
    object actPosBegin: TAction
      Caption = #1042' '#1085#1072#1095#1072#1083#1086
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1085#1072#1095#1072#1083#1100#1085#1099#1093
      OnExecute = actPosBeginExecute
    end
    object actPosCenter: TAction
      Caption = #1042' '#1089#1077#1088#1077#1076#1080#1085#1091
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1089#1088#1077#1076#1085#1080#1093
      OnExecute = actPosCenterExecute
    end
    object actPosEnd: TAction
      Caption = #1042' '#1082#1086#1085#1077#1094
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1085#1077#1095#1085#1099#1093
      OnExecute = actPosEndExecute
    end
    object actUp: TAction
      Caption = #1042#1074#1077#1088#1093
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1074#1077#1088#1093
      ImageIndex = 37
      OnExecute = actUpExecute
    end
    object actDown: TAction
      Caption = #1042#1085#1080#1079
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1085#1080#1079
      ImageIndex = 38
      OnExecute = actDownExecute
    end
    object actApplyUpdates: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 3
      OnExecute = actApplyUpdatesExecute
    end
    object actCancelUpdates: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1089#1076#1077#1083#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 14
      OnExecute = actCancelUpdatesExecute
    end
    object actAddToBegin: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1085#1072#1095#1072#1083#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1085#1072#1095#1072#1083#1100#1085#1099#1093
      ImageIndex = 1
      OnExecute = actAddToBeginExecute
    end
    object actAddToCenter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1089#1077#1088#1077#1076#1080#1085#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1089#1088#1077#1076#1085#1080#1093
      ImageIndex = 1
      OnExecute = actAddToCenterExecute
    end
    object actAddToEnd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1082#1086#1085#1077#1094
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1085#1077#1095#1085#1099#1093
      ImageIndex = 1
      OnExecute = actAddToEndExecute
    end
    object actAddSubParameter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 1
      OnExecute = actAddSubParameterExecute
    end
    object actRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 26
      OnExecute = actRefreshExecute
    end
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 594
    Top = 120
    PixelsPerInch = 96
    object cxStyleBegin: TcxStyle
      AssignedValues = [svColor]
      Color = 16113353
    end
    object cxStyleEnd: TcxStyle
      AssignedValues = [svColor]
      Color = 13431295
    end
  end
  object dsParameters: TDataSource
    Left = 248
    Top = 312
  end
  object dsSubParameters: TDataSource
    Left = 248
    Top = 368
  end
end
