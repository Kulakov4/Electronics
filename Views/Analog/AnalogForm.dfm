inherited frmAnalog: TfrmAnalog
  Caption = #1055#1086#1080#1089#1082' '#1073#1083#1080#1079#1082#1086#1075#1086' '#1072#1085#1072#1083#1086#1075#1072
  ClientHeight = 364
  ClientWidth = 743
  ExplicitWidth = 759
  ExplicitHeight = 403
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 297
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    inline ViewAnalogGrid: TViewAnalogGrid
      Left = 0
      Top = 0
      Width = 745
      Height = 297
      Align = alClient
      TabOrder = 0
      ExplicitLeft = -148
      ExplicitTop = -194
      inherited cxGrid: TcxGrid
        Width = 745
        Height = 250
      end
      inherited StatusBar: TStatusBar
        Top = 278
        Width = 745
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
            GridView = ViewAnalogGrid.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewAnalogGrid.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
end
