inherited ViewComponentsBase: TViewComponentsBase
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnCellClick = cxGridDBBandedTableViewCellClick
      OnEditKeyUp = cxGridDBBandedTableViewEditKeyUp
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      OptionsCustomize.ColumnVertSizing = False
      OptionsView.NavigatorOffset = 0
      OptionsView.IndicatorWidth = 0
      OnColumnHeaderClick = cxGridDBBandedTableViewColumnHeaderClick
      OnColumnSizeChanged = cxGridDBBandedTableViewColumnSizeChanged
      OnLeftPosChanged = cxGridDBBandedTableViewLeftPosChanged
      OnBandSizeChanged = cxGridDBBandedTableViewBandSizeChanged
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      OnKeyDown = cxGridDBBandedTableViewKeyDown
      Navigator.Buttons.CustomButtons = <>
      OnCellClick = cxGridDBBandedTableView2CellClick
      OnEditKeyDown = cxGridDBBandedTableView2EditKeyDown
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OnLeftPosChanged = cxGridDBBandedTableView2LeftPosChanged
      Bands = <>
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
      end
      item
        Width = 100
      end
      item
        Width = 150
      end>
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
  end
  inherited ActionList: TActionList
    object actSettings: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 18
      OnExecute = actSettingsExecute
    end
    object actPasteComponents: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 5
      OnExecute = actPasteComponentsExecute
    end
    object actPasteProducer: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
      ImageIndex = 5
      OnExecute = actPasteProducerExecute
    end
    object actPastePackagePins: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1088#1087#1091#1089
      ImageIndex = 5
      OnExecute = actPastePackagePinsExecute
    end
    object actPasteFamily: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' c'#1077#1084#1077#1081#1089#1090#1074#1086
      ImageIndex = 5
      OnExecute = actPasteFamilyExecute
    end
    object actOpenDatasheet: TAction
      Caption = 'Dt'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      OnExecute = actOpenDatasheetExecute
    end
    object actLoadDatasheet: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      OnExecute = actLoadDatasheetExecute
    end
    object actOpenDiagram: TAction
      Caption = 'Dm'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      OnExecute = actOpenDiagramExecute
    end
    object actLoadDiagram: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1093#1077#1084#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1093#1077#1084#1091
      OnExecute = actLoadDiagramExecute
    end
    object actOpenImage: TAction
      Caption = 'Im'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      OnExecute = actOpenImageExecute
    end
    object actLoadImage: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      OnExecute = actLoadImageExecute
    end
    object actOpenDrawing: TAction
      Caption = 'Dw'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      OnExecute = actOpenDrawingExecute
    end
    object actLoadDrawing: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      OnExecute = actLoadDrawingExecute
    end
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077' '#1089#1076#1077#1083#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1089#1077' '#1089#1076#1077#1083#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actDeleteFromAllCategories: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1074#1089#1077#1093' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086' '#1080#1079' '#1074#1089#1077#1093' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
      ImageIndex = 33
      OnExecute = actDeleteFromAllCategoriesExecute
    end
    object actAddFamily: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074' ('#1080#1083#1080' '#1086#1090#1076#1077#1083#1100#1085#1099#1081' '#1082#1086#1084#1087#1086#1085#1077#1085#1090')'
      ImageIndex = 1
      OnExecute = actAddFamilyExecute
    end
    object actAddComponent: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090' ('#1074' '#1089#1077#1084#1077#1081#1089#1090#1074#1086')'
      ImageIndex = 1
      OnExecute = actAddComponentExecute
    end
    object actFocusTopLeft: TAction
      Caption = 'actFocusTopLeft'
      OnExecute = actFocusTopLeftExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N2: TMenuItem
      Action = actPasteFamily
    end
    object N3: TMenuItem
      Action = actPasteComponents
    end
    object N4: TMenuItem
      Action = actPasteProducer
    end
    object N5: TMenuItem
      Action = actPastePackagePins
    end
  end
  inherited cxGridPopupMenu: TcxGridPopupMenu
    PopupMenus = <
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 0
        PopupMenu = pmGrid
      end
      item
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 1
        PopupMenu = pmGrid
      end>
  end
  object cxerComponents: TcxEditRepository
    Left = 128
    Top = 208
    PixelsPerInch = 96
    object cxerlSubGroup: TcxEditRepositoryLabel
    end
    object cxerpiSubGroup: TcxEditRepositoryPopupItem
      Properties.OnCloseUp = cxerpiSubGroup_PropertiesCloseUp
      Properties.OnInitPopup = cxerpiSubGroup_PropertiesInitPopup
    end
    object cxertiValue: TcxEditRepositoryTextItem
    end
    object cxertiValueRO: TcxEditRepositoryTextItem
      Properties.ReadOnly = True
    end
    object cxFieldValueWithExpand: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Caption = 'F'
          Default = True
          ImageIndex = 15
          Kind = bkGlyph
        end>
      Properties.Images = DMRepository.cxImageList
      Properties.OnButtonClick = cxFieldValueWithExpandPropertiesButtonClick
    end
    object cxFieldValueWithExpandRO: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Caption = 'F'
          Default = True
          ImageIndex = 15
          Kind = bkGlyph
        end>
      Properties.Images = DMRepository.cxImageList
      Properties.ReadOnly = True
      Properties.OnButtonClick = cxFieldValueWithExpandPropertiesButtonClick
    end
  end
  object cxEditRepository1: TcxEditRepository
    Left = 184
    Top = 280
    PixelsPerInch = 96
  end
  object TimerSyncScrollBars: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerSyncScrollBarsTimer
    Left = 96
    Top = 128
  end
end
