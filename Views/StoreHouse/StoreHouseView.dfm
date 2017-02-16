object ViewStoreHouse: TViewStoreHouse
  Left = 0
  Top = 0
  Width = 879
  Height = 622
  TabOrder = 0
  object cxpgcntrlStorehouse: TcxPageControl
    Left = 201
    Top = 0
    Width = 678
    Height = 622
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tsStorehouseProducts
    Properties.CustomButtons.Buttons = <>
    OnPageChanging = cxpgcntrlStorehousePageChanging
    ClientRectBottom = 618
    ClientRectLeft = 4
    ClientRectRight = 674
    ClientRectTop = 24
    object tsStorehouseInfo: TcxTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1082#1083#1072#1076#1077
      ImageIndex = 0
      inline ViewStorehouseInfo: TViewStorehouseInfo
        Left = 0
        Top = 0
        Width = 670
        Height = 594
        Align = alClient
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 670
        ExplicitHeight = 594
      end
    end
    object tsStorehouseProducts: TcxTabSheet
      Caption = #1058#1086#1074#1072#1088#1099
      ImageIndex = 1
      OnShow = tsStorehouseProductsShow
      inline ViewProducts: TViewProducts
        Left = 0
        Top = 0
        Width = 670
        Height = 594
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 670
        ExplicitHeight = 594
        inherited cxGrid: TcxGrid
          Width = 670
          Height = 547
          ExplicitWidth = 670
          ExplicitHeight = 547
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProducts.actOpenDatasheet
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProducts.actLoadDatasheet
                  Kind = bkEllipsis
                end>
            end
            inherited clDiagram: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProducts.actOpenDiagram
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProducts.actLoadDiagram
                  Kind = bkEllipsis
                end>
            end
            inherited clDrawing: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProducts.actOpenDrawing
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProducts.actLoadDrawing
                  Kind = bkEllipsis
                end>
            end
            inherited clImage: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProducts.actOpenImage
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProducts.actLoadImage
                  Kind = bkEllipsis
                end>
            end
          end
        end
        inherited StatusBar: TStatusBar
          Top = 575
          Width = 670
          ExplicitTop = 575
          ExplicitWidth = 670
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
              GridView = ViewProducts.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewProducts.pmGrid
            end>
        end
      end
    end
    object tsStorehouseSearch: TcxTabSheet
      Caption = #1055#1086#1080#1089#1082
      ImageIndex = 2
      OnShow = tsStorehouseSearchShow
      inline ViewProductsSearch: TViewProductsSearch
        Left = 0
        Top = 0
        Width = 670
        Height = 594
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 670
        ExplicitHeight = 594
        inherited cxGrid: TcxGrid
          Width = 670
          Height = 547
          ExplicitWidth = 670
          ExplicitHeight = 547
          inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
            inherited clDatasheet: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.actOpenDatasheet
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.actLoadDatasheet
                  Kind = bkEllipsis
                end>
            end
            inherited clDiagram: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.actOpenDiagram
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.actLoadDiagram
                  Kind = bkEllipsis
                end>
            end
            inherited clDrawing: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.actOpenDrawing
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.actLoadDrawing
                  Kind = bkEllipsis
                end>
            end
            inherited clImage: TcxGridDBBandedColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.actOpenImage
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.actLoadImage
                  Kind = bkEllipsis
                end>
            end
          end
        end
        inherited StatusBar: TStatusBar
          Top = 575
          Width = 670
          ExplicitTop = 575
          ExplicitWidth = 670
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
              GridView = ViewProductsSearch.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewProductsSearch.pmGrid
            end>
        end
      end
    end
  end
  object CxGridStorehouseList: TcxGrid
    Left = 0
    Top = 0
    Width = 193
    Height = 622
    Align = alLeft
    PopupMenu = pmStorehouseList
    TabOrder = 1
    object tvStorehouseList: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellClick = tvStorehouseListCellClick
      OnCustomDrawCell = tvStorehouseListCustomDrawCell
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
  object cxspltrStorehouse: TcxSplitter
    Left = 193
    Top = 0
    Width = 8
    Height = 622
    Control = CxGridStorehouseList
  end
  object pmStorehouseList: TPopupMenu
    Left = 120
    Top = 88
    object mniAddStorehouse: TMenuItem
      Action = actAddStorehouse
    end
    object mniRenameStorehouse: TMenuItem
      Action = actRenameStorehouse
    end
    object mniDeleteStorehouse: TMenuItem
      Action = actDeleteStorehouse
    end
  end
  object cxstylrpstry1: TcxStyleRepository
    Left = 40
    Top = 184
    PixelsPerInch = 96
    object cxstylSelection: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clHighlight
      TextColor = clWhite
    end
  end
  object ActionList: TActionList
    Left = 120
    Top = 184
    object actAddStorehouse: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1083#1072#1076
      OnExecute = actAddStorehouseExecute
    end
    object actRenameStorehouse: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      Hint = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1089#1082#1083#1072#1076
      OnExecute = actRenameStorehouseExecute
    end
    object actDeleteStorehouse: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1083#1072#1076
      OnExecute = actDeleteStorehouseExecute
    end
  end
end
