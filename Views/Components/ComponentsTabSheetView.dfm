object ComponentsFrame: TComponentsFrame
  Left = 0
  Top = 0
  Width = 878
  Height = 508
  TabOrder = 0
  object cxpcComponents: TcxPageControl
    Left = 0
    Top = 0
    Width = 878
    Height = 508
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = cxtsCategory
    Properties.CustomButtons.Buttons = <>
    OnPageChanging = cxpcComponentsPageChanging
    ClientRectBottom = 504
    ClientRectLeft = 4
    ClientRectRight = 874
    ClientRectTop = 24
    object cxtsCategory: TcxTabSheet
      Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1092#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1086#1081' '#1075#1088#1091#1087#1087#1099
      ImageIndex = 0
      object cxgrdFunctionalGroup: TcxGrid
        Left = 0
        Top = 0
        Width = 870
        Height = 480
        Align = alClient
        TabOrder = 0
        object tvFunctionalGroup: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsSelection.HideSelection = True
          OptionsView.GroupByBox = False
          object clFunctionalGroupId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
          end
          object clFunctionalGroupExternalId: TcxGridDBColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'ExternalId'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ReadOnly = True
            Width = 113
          end
          object clFunctionalGroupValue: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ReadOnly = True
            Width = 373
          end
          object clFunctionalGroupOrder: TcxGridDBColumn
            DataBinding.FieldName = 'Order'
            Visible = False
            SortIndex = 0
            SortOrder = soAscending
          end
          object clFunctionalGroupParentExternalId: TcxGridDBColumn
            Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'ParentExternalId'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ReadOnly = True
            Width = 193
          end
        end
        object glFunctionalGroup: TcxGridLevel
          GridView = tvFunctionalGroup
        end
      end
    end
    object cxtsCategoryComponents: TcxTabSheet
      Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1075#1088#1091#1087#1087#1099' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      ImageIndex = 1
      OnShow = cxtsCategoryComponentsShow
      inline ViewComponents: TViewComponents
        Left = 0
        Top = 0
        Width = 870
        Height = 480
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 480
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 433
          ExplicitWidth = 870
          ExplicitHeight = 433
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponents.actOpenDatasheet
                  Kind = bkText
                end
                item
                  Action = ViewComponents.actLoadDatasheet
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clDiagram: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponents.actOpenDiagram
                  Kind = bkText
                end
                item
                  Action = ViewComponents.actLoadDiagram
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clDrawing: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponents.actOpenDrawing
                  Kind = bkText
                end
                item
                  Action = ViewComponents.actLoadDrawing
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clImage: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponents.actOpenImage
                  Kind = bkText
                end
                item
                  Action = ViewComponents.actLoadImage
                  Default = True
                  Kind = bkEllipsis
                end>
            end
          end
        end
        inherited StatusBar: TStatusBar
          Top = 461
          Width = 870
          ExplicitTop = 461
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          DockControlHeights = (
            0
            0
            28
            0)
        end
        inherited cxGridPopupMenu: TcxGridPopupMenu
          PopupMenus = <
            item
              GridView = ViewComponents.cxGridDBBandedTableView
              HitTypes = [gvhtGridNone, gvhtGridTab, gvhtNone, gvhtTab, gvhtCell, gvhtExpandButton, gvhtRecord, gvhtNavigator, gvhtPreview, gvhtColumnHeader, gvhtColumnHeaderFilterButton, gvhtFilter, gvhtFooter, gvhtFooterCell, gvhtGroupFooter, gvhtGroupFooterCell, gvhtGroupByBox, gvhtIndicator, gvhtIndicatorHeader, gvhtIndicatorBandHeader, gvhtRowIndicator, gvhtRowLevelIndent, gvhtBand, gvhtBandHeader, gvhtRowCaption, gvhtSeparator, gvhtGroupSummary, gvhtFindPanel]
              Index = 0
              PopupMenu = ViewComponents.pmGrid
            end
            item
              GridView = ViewComponents.cxGridDBBandedTableView2
              HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
              Index = 1
              PopupMenu = ViewComponents.pmGrid
            end>
        end
      end
    end
    object cxtsCategoryParameters: TcxTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 4
      OnShow = cxtsCategoryParametersShow
      inline ViewCategoryParameters: TViewCategoryParameters
        Left = 0
        Top = 0
        Width = 870
        Height = 480
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 480
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 433
          ExplicitWidth = 870
          ExplicitHeight = 433
        end
        inherited StatusBar: TStatusBar
          Top = 461
          Width = 870
          ExplicitTop = 461
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          DockControlHeights = (
            0
            0
            28
            0)
        end
        inherited cxGridPopupMenu: TcxGridPopupMenu
          PopupMenus = <
            item
              GridView = ViewCategoryParameters.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewCategoryParameters.pmGrid
            end>
        end
        inherited cxStyleRepository: TcxStyleRepository
          PixelsPerInch = 96
        end
      end
    end
    object cxtsComponentsSearch: TcxTabSheet
      Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      ImageIndex = 3
      OnShow = cxtsComponentsSearchShow
      inline ViewComponentsSearch: TViewComponentsSearch
        Left = 0
        Top = 0
        Width = 870
        Height = 480
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 480
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 433
          ExplicitWidth = 870
          ExplicitHeight = 433
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Kind = bkGlyph
                end
                item
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clDiagram: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponentsSearch.actOpenDiagram
                  Kind = bkText
                end
                item
                  Action = ViewComponentsSearch.actLoadDiagram
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clDrawing: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponentsSearch.actOpenDrawing
                  Kind = bkGlyph
                end
                item
                  Action = ViewComponentsSearch.actLoadDrawing
                  Default = True
                  Kind = bkEllipsis
                end>
            end
            inherited clImage: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponentsSearch.actOpenImage
                  Kind = bkGlyph
                end
                item
                  Action = ViewComponentsSearch.actLoadImage
                  Default = True
                  Kind = bkEllipsis
                end>
            end
          end
        end
        inherited StatusBar: TStatusBar
          Top = 461
          Width = 870
          ExplicitTop = 461
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          DockControlHeights = (
            0
            0
            28
            0)
        end
        inherited cxGridPopupMenu: TcxGridPopupMenu
          PopupMenus = <
            item
              GridView = ViewComponentsSearch.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewComponentsSearch.pmGrid
            end
            item
              GridView = ViewComponentsSearch.cxGridDBBandedTableView2
              HitTypes = [gvhtCell]
              Index = 1
              PopupMenu = ViewComponentsSearch.pmGrid
            end>
        end
      end
    end
    object cxtsParametricTable: TcxTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 4
      inline ViewParametricTable: TViewParametricTable
        Left = 0
        Top = 0
        Width = 870
        Height = 480
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 480
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 433
          ExplicitWidth = 870
          ExplicitHeight = 433
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clProducer: TcxGridDBBandedColumn
              IsCaptionAssigned = True
            end
            inherited clDescription: TcxGridDBBandedColumn
              IsCaptionAssigned = True
            end
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewParametricTable.actOpenDatasheet
                  Kind = bkText
                end
                item
                  Action = ViewParametricTable.actLoadDatasheet
                  Default = True
                  Kind = bkEllipsis
                end>
              IsCaptionAssigned = True
            end
            inherited clDiagram: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewParametricTable.actOpenDiagram
                  Kind = bkText
                end
                item
                  Action = ViewParametricTable.actLoadDiagram
                  Default = True
                  Kind = bkEllipsis
                end>
              IsCaptionAssigned = True
            end
            inherited clDrawing: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewParametricTable.actOpenDrawing
                  Kind = bkText
                end
                item
                  Action = ViewParametricTable.actLoadDrawing
                  Default = True
                  Kind = bkEllipsis
                end>
              IsCaptionAssigned = True
            end
            inherited clImage: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewParametricTable.actOpenImage
                  Kind = bkText
                end
                item
                  Action = ViewParametricTable.actLoadImage
                  Default = True
                  Kind = bkEllipsis
                end>
              IsCaptionAssigned = True
            end
            inherited clPackagePins: TcxGridDBBandedColumn
              IsCaptionAssigned = True
            end
          end
        end
        inherited StatusBar: TStatusBar
          Top = 461
          Width = 870
          ExplicitTop = 461
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          DockControlHeights = (
            0
            0
            28
            0)
        end
        inherited cxGridPopupMenu: TcxGridPopupMenu
          PopupMenus = <
            item
              GridView = ViewParametricTable.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewParametricTable.pmGrid
            end
            item
              GridView = ViewParametricTable.cxGridDBBandedTableView2
              HitTypes = [gvhtCell]
              Index = 1
              PopupMenu = ViewParametricTable.pmGrid
            end>
        end
        inherited cxStyleRepository: TcxStyleRepository
          PixelsPerInch = 96
        end
      end
    end
  end
end
