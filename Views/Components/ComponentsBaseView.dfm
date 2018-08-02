inherited ViewComponentsBase: TViewComponentsBase
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OptionsCustomize.ColumnVertSizing = False
      OnColumnHeaderClick = cxGridDBBandedTableViewColumnHeaderClick
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end>
      inherited clValue: TcxGridDBBandedColumn
        SortIndex = 0
        SortOrder = soAscending
      end
      object clProducer: TcxGridDBBandedColumn
        AlternateCaption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'Producer'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clSubGroup: TcxGridDBBandedColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
        DataBinding.FieldName = 'subGroup'
        PropertiesClassName = 'TcxPopupEditProperties'
        OnGetProperties = clSubGroupGetProperties
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clDescription: TcxGridDBBandedColumn
        AlternateCaption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'DescriptionComponentName'
        PropertiesClassName = 'TcxPopupEditProperties'
        Properties.OnInitPopup = clDescriptionPropertiesInitPopup
        MinWidth = 50
        Options.Sorting = False
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clDatasheet: TcxGridDBBandedColumn
        AlternateCaption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        DataBinding.FieldName = 'Datasheet'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDatasheet
            Kind = bkText
          end
          item
            Action = actLoadDatasheet
            Default = True
            Kind = bkEllipsis
          end>
        OnGetDataText = clDatasheetGetDataText
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clDiagram: TcxGridDBBandedColumn
        AlternateCaption = #1057#1093#1077#1084#1072
        Caption = #1057#1093#1077#1084#1072
        DataBinding.FieldName = 'Diagram'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDiagram
            Kind = bkText
          end
          item
            Action = actLoadDiagram
            Default = True
            Kind = bkEllipsis
          end>
        OnGetDataText = clDatasheetGetDataText
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clDrawing: TcxGridDBBandedColumn
        AlternateCaption = #1063#1077#1088#1090#1105#1078
        Caption = #1063#1077#1088#1090#1105#1078
        DataBinding.FieldName = 'Drawing'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDrawing
            Kind = bkText
          end
          item
            Action = actLoadDrawing
            Default = True
            Kind = bkEllipsis
          end>
        OnGetDataText = clDatasheetGetDataText
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clImage: TcxGridDBBandedColumn
        AlternateCaption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'Image'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenImage
            Kind = bkText
          end
          item
            Action = actLoadImage
            Default = True
            Kind = bkEllipsis
          end>
        OnGetDataText = clDatasheetGetDataText
        Options.Sorting = False
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clPackagePins: TcxGridDBBandedColumn
        AlternateCaption = #1050#1086#1088#1087#1091#1089
        Caption = #1050#1086#1088#1087#1091#1089
        DataBinding.FieldName = 'PackagePins'
        MinWidth = 120
        Options.Sorting = False
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clParentProductId: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ParentProductId'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
    end
    inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end>
      object clProducer2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Producer'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clSubGroup2: TcxGridDBBandedColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
        DataBinding.FieldName = 'DescriptionId'
        PropertiesClassName = 'TcxLabelProperties'
        OnGetProperties = clSubGroup2GetProperties
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clDescription2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'DescriptionComponentName'
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clDatasheet2: TcxGridDBBandedColumn
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        DataBinding.FieldName = 'Datasheet'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clDiagram2: TcxGridDBBandedColumn
        Caption = #1057#1093#1077#1084#1072
        DataBinding.FieldName = 'Diagram'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clDrawing2: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078
        DataBinding.FieldName = 'Drawing'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clImage2: TcxGridDBBandedColumn
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'Image'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clPackagePins2: TcxGridDBBandedColumn
        Caption = #1050#1086#1088#1087#1091#1089
        DataBinding.FieldName = 'PackagePins'
        MinWidth = 120
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clParentProductId2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ParentProductId'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
    end
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
        HitTypes = [gvhtGridNone, gvhtGridTab, gvhtNone, gvhtTab, gvhtCell, gvhtExpandButton, gvhtRecord, gvhtNavigator, gvhtPreview, gvhtColumnHeader, gvhtColumnHeaderFilterButton, gvhtFilter, gvhtFooter, gvhtFooterCell, gvhtGroupFooter, gvhtGroupFooterCell, gvhtGroupByBox, gvhtIndicator, gvhtIndicatorHeader, gvhtIndicatorBandHeader, gvhtRowIndicator, gvhtRowLevelIndent, gvhtBand, gvhtBandHeader, gvhtRowCaption, gvhtSeparator, gvhtGroupSummary, gvhtFindPanel]
        Index = 0
        PopupMenu = pmGrid
      end
      item
        GridView = cxGridDBBandedTableView2
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 1
        PopupMenu = pmGrid
      end>
  end
  inherited cxerComponents: TcxEditRepository
    PixelsPerInch = 96
    object cxerlSubGroup: TcxEditRepositoryLabel
    end
    object cxerpiSubGroup: TcxEditRepositoryPopupItem
      Properties.OnCloseUp = cxerpiSubGroup_PropertiesCloseUp
      Properties.OnInitPopup = cxerpiSubGroup_PropertiesInitPopup
    end
  end
end
