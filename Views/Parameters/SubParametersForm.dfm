inherited frmSubParameters: TfrmSubParameters
  Caption = #1055#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088#1099
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    inline ViewSubParameters: TViewSubParameters
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
        Height = 354
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
        PixelsPerInch = 96
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        PopupMenus = <
          item
            GridView = ViewSubParameters.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewSubParameters.pmGrid
          end>
      end
    end
  end
end
