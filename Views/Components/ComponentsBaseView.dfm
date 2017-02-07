inherited ViewComponentsBase: TViewComponentsBase
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
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
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clDescription: TcxGridDBBandedColumn
        AlternateCaption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'Description'
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.ReadOnly = True
        MinWidth = 50
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
        DataBinding.FieldName = 'Description'
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
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited ActionList: TActionList
    object actSettings: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 18
      OnExecute = actSettingsExecute
    end
    object actPasteAsSubComponents: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1076#1086#1095#1077#1088#1085#1080#1077' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 5
      OnExecute = actPasteAsSubComponentsExecute
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
    object actPasteMainComponents: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 5
      OnExecute = actPasteMainComponentsExecute
    end
  end
  inherited pmGrid: TPopupMenu
    Images = DMRepository.cxImageList
    object N2: TMenuItem
      Action = actPasteMainComponents
    end
    object N3: TMenuItem
      Action = actPasteAsSubComponents
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
        OnPopup = cxGridPopupMenuPopupMenus0Popup
        PopupMenu = pmGrid
      end
      item
        GridView = cxGridDBBandedTableView2
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 1
        PopupMenu = pmGrid
      end>
    OnPopup = cxGridPopupMenuPopup
  end
  inherited cxerComponents: TcxEditRepository
    object cxerlSubGroup: TcxEditRepositoryLabel
    end
    object cxerpiSubGroup: TcxEditRepositoryPopupItem
      Properties.PopupControl = frmSubgroupListPopup.Owner
      Properties.OnCloseUp = cxerpiSubGroup_PropertiesCloseUp
      Properties.OnInitPopup = cxerpiSubGroup_PropertiesInitPopup
    end
  end
end
