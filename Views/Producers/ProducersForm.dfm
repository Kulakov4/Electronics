inherited frmProducers: TfrmProducers
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    inline ViewProducers: TViewProducers
      Left = 1
      Top = 1
      Width = 788
      Height = 427
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 788
      ExplicitHeight = 427
      inherited cxGrid: TcxGrid
        Width = 788
        Height = 380
        ExplicitWidth = 788
        ExplicitHeight = 380
      end
      inherited StatusBar: TStatusBar
        Top = 408
        Width = 788
        ExplicitTop = 408
        ExplicitWidth = 788
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
            GridView = ViewProducers.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewProducers.pmGrid
          end>
      end
    end
  end
end
