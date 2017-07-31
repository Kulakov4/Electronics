object ProductsFrame: TProductsFrame
  Left = 0
  Top = 0
  Width = 998
  Height = 635
  TabOrder = 0
  object cxpcStorehouse: TcxPageControl
    Left = 0
    Top = 28
    Width = 998
    Height = 607
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tsStorehouseProducts
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 603
    ClientRectLeft = 4
    ClientRectRight = 994
    ClientRectTop = 24
    object tsStorehouseInfo: TcxTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1082#1083#1072#1076#1077
      ImageIndex = 0
      inline ViewStorehouseInfo: TViewStorehouseInfo
        Left = 0
        Top = 0
        Width = 990
        Height = 579
        Align = alClient
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 990
        ExplicitHeight = 579
      end
    end
    object tsStorehouseProducts: TcxTabSheet
      Caption = #1058#1086#1074#1072#1088#1099
      ImageIndex = 1
      inline ViewProducts2: TViewProducts2
        Left = 0
        Top = 0
        Width = 990
        Height = 579
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 990
        ExplicitHeight = 579
        inherited cxDBTreeList: TcxDBTreeList
          Width = 990
          Height = 525
          ExplicitWidth = 990
          ExplicitHeight = 525
          inherited clDatasheet: TcxDBTreeListColumn
            Properties.Buttons = <
              item
                Action = ViewProducts2.actOpenDatasheet
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewProducts2.actLoadDatasheet
                Kind = bkEllipsis
              end>
          end
          inherited clDiagram: TcxDBTreeListColumn
            Properties.Buttons = <
              item
                Action = ViewProducts2.actOpenDiagram
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewProducts2.actLoadDiagram
                Kind = bkEllipsis
              end>
          end
          inherited clDrawing: TcxDBTreeListColumn
            Properties.Buttons = <
              item
                Action = ViewProducts2.actOpenDrawing
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewProducts2.actLoadDrawing
                Kind = bkEllipsis
              end>
          end
          inherited clImage: TcxDBTreeListColumn
            Properties.Buttons = <
              item
                Action = ViewProducts2.actOpenImage
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewProducts2.actLoadImage
                Kind = bkEllipsis
              end>
          end
        end
        inherited dxBarManager: TdxBarManager
          DockControlHeights = (
            0
            0
            54
            0)
        end
      end
    end
    object tsStorehouseSearch: TcxTabSheet
      Caption = #1055#1086#1080#1089#1082
      ImageIndex = 2
      inline ViewProductsSearch: TViewProductsSearch
        Left = 0
        Top = 0
        Width = 990
        Height = 579
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 990
        ExplicitHeight = 579
        inherited cxGrid: TcxGrid
          Width = 990
          Height = 532
          ExplicitWidth = 990
          ExplicitHeight = 532
          inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
            inherited clDatasheet2: TcxGridDBBandedColumn
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
            inherited clDiagram2: TcxGridDBBandedColumn
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
            inherited clDrawing2: TcxGridDBBandedColumn
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
            inherited clImage2: TcxGridDBBandedColumn
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
          Top = 560
          Width = 990
          ExplicitTop = 560
          ExplicitWidth = 990
        end
        inherited ViewProducts2: TViewProducts2
          Width = 990
          Height = 532
          ExplicitWidth = 990
          ExplicitHeight = 532
          inherited cxDBTreeList: TcxDBTreeList
            Width = 990
            Height = 478
            ExplicitWidth = 990
            ExplicitHeight = 478
            inherited clID: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clIsGroup: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clIDComponentGroup: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clValue: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clIDProducer: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clDescription: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clDatasheet: TcxDBTreeListColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.ViewProducts2.actOpenDatasheet
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.ViewProducts2.actLoadDatasheet
                  Kind = bkEllipsis
                end>
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clDiagram: TcxDBTreeListColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.ViewProducts2.actOpenDiagram
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.ViewProducts2.actLoadDiagram
                  Kind = bkEllipsis
                end>
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clDrawing: TcxDBTreeListColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.ViewProducts2.actOpenDrawing
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.ViewProducts2.actLoadDrawing
                  Kind = bkEllipsis
                end>
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clImage: TcxDBTreeListColumn
              Properties.Buttons = <
                item
                  Action = ViewProductsSearch.ViewProducts2.actOpenImage
                  Default = True
                  Kind = bkGlyph
                end
                item
                  Action = ViewProductsSearch.ViewProducts2.actLoadImage
                  Kind = bkEllipsis
                end>
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPackagePins: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clYYYY: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clMM: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clWW: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clAmount: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPackaging: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceR2: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceD2: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceR1: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceD1: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceR: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clPriceD: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clOriginCountryCode: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clOriginCountry: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clBatchNumber: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clCustomsDeclarationNumber: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clStorage: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clStoragePlace: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clSeller: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clDocumentNumber: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
            inherited clBarcode: TcxDBTreeListColumn
              Position.ColIndex = -1
              Position.RowIndex = -1
              Position.BandIndex = -1
            end
          end
          inherited dxBarManager: TdxBarManager
            DockControlHeights = (
              0
              0
              54
              0)
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
              GridView = ViewProductsSearch.cxGridDBBandedTableView
              HitTypes = [gvhtCell]
              Index = 0
              PopupMenu = ViewProductsSearch.pmGrid
            end>
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
    UseSystemFont = True
    Left = 64
    Top = 280
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
      FloatLeft = 1008
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
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
        end>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 144
    Top = 280
    object actLoadFromExcelDocument: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actLoadFromExcelDocumentExecute
    end
  end
end
