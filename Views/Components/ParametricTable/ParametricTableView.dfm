inherited ViewParametricTable: TViewParametricTable
  Width = 903
  ParentShowHint = False
  ExplicitWidth = 903
  inherited cxGrid: TcxGrid
    Width = 903
    ExplicitWidth = 903
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnMouseMove = cxGridDBBandedTableViewMouseMove
      OnInitEditValue = cxGridDBBandedTableViewInitEditValue
      DataController.Filter.OnChanged = cxGridDBBandedTableViewDataControllerFilterChanged
      OptionsBehavior.HintHidePause = 2000
      OptionsBehavior.ColumnHeaderHints = False
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsBehavior.BandHeaderHints = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.NestedBands = False
      OptionsView.CellAutoHeight = True
      OptionsView.HeaderAutoHeight = True
      OptionsView.BandHeaderHeight = 100
      OptionsView.BandHeaders = True
      Styles.OnGetContentStyle = cxGridDBBandedTableViewStylesGetContentStyle
      OnColumnPosChanged = cxGridDBBandedTableViewColumnPosChanged
      Bands = <
        item
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          VisibleForCustomization = False
        end
        item
          Caption = 'Producer'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Description'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Datasheet'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Diagram'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Drawing'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Image'
          Options.HoldOwnColumnsOnly = True
          VisibleForCustomization = False
        end
        item
          Caption = 'Package/Pins'
          Options.HoldOwnColumnsOnly = True
          Visible = False
          VisibleForCustomization = False
        end>
      OnBandPosChanged = cxGridDBBandedTableViewBandPosChanged
      inherited clValue: TcxGridDBBandedColumn
        Caption = ' '
      end
      inherited clProducer: TcxGridDBBandedColumn
        Caption = ''
        IsCaptionAssigned = True
      end
      inherited clSubGroup: TcxGridDBBandedColumn
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 2
      end
      inherited clDescription: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 2
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clDatasheet: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 3
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clDiagram: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 4
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clDrawing: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 5
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clImage: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 6
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clPackagePins: TcxGridDBBandedColumn
        Caption = ''
        Position.BandIndex = 7
        Position.ColIndex = 0
        IsCaptionAssigned = True
      end
      inherited clParentProductId: TcxGridDBBandedColumn
        Position.BandIndex = 0
        Position.ColIndex = 3
      end
      object clAnalog: TcxGridDBBandedColumn
        Caption = #1040#1085#1072#1083#1086#1075
        DataBinding.FieldName = 'Analog'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
    end
    inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
      OnInitEditValue = cxGridDBBandedTableViewInitEditValue
      OptionsBehavior.ColumnHeaderHints = False
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsBehavior.BandHeaderHints = False
      OptionsView.CellAutoHeight = True
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = 'Producer'
          Options.HoldOwnColumnsOnly = True
        end
        item
          Caption = 'Description'
          Options.HoldOwnColumnsOnly = True
        end
        item
          Caption = 'Datasheet'
          Options.HoldOwnColumnsOnly = True
        end
        item
          Caption = 'Diagram'
          Options.HoldOwnColumnsOnly = True
          Visible = False
          VisibleForCustomization = False
        end
        item
          Caption = 'Drawing'
          Options.HoldOwnColumnsOnly = True
        end
        item
          Caption = 'Image'
          Options.HoldOwnColumnsOnly = True
        end
        item
          Caption = 'Package/Pins'
          Options.HoldOwnColumnsOnly = True
          Visible = False
        end>
      inherited clValue2: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      inherited clProducer2: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      end
      inherited clSubGroup2: TcxGridDBBandedColumn
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 3
      end
      inherited clDescription2: TcxGridDBBandedColumn
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        Position.BandIndex = 2
        Position.ColIndex = 0
      end
      inherited clDatasheet2: TcxGridDBBandedColumn
        Position.BandIndex = 3
        Position.ColIndex = 0
      end
      inherited clDiagram2: TcxGridDBBandedColumn
        Position.BandIndex = 4
        Position.ColIndex = 0
      end
      inherited clDrawing2: TcxGridDBBandedColumn
        Position.BandIndex = 5
        Position.ColIndex = 0
      end
      inherited clImage2: TcxGridDBBandedColumn
        Position.BandIndex = 6
        Position.ColIndex = 0
      end
      inherited clPackagePins2: TcxGridDBBandedColumn
        Position.BandIndex = 7
        Position.ColIndex = 0
      end
      inherited clParentProductId2: TcxGridDBBandedColumn
        Position.BandIndex = 0
        Position.ColIndex = 2
      end
      object clAnalog2: TcxGridDBBandedColumn
        Caption = #1040#1085#1072#1083#1086#1075
        DataBinding.FieldName = 'Analog'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
    end
  end
  inherited StatusBar: TStatusBar
    Width = 903
    ExplicitWidth = 903
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
          ViewLayout = ivlGlyphControlCaption
          Visible = True
          ItemName = 'cxbeiTableName'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnApplyUpdates'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxbbClearFilters'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end>
    end
    object dxbrbtnApplyUpdates: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbFullAnalog: TdxBarButton
      Action = actFullAnalog
      Category = 0
    end
    object dxbbClearFilters: TdxBarButton
      Action = actClearFilters
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actLocateInStorehouse
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actAnalog
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actAnalog
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton5: TdxBarButton
      Action = actRefresh
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object cxbeiTableName: TcxBarEditItem
      Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1080#1084#1103
      Category = 0
      Hint = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1080#1084#1103
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      Properties.OnChange = cxbeiTableNamePropertiesChange
      InternalEditValue = 'True'
    end
  end
  inherited ActionList: TActionList
    object actAutoWidth: TAction
      Caption = #1040#1074#1090#1086#1096#1080#1088#1080#1085#1072
      ImageIndex = 13
      OnExecute = actAutoWidthExecute
    end
    object actFullAnalog: TAction
      Caption = #1055#1086#1083#1085#1099#1081' '#1072#1085#1072#1083#1086#1075
      ImageIndex = 9
      OnExecute = actFullAnalogExecute
    end
    object actClearFilters: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1099
      ImageIndex = 10
      OnExecute = actClearFiltersExecute
    end
    object actAnalog: TAction
      Caption = #1055#1086#1080#1089#1082' '#1072#1085#1072#1083#1086#1075#1072
      ImageIndex = 9
      OnExecute = actAnalogExecute
    end
    object actLocateInStorehouse: TAction
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      ImageIndex = 36
      OnExecute = actLocateInStorehouseExecute
    end
    object actRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 4
      OnExecute = actRefreshExecute
    end
    object actClearSelected: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actClearSelectedExecute
    end
    object actAddSubParameter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 1
      OnExecute = actAddSubParameterExecute
    end
    object actDropSubParameter: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 2
      OnExecute = actDropSubParameterExecute
    end
    object actDropParameter: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      ImageIndex = 2
      OnExecute = actDropParameterExecute
    end
    object actBandWidth: TAction
      Caption = #1064#1080#1088#1080#1085#1072' '#1073#1101#1085#1076#1072
      Visible = False
      OnExecute = actBandWidthExecute
    end
    object actColumnWidth: TAction
      Caption = #1064#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1082#1080
      Visible = False
      OnExecute = actColumnWidthExecute
    end
    object actColumnApplyBestFit: TAction
      Caption = #1051#1091#1095#1096#1072#1103' '#1096#1080#1088#1080#1085#1072
      Visible = False
      OnExecute = actColumnApplyBestFitExecute
    end
    object actBandAutoHeight: TAction
      Caption = #1040#1074#1090#1086' '#1074#1099#1089#1086#1090#1072' '#1073#1101#1085#1076#1072
      Visible = False
      OnExecute = actBandAutoHeightExecute
    end
    object actBandAutoWidth: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1091#1102' '#1096#1080#1088#1080#1085#1091
      Visible = False
      OnExecute = actBandAutoWidthExecute
    end
    object actChangeBandWidth: TAction
      Caption = 'Change Band Width'
      Visible = False
      OnExecute = actChangeBandWidthExecute
    end
    object actShowCategoryParametersQuery: TAction
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072#1093
      Visible = False
      OnExecute = actShowCategoryParametersQueryExecute
    end
    object actBandIDList: TAction
      Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1099
      Visible = False
      OnExecute = actBandIDListExecute
    end
    object actUpdateDetailColumnWidth2: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1096#1080#1088#1080#1085#1091' '#1076#1086#1095#1077#1088#1085#1080#1093' '#1082#1086#1083#1086#1085#1086#1082
      Visible = False
      OnExecute = actUpdateDetailColumnWidth2Execute
    end
    object actUpdateColumnWidth: TAction
      Caption = 'actUpdateColumnWidth'
      OnExecute = actUpdateColumnWidthExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N6: TMenuItem
      Action = actClearSelected
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
        GridView = cxGridDBBandedTableView2
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 1
        PopupMenu = pmGrid
      end
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtColumnHeader, gvhtColumnHeaderFilterButton]
        Index = 2
        PopupMenu = pmHeaders
      end
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtBandHeader]
        Index = 3
        PopupMenu = pmBands
      end>
  end
  object BandTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = BandTimerTimer
    Left = 56
    Top = 152
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
  object pmHeaders: TPopupMenu
    Left = 440
    Top = 248
    object N7: TMenuItem
      Action = actAddSubParameter
    end
    object N8: TMenuItem
      Action = actDropSubParameter
    end
    object N11: TMenuItem
      Action = actColumnWidth
    end
    object ColumnApplyBestFit1: TMenuItem
      Action = actColumnApplyBestFit
    end
  end
  object pmBands: TPopupMenu
    Left = 440
    Top = 312
    object N9: TMenuItem
      Action = actDropParameter
    end
    object N10: TMenuItem
      Action = actBandWidth
    end
    object N12: TMenuItem
      Action = actBandAutoHeight
    end
    object N13: TMenuItem
      Action = actBandAutoWidth
    end
    object ChangeBandWidth1: TMenuItem
      Action = actChangeBandWidth
    end
    object N14: TMenuItem
      Action = actBandIDList
    end
  end
  object ColumnTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = ColumnTimerTimer
    Left = 64
    Top = 296
  end
end
