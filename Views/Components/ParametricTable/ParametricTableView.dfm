inherited ViewParametricTable: TViewParametricTable
  ParentShowHint = False
  ShowHint = True
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnMouseMove = cxGridDBBandedTableViewMouseMove
      OnInitEditValue = cxGridDBBandedTableViewInitEditValue
      DataController.Filter.OnChanged = cxGridDBBandedTableViewDataControllerFilterChanged
      DataController.OnCompare = cxGridDBBandedTableViewDataControllerCompare
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.NestedBands = False
      OptionsView.CellAutoHeight = True
      OptionsView.BandHeaderEndEllipsis = True
      OptionsView.BandHeaderHeight = 40
      OptionsView.BandHeaders = True
      Styles.OnGetContentStyle = cxGridDBBandedTableViewStylesGetContentStyle
      Bands = <
        item
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
      OptionsBehavior.EditAutoHeight = eahRow
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
          ItemName = 'dxbrbtnApplyUpdates'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmAnalogSearch'
        end
        item
          Visible = True
          ItemName = 'dxbbClearFilters'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxbrbtnApplyUpdates: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrsbtmAnalogSearch: TdxBarSubItem
      Caption = #1055#1086#1080#1089#1082' '#1072#1085#1072#1083#1086#1075#1072
      Category = 0
      Visible = ivAlways
      ImageIndex = 9
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbbFullAnalog'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
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
    object dxBarButton2: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      OnClick = dxBarButton2Click
    end
    object dxBarButton1: TdxBarButton
      Action = actLocateInStorehouse
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actNearAnalog
      Category = 0
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
    object actNearAnalog: TAction
      Caption = #1041#1083#1080#1079#1082#1080#1081' '#1072#1085#1072#1083#1086#1075
      ImageIndex = 9
      OnExecute = actNearAnalogExecute
    end
    object actLocateInStorehouse: TAction
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1089#1082#1083#1072#1076#1072#1084
      ImageIndex = 36
      OnExecute = actLocateInStorehouseExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 256
    Top = 120
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
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
end
