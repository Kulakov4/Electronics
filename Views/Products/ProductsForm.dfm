inherited frmProducts: TfrmProducts
  Caption = #1057#1082#1083#1072#1076
  ClientHeight = 580
  ClientWidth = 857
  ExplicitWidth = 873
  ExplicitHeight = 619
  PixelsPerInch = 96
  TextHeight = 16
  inline ViewProducts: TViewProducts
    Left = 0
    Top = 0
    Width = 857
    Height = 580
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 857
    ExplicitHeight = 580
    inherited cxGrid: TcxGrid
      Width = 857
      Height = 533
      ExplicitWidth = 857
      ExplicitHeight = 533
      inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
        inherited clDatasheet2: TcxGridDBBandedColumn
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
        inherited clDiagram2: TcxGridDBBandedColumn
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
        inherited clDrawing2: TcxGridDBBandedColumn
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
        inherited clImage2: TcxGridDBBandedColumn
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
      Top = 561
      Width = 857
      ExplicitTop = 561
      ExplicitWidth = 857
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
