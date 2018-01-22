inherited frmCustomGridView: TfrmCustomGridView
  Caption = 'frmCustomGridView'
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    inline ViewGridEx: TViewGridEx
      Left = 0
      Top = 0
      Width = 635
      Height = 299
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 635
      ExplicitHeight = 299
      inherited cxGrid: TcxGrid
        Width = 635
        Height = 252
        ExplicitWidth = 635
        ExplicitHeight = 252
      end
      inherited StatusBar: TStatusBar
        Top = 280
        Width = 635
        ExplicitTop = 280
        ExplicitWidth = 635
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
            GridView = ViewGridEx.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewGridEx.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
end
