inherited frmGridView: TfrmGridView
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 343
  ClientWidth = 573
  ExplicitWidth = 589
  ExplicitHeight = 382
  DesignSize = (
    573
    343)
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Width = 573
    Height = 289
    Align = alNone
    ExplicitWidth = 573
    ExplicitHeight = 289
    inherited ViewGridEx: TViewGridEx
      Width = 573
      Height = 289
      ExplicitWidth = 573
      ExplicitHeight = 289
      inherited cxGrid: TcxGrid
        Width = 573
        Height = 242
        ExplicitWidth = 573
        ExplicitHeight = 242
      end
      inherited StatusBar: TStatusBar
        Top = 270
        Width = 573
        ExplicitTop = 270
        ExplicitWidth = 573
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
      inherited DataSource: TDataSource
        Left = 40
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  object cxbtnOK: TcxButton
    Left = 402
    Top = 302
    Width = 163
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
