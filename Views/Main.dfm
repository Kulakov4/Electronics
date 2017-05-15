object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Database'
  ClientHeight = 636
  ClientWidth = 1215
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
    Width = 1215
    Height = 20
    Panels = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object cxpcLeft: TcxPageControl
    Left = 0
    Top = 52
    Width = 273
    Height = 564
    Align = alLeft
    TabOrder = 1
    Properties.ActivePage = cxtsComponents
    Properties.CustomButtons.Buttons = <>
    OnChange = cxpcLeftChange
    ClientRectBottom = 560
    ClientRectLeft = 4
    ClientRectRight = 269
    ClientRectTop = 27
    object cxtsComponents: TcxTabSheet
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 0
      OnShow = cxtsComponentsShow
      object dbtlCategories: TcxDBTreeList
        Left = 0
        Top = 0
        Width = 265
        Height = 533
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
        OnCanFocusNode = dbtlCategoriesCanFocusNode
        OnClick = dbtlCategoriesClick
        OnCollapsed = dbtlCategoriesCollapsed
        OnDragDrop = dbtlCategoriesDragDrop
        OnDragOver = dbtlCategoriesDragOver
        OnExpanded = dbtlCategoriesExpanded
        OnMouseUp = tlLeftControlMouseDown
        OnStartDrag = dbtlCategoriesStartDrag
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
    object cxtsStorehouses: TcxTabSheet
      Caption = #1057#1082#1083#1072#1076#1099
      ImageIndex = 1
      OnShow = cxtsStorehousesShow
      object CxGridStorehouseList: TcxGrid
        Left = 0
        Top = 0
        Width = 265
        Height = 533
        Align = alClient
        TabOrder = 0
        object tvStorehouseList: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.KeyFieldNames = 'Id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object clStorehouseListTitle: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Title'
            PropertiesClassName = 'TcxLabelProperties'
            Width = 250
          end
        end
        object glStorehouseList: TcxGridLevel
          GridView = tvStorehouseList
        end
      end
    end
  end
  object cxpcRight: TcxPageControl
    Left = 281
    Top = 52
    Width = 934
    Height = 564
    Align = alClient
    TabOrder = 6
    Properties.ActivePage = cxtsRComponents
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 560
    ClientRectLeft = 4
    ClientRectRight = 930
    ClientRectTop = 27
    object cxtsRComponents: TcxTabSheet
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 0
      inline ComponentsFrame: TComponentsFrame
        Left = 0
        Top = 0
        Width = 926
        Height = 533
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 926
        ExplicitHeight = 533
        inherited cxpcComponents: TcxPageControl
          Width = 926
          Height = 505
          Properties.ActivePage = ComponentsFrame.cxtsParametricTable
          ExplicitWidth = 926
          ExplicitHeight = 505
          ClientRectBottom = 501
          ClientRectRight = 922
          ClientRectTop = 27
          inherited cxtsCategory: TcxTabSheet
            ExplicitLeft = 4
            ExplicitTop = 24
            ExplicitWidth = 870
            ExplicitHeight = 452
          end
          inherited cxtsCategoryComponents: TcxTabSheet
            inherited ViewComponents: TViewComponents
              inherited cxGrid: TcxGrid
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponents.actOpenDatasheet
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponents.actLoadDatasheet
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponents.actOpenDiagram
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponents.actLoadDiagram
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponents.actOpenDrawing
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponents.actLoadDrawing
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponents.actOpenImage
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponents.actLoadImage
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
                    GridView = ComponentsFrame.ViewComponents.cxGridDBBandedTableView
                    HitTypes = [gvhtGridNone, gvhtGridTab, gvhtNone, gvhtTab, gvhtCell, gvhtExpandButton, gvhtRecord, gvhtNavigator, gvhtPreview, gvhtColumnHeader, gvhtColumnHeaderFilterButton, gvhtFilter, gvhtFooter, gvhtFooterCell, gvhtGroupFooter, gvhtGroupFooterCell, gvhtGroupByBox, gvhtIndicator, gvhtIndicatorHeader, gvhtIndicatorBandHeader, gvhtRowIndicator, gvhtRowLevelIndent, gvhtBand, gvhtBandHeader, gvhtRowCaption, gvhtSeparator, gvhtGroupSummary, gvhtFindPanel]
                    Index = 0
                    PopupMenu = ComponentsFrame.ViewComponents.pmGrid
                  end
                  item
                    GridView = ComponentsFrame.ViewComponents.cxGridDBBandedTableView2
                    HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
                    Index = 1
                    PopupMenu = ComponentsFrame.ViewComponents.pmGrid
                  end>
              end
            end
          end
          inherited cxtsCategoryParameters: TcxTabSheet
            inherited ViewCategoryParameters: TViewCategoryParameters
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
                    GridView = ComponentsFrame.ViewCategoryParameters.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ComponentsFrame.ViewCategoryParameters.pmGrid
                  end>
              end
              inherited cxStyleRepository: TcxStyleRepository
                PixelsPerInch = 96
              end
            end
          end
          inherited cxtsComponentsSearch: TcxTabSheet
            inherited ViewComponentsSearch: TViewComponentsSearch
              inherited cxGrid: TcxGrid
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  Styles.OnGetHeaderStyle = nil
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actOpenDatasheet
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actLoadDatasheet
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actOpenDiagram
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actLoadDiagram
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actOpenDrawing
                        Kind = bkGlyph
                      end
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actLoadDrawing
                        Default = True
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actOpenImage
                        Kind = bkGlyph
                      end
                      item
                        Action = ComponentsFrame.ViewComponentsSearch.actLoadImage
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
                    GridView = ComponentsFrame.ViewComponentsSearch.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ComponentsFrame.ViewComponentsSearch.pmGrid
                  end
                  item
                    GridView = ComponentsFrame.ViewComponentsSearch.cxGridDBBandedTableView2
                    HitTypes = [gvhtCell]
                    Index = 1
                    PopupMenu = ComponentsFrame.ViewComponentsSearch.pmGrid
                  end>
              end
            end
          end
          inherited cxtsParametricTable: TcxTabSheet
            ExplicitTop = 27
            ExplicitWidth = 918
            ExplicitHeight = 474
            inherited ViewParametricTable: TViewParametricTable
              Width = 918
              Height = 474
              ExplicitWidth = 918
              ExplicitHeight = 474
              inherited cxGrid: TcxGrid
                Width = 918
                Height = 427
                ExplicitWidth = 918
                ExplicitHeight = 427
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  Styles.OnGetHeaderStyle = nil
                  inherited clProducer: TcxGridDBBandedColumn
                    IsCaptionAssigned = True
                  end
                  inherited clDescription: TcxGridDBBandedColumn
                    IsCaptionAssigned = True
                  end
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewParametricTable.actOpenDatasheet
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewParametricTable.actLoadDatasheet
                        Default = True
                        Kind = bkEllipsis
                      end>
                    IsCaptionAssigned = True
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewParametricTable.actOpenDiagram
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewParametricTable.actLoadDiagram
                        Default = True
                        Kind = bkEllipsis
                      end>
                    IsCaptionAssigned = True
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewParametricTable.actOpenDrawing
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewParametricTable.actLoadDrawing
                        Default = True
                        Kind = bkEllipsis
                      end>
                    IsCaptionAssigned = True
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ComponentsFrame.ViewParametricTable.actOpenImage
                        Kind = bkText
                      end
                      item
                        Action = ComponentsFrame.ViewParametricTable.actLoadImage
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
                Top = 455
                Width = 918
                ExplicitTop = 455
                ExplicitWidth = 918
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
                    GridView = ComponentsFrame.ViewParametricTable.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ComponentsFrame.ViewParametricTable.pmGrid
                  end
                  item
                    GridView = ComponentsFrame.ViewParametricTable.cxGridDBBandedTableView2
                    HitTypes = [gvhtCell]
                    Index = 1
                    PopupMenu = ComponentsFrame.ViewParametricTable.pmGrid
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
            28
            0)
        end
        inherited ActionList: TActionList
          Images = nil
        end
      end
    end
    object cxtsRStorehouses: TcxTabSheet
      Caption = #1057#1082#1083#1072#1076#1099
      ImageIndex = 1
      inline ProductsFrame: TProductsFrame
        Left = 0
        Top = 0
        Width = 926
        Height = 533
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 926
        ExplicitHeight = 533
        inherited cxpcStorehouse: TcxPageControl
          Width = 926
          Height = 505
          ExplicitTop = 28
          ExplicitWidth = 926
          ExplicitHeight = 505
          ClientRectBottom = 501
          ClientRectRight = 922
          ClientRectTop = 27
          inherited tsStorehouseInfo: TcxTabSheet
            ExplicitTop = 27
            ExplicitWidth = 918
            ExplicitHeight = 474
            inherited ViewStorehouseInfo: TViewStorehouseInfo
              Width = 918
              Height = 474
              ExplicitWidth = 918
              ExplicitHeight = 474
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
            inherited ViewProducts: TViewProducts
              inherited cxGrid: TcxGrid
                ExplicitHeight = 532
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProducts.actOpenDatasheet
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProducts.actLoadDatasheet
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProducts.actOpenDiagram
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProducts.actLoadDiagram
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProducts.actOpenDrawing
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProducts.actLoadDrawing
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProducts.actOpenImage
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProducts.actLoadImage
                        Kind = bkEllipsis
                      end>
                  end
                end
              end
              inherited StatusBar: TStatusBar
                ExplicitTop = 560
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
                    GridView = ProductsFrame.ViewProducts.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ProductsFrame.ViewProducts.pmGrid
                  end>
              end
            end
          end
          inherited tsStorehouseSearch: TcxTabSheet
            inherited ViewProductsSearch: TViewProductsSearch
              inherited cxGrid: TcxGrid
                ExplicitHeight = 532
                inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
                  inherited clDatasheet: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProductsSearch.actOpenDatasheet
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProductsSearch.actLoadDatasheet
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDiagram: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProductsSearch.actOpenDiagram
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProductsSearch.actLoadDiagram
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clDrawing: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProductsSearch.actOpenDrawing
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProductsSearch.actLoadDrawing
                        Kind = bkEllipsis
                      end>
                  end
                  inherited clImage: TcxGridDBBandedColumn
                    Properties.Buttons = <
                      item
                        Action = ProductsFrame.ViewProductsSearch.actOpenImage
                        Default = True
                        Kind = bkGlyph
                      end
                      item
                        Action = ProductsFrame.ViewProductsSearch.actLoadImage
                        Kind = bkEllipsis
                      end>
                  end
                end
              end
              inherited StatusBar: TStatusBar
                ExplicitTop = 560
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
                    GridView = ProductsFrame.ViewProductsSearch.cxGridDBBandedTableView
                    HitTypes = [gvhtCell]
                    Index = 0
                    PopupMenu = ProductsFrame.ViewProductsSearch.pmGrid
                  end>
              end
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
      end
    end
  end
  object cxspltrMain: TcxSplitter
    Left = 273
    Top = 52
    Width = 8
    Height = 564
    HotZoneClassName = 'TcxSimpleStyle'
    PositionAfterOpen = 200
    AutoSnap = True
    Control = cxpcLeft
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
    object dxBarButton4: TdxBarButton
      Action = actSaveAll
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton10: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      Visible = ivAlways
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
