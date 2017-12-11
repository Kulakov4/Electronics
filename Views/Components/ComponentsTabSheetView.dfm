object ComponentsFrame: TComponentsFrame
  Left = 0
  Top = 0
  Width = 878
  Height = 508
  ParentShowHint = False
  ShowHint = False
  TabOrder = 0
  object cxpcComponents: TcxPageControl
    Left = 0
    Top = 28
    Width = 878
    Height = 480
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = cxtsCategory
    Properties.CustomButtons.Buttons = <>
    OnPageChanging = cxpcComponentsPageChanging
    ClientRectBottom = 476
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
        Height = 452
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
        Height = 452
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 452
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 405
          ExplicitWidth = 870
          ExplicitHeight = 405
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDescription: TcxGridDBBandedColumn
              Properties.OnInitPopup = nil
            end
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
          Top = 433
          Width = 870
          AutoHint = True
          ExplicitTop = 433
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          ShowHint = False
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
        Height = 452
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 452
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 405
          ExplicitWidth = 870
          ExplicitHeight = 405
        end
        inherited StatusBar: TStatusBar
          Top = 433
          Width = 870
          ExplicitTop = 433
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          ShowHint = False
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
        Height = 452
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 452
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 405
          ExplicitWidth = 870
          ExplicitHeight = 405
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewComponentsSearch.actOpenDatasheet
                  Kind = bkText
                end
                item
                  Action = ViewComponentsSearch.actLoadDatasheet
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
                  Kind = bkText
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
                  Kind = bkText
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
          Top = 433
          Width = 870
          ExplicitTop = 433
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          ShowHint = False
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
              HitTypes = [gvhtGridNone, gvhtGridTab, gvhtNone, gvhtTab, gvhtCell, gvhtExpandButton, gvhtRecord, gvhtNavigator, gvhtPreview, gvhtColumnHeader, gvhtColumnHeaderFilterButton, gvhtFilter, gvhtFooter, gvhtFooterCell, gvhtGroupFooter, gvhtGroupFooterCell, gvhtGroupByBox, gvhtIndicator, gvhtIndicatorHeader, gvhtIndicatorBandHeader, gvhtRowIndicator, gvhtRowLevelIndent, gvhtBand, gvhtBandHeader, gvhtRowCaption, gvhtSeparator, gvhtGroupSummary, gvhtFindPanel]
              Index = 0
              PopupMenu = ViewComponentsSearch.pmGrid
            end
            item
              GridView = ViewComponentsSearch.cxGridDBBandedTableView2
              HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
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
        Height = 452
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ExplicitWidth = 870
        ExplicitHeight = 452
        inherited cxGrid: TcxGrid
          Width = 870
          Height = 405
          ExplicitWidth = 870
          ExplicitHeight = 405
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
          Top = 433
          Width = 870
          ExplicitTop = 433
          ExplicitWidth = 870
        end
        inherited dxBarManager: TdxBarManager
          ShowHint = False
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
              HitTypes = [gvhtGridNone, gvhtGridTab, gvhtNone, gvhtTab, gvhtCell, gvhtExpandButton, gvhtRecord, gvhtNavigator, gvhtPreview, gvhtColumnHeader, gvhtColumnHeaderFilterButton, gvhtFilter, gvhtFooter, gvhtFooterCell, gvhtGroupFooter, gvhtGroupFooterCell, gvhtGroupByBox, gvhtIndicator, gvhtIndicatorHeader, gvhtIndicatorBandHeader, gvhtRowIndicator, gvhtRowLevelIndent, gvhtBand, gvhtBandHeader, gvhtRowCaption, gvhtSeparator, gvhtGroupSummary, gvhtFindPanel]
              Index = 0
              PopupMenu = ViewParametricTable.pmGrid
            end
            item
              GridView = ViewParametricTable.cxGridDBBandedTableView2
              HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
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
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    ShowHint = False
    UseSystemFont = True
    Left = 340
    Top = 120
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Main'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 888
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 20
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem5'
        end>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1090#1072#1073#1083#1080#1094#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadFromExcelFolder
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actLoadParametricTable
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actReport
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 29
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end>
    end
    object dxBarButton5: TdxBarButton
      Action = actAutoBindingDoc
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actAutoBindingDescriptions
      Category = 0
    end
    object dxBarSubItem5: TdxBarSubItem
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 39
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end>
    end
    object dxBarButton8: TdxBarButton
      Action = actLoadParametricData
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 428
    Top = 120
    object actLoadFromExcelFolder: TAction
      Caption = #1048#1079' '#1087#1072#1087#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' Excel'
      Hint = 
        #1059#1082#1072#1079#1072#1090#1100' '#1087#1072#1087#1082#1091' '#1089' xls. '#1092#1072#1081#1083#1072#1084#1080', '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1084#1080' PN '#1076#1083#1103' '#1082#1072#1078#1076#1086#1081' '#1086#1090#1076#1077#1083#1100#1085#1086 +
        #1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080'. '#1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' - '#1074' '#1085#1072#1095#1072#1083#1077' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072'.'
      ImageIndex = 24
      OnExecute = actLoadFromExcelFolderExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = 
        #1059#1082#1072#1079#1072#1090#1100' .xls '#1092#1072#1081#1083', '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1081' PN '#1076#1083#1103' '#1086#1090#1076#1077#1083#1100#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080'. '#1048#1076#1077#1085#1090#1080 +
        #1092#1080#1082#1072#1090#1086#1088' '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' - '#1074' '#1085#1072#1095#1072#1083#1077' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072'.'
      ImageIndex = 32
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actLoadParametricTable: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = 
        #1059#1082#1072#1079#1072#1090#1100' xls. '#1092#1072#1081#1083', '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1081' '#1087#1072#1088#1072#1084'. '#1090#1072#1073#1083#1080#1094#1091' '#1076#1083#1103' '#1086#1090#1076#1077#1083#1100#1085#1086#1081' '#1082#1072#1090#1077#1075 +
        #1086#1088#1080#1080'. '#1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' - '#1074' '#1085#1072#1095#1072#1083#1077' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072 +
        '.'
      ImageIndex = 32
      OnExecute = actLoadParametricTableExecute
    end
    object actLoadParametricData: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = 
        #1059#1082#1072#1079#1072#1090#1100' xls. '#1092#1072#1081#1083' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1081' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1082#1072#1082#1086#1075#1086'-'#1083#1080#1073#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072' '#1076#1083#1103' ' +
        #1082#1072#1078#1076#1086#1075#1086' '#1086#1090#1076#1077#1083#1100#1085#1086#1075#1086' '#1082#1086#1084#1086#1087#1085#1077#1085#1090#1072' ('#1076#1086#1095#1077#1088#1085#1077#1075#1086'), '#1085#1072#1087#1088'.,: Status, Price' +
        ', Recom. Replacement.'
      ImageIndex = 32
      OnExecute = actLoadParametricDataExecute
    end
    object actReport: TAction
      Caption = #1054#1090#1095#1105#1090
      Hint = #1054#1090#1095#1105#1090
      ImageIndex = 19
      OnExecute = actReportExecute
    end
    object actAutoBindingDoc: TAction
      Caption = #1060#1072#1081#1083#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      Hint = 
        #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1080#1077' '#1082' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1072#1084' '#1092#1072#1081#1083#1086#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080' '#1080#1079 +
        ' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1091#1102#1097#1080#1093' '#1087#1072#1087#1086#1082', '#1080#1089#1087#1086#1083#1100#1079#1091#1103': '#1083#1080#1073#1086', '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1072#1083#1075#1086#1088#1080#1090#1084' '#1087#1088#1086 +
        #1075#1088#1072#1084#1084#1099', '#1083#1080#1073#1086' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1089#1074#1086#1080#1084' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1072 +
        #1084' '#1080#1079' '#1079#1072#1075#1088#1091#1079#1086#1095#1085#1086#1075#1086' Excel-'#1092#1072#1081#1083#1072' '
      ImageIndex = 29
      OnExecute = actAutoBindingDocExecute
    end
    object actAutoBindingDescriptions: TAction
      Caption = #1050#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
      Hint = 
        #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1087#1086#1080#1089#1082' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1077' '#1080' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1080#1077' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1091#1102#1097#1077 +
        #1075#1086' '#1086#1087#1080#1089#1072#1085#1080#1103' '#1082#1072#1078#1076#1086#1084#1091' '#1089#1077#1084#1077#1081#1089#1090#1074#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074'.'
      ImageIndex = 29
      OnExecute = actAutoBindingDescriptionsExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnHint = ApplicationEventsHint
    Left = 184
    Top = 344
  end
end
