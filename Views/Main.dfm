object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Database'
  ClientHeight = 636
  ClientWidth = 1059
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object sbMain: TdxStatusBar
    Left = 0
    Top = 616
    Width = 1059
    Height = 20
    Panels = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 52
    Width = 1059
    Height = 564
    Align = alClient
    TabOrder = 5
    Properties.ActivePage = tsStructure
    Properties.CustomButtons.Buttons = <>
    OnChange = cxPageControlChange
    ClientRectBottom = 560
    ClientRectLeft = 4
    ClientRectRight = 1055
    ClientRectTop = 27
    object tsStructure: TcxTabSheet
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 0
      object pnlMain: TPanel
        Left = 0
        Top = 0
        Width = 1051
        Height = 533
        Align = alClient
        TabOrder = 0
        object pnlList: TPanel
          Left = 1
          Top = 1
          Width = 200
          Height = 531
          Align = alLeft
          TabOrder = 0
          object tlLeftControl: TcxDBTreeList
            Left = 1
            Top = 1
            Width = 198
            Height = 529
            Align = alClient
            Bands = <
              item
              end>
            DataController.ParentField = 'ParentId'
            DataController.KeyField = 'Id'
            DragCursor = crDrag
            DragMode = dmAutomatic
            Navigator.Buttons.CustomButtons = <>
            OptionsBehavior.ImmediateEditor = False
            OptionsBehavior.BestFitMaxRecordCount = 10
            OptionsBehavior.DragDropText = True
            OptionsBehavior.ExpandOnIncSearch = True
            OptionsBehavior.IncSearch = True
            OptionsBehavior.IncSearchItem = clValue
            OptionsData.SmartRefresh = True
            OptionsSelection.InvertSelect = False
            OptionsView.Headers = False
            OptionsView.ShowRoot = False
            PopupMenu = pmLeftTreeList
            RootValue = 1
            TabOrder = 0
            OnCanFocusNode = tlLeftControlCanFocusNode
            OnClick = tlLeftControlClick
            OnCollapsed = tlLeftControlCollapsed
            OnDragDrop = tlLeftControlDragDrop
            OnDragOver = tlLeftControlDragOver
            OnExpanded = tlLeftControlExpanded
            OnMouseUp = tlLeftControlMouseDown
            OnStartDrag = tlLeftControlStartDrag
            object clValue: TcxDBTreeListColumn
              PropertiesClassName = 'TcxMemoProperties'
              Properties.ReadOnly = False
              Properties.WantReturns = False
              Properties.WordWrap = False
              BestFitMaxWidth = 1200
              DataBinding.FieldName = 'Value'
              Options.Sizing = False
              Options.VertSizing = False
              Width = 1200
              Position.ColIndex = 0
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object clId: TcxDBTreeListColumn
              Visible = False
              DataBinding.FieldName = 'Id'
              Position.ColIndex = 1
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object clParentId: TcxDBTreeListColumn
              Visible = False
              DataBinding.FieldName = 'ParentId'
              Position.ColIndex = 2
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
            object clOrder: TcxDBTreeListColumn
              Visible = False
              DataBinding.FieldName = 'Order'
              Position.ColIndex = 3
              Position.RowIndex = 0
              Position.BandIndex = 0
              Summary.FooterSummaryItems = <>
              Summary.GroupFooterSummaryItems = <>
            end
          end
        end
        object cxspltrMain: TcxSplitter
          Left = 201
          Top = 1
          Width = 8
          Height = 531
          HotZoneClassName = 'TcxSimpleStyle'
          PositionAfterOpen = 200
          AutoSnap = True
          Control = pnlList
        end
        object cxpgcntrlMain: TcxPageControl
          Left = 209
          Top = 1
          Width = 841
          Height = 531
          Align = alClient
          TabOrder = 2
          Properties.ActivePage = cxtsParametersForCategories
          Properties.CustomButtons.Buttons = <>
          OnPageChanging = cxpgcntrlMainPageChanging
          ClientRectBottom = 527
          ClientRectLeft = 4
          ClientRectRight = 837
          ClientRectTop = 27
          object tsFunctionalGroup: TcxTabSheet
            Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1092#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1086#1081' '#1075#1088#1091#1087#1087#1099
            ImageIndex = 0
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object cxgrdFunctionalGroup: TcxGrid
              Left = 0
              Top = 0
              Width = 833
              Height = 500
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
          object tsComponents: TcxTabSheet
            Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1075#1088#1091#1087#1087#1099' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
            ImageIndex = 1
            OnShow = tsComponentsShow
            inline ViewComponents: TViewComponents
              Left = 0
              Top = 0
              Width = 833
              Height = 500
              Align = alClient
              TabOrder = 0
              ExplicitWidth = 833
              ExplicitHeight = 500
              inherited cxGrid: TcxGrid
                Width = 833
                Height = 453
                ExplicitWidth = 833
                ExplicitHeight = 453
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
                Top = 481
                Width = 833
                ExplicitTop = 481
                ExplicitWidth = 833
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
          object cxtsParametersForCategories: TcxTabSheet
            Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
            ImageIndex = 4
            inline FrameCategoryParameters: TFrameCategoryParameters
              Left = 0
              Top = 0
              Width = 833
              Height = 500
              Align = alClient
              TabOrder = 0
              ExplicitWidth = 833
              ExplicitHeight = 500
              inherited cxPageControl1: TcxPageControl
                Width = 833
                Height = 500
                ExplicitWidth = 833
                ExplicitHeight = 500
                ClientRectBottom = 496
                ClientRectRight = 829
                inherited cxtsCategorized: TcxTabSheet
                  inherited ViewParametersForCategories: TViewParametersForCategories
                    inherited dxBarManager: TdxBarManager
                      DockControlHeights = (
                        0
                        0
                        0
                        0)
                    end
                    inherited cxGridPopupMenu: TcxGridPopupMenu
                      PopupMenus = <
                        item
                          GridView = FrameCategoryParameters.ViewParametersForCategories.cxGridDBBandedTableView
                          HitTypes = [gvhtCell]
                          Index = 0
                          PopupMenu = FrameCategoryParameters.ViewParametersForCategories.pmGrid
                        end>
                    end
                  end
                end
                inherited cxtsList: TcxTabSheet
                  ExplicitWidth = 781
                  ExplicitHeight = 492
                  inherited ViewCategoryParameters: TViewCategoryParameters
                    Width = 781
                    Height = 492
                    ExplicitWidth = 781
                    ExplicitHeight = 492
                    inherited cxGrid: TcxGrid
                      Width = 781
                      Height = 445
                      ExplicitWidth = 781
                      ExplicitHeight = 445
                    end
                    inherited StatusBar: TStatusBar
                      Top = 473
                      Width = 781
                      ExplicitTop = 473
                      ExplicitWidth = 781
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
                          GridView = FrameCategoryParameters.ViewCategoryParameters.cxGridDBBandedTableView
                          HitTypes = [gvhtCell]
                          Index = 0
                          PopupMenu = FrameCategoryParameters.ViewCategoryParameters.pmGrid
                        end>
                    end
                    inherited cxStyleRepository: TcxStyleRepository
                      PixelsPerInch = 96
                    end
                  end
                end
              end
              inherited dxBarManager: TdxBarManager
                DockControlHeights = (
                  0
                  0
                  0
                  0)
              end
              inherited cxImageList: TcxImageList
                FormatVersion = 1
              end
            end
          end
          object cxtsDatabase: TcxTabSheet
            Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
            ImageIndex = 3
            inline ViewComponentsSearch: TViewComponentsSearch
              Left = 0
              Top = 0
              Width = 833
              Height = 500
              Align = alClient
              TabOrder = 0
              ExplicitWidth = 833
              ExplicitHeight = 500
              inherited cxGrid: TcxGrid
                Width = 833
                Height = 453
                ExplicitWidth = 833
                ExplicitHeight = 453
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
                Top = 481
                Width = 833
                ExplicitTop = 481
                ExplicitWidth = 833
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
            OnShow = cxtsParametricTableShow
            inline ViewParametricTable: TViewParametricTable
              Left = 0
              Top = 0
              Width = 833
              Height = 500
              Align = alClient
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              ExplicitWidth = 833
              ExplicitHeight = 500
              inherited cxGrid: TcxGrid
                Width = 833
                Height = 453
                ExplicitWidth = 833
                ExplicitHeight = 453
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
                Top = 481
                Width = 833
                ExplicitTop = 481
                ExplicitWidth = 833
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
            end
          end
        end
      end
    end
    object tsStorehouse: TcxTabSheet
      Caption = #1057#1082#1083#1072#1076#1099
      ImageIndex = 1
      inline ViewStoreHouse: TViewStoreHouse
        Left = 0
        Top = 0
        Width = 1051
        Height = 533
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 1051
        ExplicitHeight = 533
        inherited cxpcStorehouse: TcxPageControl
          Left = 208
          Width = 843
          Height = 533
          ExplicitLeft = 208
          ExplicitWidth = 843
          ExplicitHeight = 533
          ClientRectBottom = 529
          ClientRectRight = 839
          ClientRectTop = 27
          inherited tsStorehouseInfo: TcxTabSheet
            inherited ViewStorehouseInfo: TViewStorehouseInfo
              inherited lblTitle: TcxLabel
                ExplicitWidth = 90
                ExplicitHeight = 20
              end
              inherited lblExternalId: TcxLabel
                ExplicitWidth = 78
                ExplicitHeight = 20
              end
              inherited lblResponsible: TcxLabel
                ExplicitWidth = 125
                ExplicitHeight = 20
              end
              inherited lblAddress: TcxLabel
                ExplicitWidth = 39
                ExplicitHeight = 20
              end
              inherited cxTeResponsible: TcxDBTextEdit
                ExplicitHeight = 24
              end
              inherited cxdbteAbbreviation: TcxDBTextEdit
                ExplicitHeight = 24
              end
            end
          end
          inherited tsStorehouseProducts: TcxTabSheet
            ExplicitTop = 27
            ExplicitWidth = 835
            ExplicitHeight = 502
            inherited ViewProducts: TViewProducts
              Width = 835
              Height = 502
              ExplicitWidth = 835
              ExplicitHeight = 502
              inherited cxGrid: TcxGrid
                Width = 835
                Height = 455
                ExplicitWidth = 835
                ExplicitHeight = 455
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProducts.actOpenDatasheet
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProducts.actLoadDatasheet
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProducts.actOpenDiagram
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProducts.actLoadDiagram
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProducts.actOpenDrawing
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProducts.actLoadDrawing
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProducts.actOpenImage
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProducts.actLoadImage
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                end
              end
              inherited StatusBar: TStatusBar
                Top = 483
                Width = 835
                ExplicitTop = 483
                ExplicitWidth = 835
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
                    GridView = ViewStoreHouse.ViewProducts.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ViewStoreHouse.ViewProducts.pmGrid
                  end>
              end
            end
          end
          inherited tsStorehouseSearch: TcxTabSheet
            inherited ViewProductsSearch: TViewProductsSearch
              inherited cxGrid: TcxGrid
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actOpenDatasheet
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actLoadDatasheet
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actOpenDiagram
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actLoadDiagram
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actOpenDrawing
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actLoadDrawing
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actOpenImage
                        Kind = bkGlyph
                      end
                      item
                        Action = ViewStoreHouse.ViewProductsSearch.actLoadImage
                        Default = True
                        Kind = bkEllipsis
                      end>
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
              inherited cxGridPopupMenu: TcxGridPopupMenu
                PopupMenus = <
                  item
                    GridView = ViewStoreHouse.ViewProductsSearch.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ViewStoreHouse.ViewProductsSearch.pmGrid
                  end>
              end
            end
          end
        end
        inherited CxGridStorehouseList: TcxGrid
          Width = 200
          Height = 533
          ExplicitWidth = 200
          ExplicitHeight = 533
        end
        inherited cxspltrStorehouse: TcxSplitter
          Left = 200
          Height = 533
          PositionAfterOpen = 200
          ExplicitLeft = 200
          ExplicitHeight = 533
        end
        inherited cxstylrpstry1: TcxStyleRepository
          PixelsPerInch = 96
        end
      end
    end
  end
  object bmMain: TdxBarManager
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 40
    Top = 104
    DockControlHeights = (
      0
      0
      52
      0)
    object dxbrMainBar1: TdxBar
      Caption = #1055#1072#1085#1077#1083#1100' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 815
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtm1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbrMainBar2: TdxBar
      Caption = #1055#1072#1085#1077#1083#1100' '#1089' '#1080#1082#1086#1085#1082#1072#1084#1080
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 24
      DockingStyle = dsTop
      FloatLeft = 314
      FloatTop = 155
      FloatClientWidth = 51
      FloatClientHeight = 48
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem5'
        end
        item
          Visible = True
          ItemName = 'dxbrb'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnSettings'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1060#1072#1081#1083
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbbOptions'
        end
        item
          Visible = True
          ItemName = 'dxbrsprtr1'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn2'
        end>
    end
    object dxbrsbtm1: TdxBarSubItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtn3'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn5'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn6'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxbbOptions: TdxBarButton
      Action = actSelectDataBasePath
      Category = 0
    end
    object dxbrsprtr1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object dxbrbtn2: TdxBarButton
      Action = actExit
      Category = 0
    end
    object dxbrbtn3: TdxBarButton
      Action = actShowManufacturers
      Category = 0
    end
    object dxbrbtn5: TdxBarButton
      Action = actShowParameters
      Category = 0
    end
    object dxbrbtn6: TdxBarButton
      Action = actShowDescriptions
      Category = 0
    end
    object dxbrbtn7: TdxBarButton
      Action = actShowBodyTypes
      Category = 0
    end
    object dxbrbtnSettings: TdxBarButton
      Action = actSelectDataBasePath
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actShowBodyTypes3
      Category = 0
    end
    object dxbrb: TdxBarButton
      Action = actReport
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actSaveAll
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 20
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem6'
        end>
    end
    object dxBarButton3: TdxBarButton
      Action = actLoadBodyTypes
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actLoadParametricTable
      Category = 0
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end>
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = #1044#1072#1085#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end>
    end
    object dxBarButton6: TdxBarButton
      Action = actLoadFromExcelFolder
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarSubItem5: TdxBarSubItem
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072
      Category = 0
      Visible = ivAlways
      ImageIndex = 29
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actAutoBindingDoc
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actAutoBindingDescriptions
      Category = 0
    end
    object dxBarSubItem6: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end>
    end
    object dxBarButton9: TdxBarButton
      Action = actLoadProductsFromExcelTable
      Category = 0
    end
  end
  object pmLeftTreeList: TPopupMenu
    Images = DMRepository.cxImageList
    Left = 40
    Top = 168
    object mniAddRecord: TMenuItem
      Action = actAddTreeNode
    end
    object mniRenameRecord: TMenuItem
      Action = actRenameTreeNode
    end
    object mniDeleteRecord: TMenuItem
      Action = actDeleteTreeNode
    end
    object Excel1: TMenuItem
      Action = actExportTreeToExcelDocument
    end
    object Excel2: TMenuItem
      Action = actLoadTreeFromExcelDocument
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 48
    Top = 419
    object actShowManufacturers: TAction
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      OnExecute = actShowManufacturersExecute
    end
    object actShowDescriptions: TAction
      Caption = #1050#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
      OnExecute = actShowDescriptionsExecute
    end
    object actShowParameters: TAction
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      OnExecute = actShowParametersExecute
    end
    object actShowBodyTypes: TAction
      Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      Visible = False
      OnExecute = actShowBodyTypesExecute
    end
    object actShowBodyTypes2: TAction
      Caption = 'actShowBodyTypes2'
      OnExecute = actShowBodyTypes2Execute
    end
    object actShowBodyTypes3: TAction
      Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      OnExecute = actShowBodyTypes3Execute
    end
    object actReport: TAction
      Caption = #1054#1090#1095#1105#1090
      Hint = #1054#1090#1095#1105#1090
      ImageIndex = 19
      OnExecute = actReportExecute
    end
    object actSelectDataBasePath: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 30
      OnExecute = actSelectDataBasePathExecute
    end
    object actSaveAll: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1105
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1105
      ImageIndex = 3
      OnExecute = actSaveAllExecute
    end
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actDeleteTreeNode: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 2
      OnExecute = actDeleteTreeNodeExecute
    end
    object actRenameTreeNode: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      Hint = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 11
      OnExecute = actRenameTreeNodeExecute
    end
    object actAddTreeNode: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 1
      OnExecute = actAddTreeNodeExecute
    end
    object actLoadBodyTypes: TAction
      Caption = #1050#1086#1088#1087#1091#1089#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 25
      OnExecute = actLoadBodyTypesExecute
    end
    object actLoadParametricTable: TAction
      Caption = #1058#1072#1073#1083#1080#1095#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1089#1077#1084#1077#1081#1089#1090#1074
      ImageIndex = 31
      OnExecute = actLoadParametricTableExecute
    end
    object actLoadFromExcelFolder: TAction
      Caption = #1048#1079' '#1087#1072#1087#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' Excel'
      ImageIndex = 24
      OnExecute = actLoadFromExcelFolderExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actAutoBindingDoc: TAction
      Caption = #1050' '#1092#1072#1081#1083#1072#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      ImageIndex = 29
      OnExecute = actAutoBindingDocExecute
    end
    object actAutoBindingDescriptions: TAction
      Caption = #1050' '#1082#1088#1072#1090#1082#1080#1084' '#1086#1087#1080#1089#1072#1085#1080#1103#1084
      ImageIndex = 29
      OnExecute = actAutoBindingDescriptionsExecute
    end
    object actLoadProductsFromExcelTable: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actLoadProductsFromExcelTableExecute
    end
    object actExportTreeToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportTreeToExcelDocumentExecute
    end
    object actLoadTreeFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actLoadTreeFromExcelDocumentExecute
    end
  end
end
