inherited frmGridView: TfrmGridView
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 429
  ClientWidth = 619
  ExplicitWidth = 635
  ExplicitHeight = 468
  DesignSize = (
    619
    429)
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Width = 618
    Height = 371
    Align = alNone
    ExplicitWidth = 618
    ExplicitHeight = 371
    inherited ViewGridEx: TViewGridEx
      Width = 618
      Height = 371
      ExplicitWidth = 618
      ExplicitHeight = 371
      inherited cxGrid: TcxGrid
        Width = 618
        Height = 324
        ExplicitWidth = 618
        ExplicitHeight = 324
      end
      inherited StatusBar: TStatusBar
        Top = 352
        Width = 618
        ExplicitTop = 352
        ExplicitWidth = 618
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
    Left = 448
    Top = 388
    Width = 163
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
