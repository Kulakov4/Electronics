inherited frmGridViewAutoSize: TfrmGridViewAutoSize
  BorderStyle = bsNone
  Caption = 'frmGridViewAutoSize'
  ClientHeight = 391
  ClientWidth = 730
  Constraints.MinWidth = 90
  Position = poDesigned
  ExplicitWidth = 730
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Width = 728
    Height = 334
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    inherited ViewGridEx: TViewGridEx
      Width = 728
      Height = 334
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 728
        Height = 315
        ExplicitTop = 0
        ExplicitHeight = 270
      end
      inherited StatusBar: TStatusBar
        Top = 315
        Width = 728
        Visible = False
      end
      inherited dxBarManager: TdxBarManager
        DockControlHeights = (
          0
          0
          0
          0)
        inherited dxbrMain: TdxBar
          Visible = False
        end
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
  inherited cxbtnOK: TcxButton
    Left = 8
    Top = 340
    Width = 714
    Anchors = [akLeft, akRight, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 340
    ExplicitWidth = 484
  end
end
