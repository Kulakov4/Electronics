inherited frmParametricTableError: TfrmParametricTableError
  Caption = #1054#1096#1080#1073#1082#1080' '#1089#1088#1077#1076#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
  ClientHeight = 394
  ClientWidth = 717
  ExplicitWidth = 733
  ExplicitHeight = 433
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 717
    Height = 329
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    inline ViewParametricTableError: TViewParametricTableError
      Left = 1
      Top = 1
      Width = 715
      Height = 327
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 715
      ExplicitHeight = 327
      inherited cxGrid: TcxGrid
        Width = 715
        Height = 280
        ExplicitWidth = 715
        ExplicitHeight = 280
        inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
          inherited clButton: TcxGridDBBandedColumn
            Properties.Buttons = <
              item
                Action = ViewParametricTableError.actFix
                Default = True
                Kind = bkText
              end>
          end
        end
      end
      inherited StatusBar: TStatusBar
        Top = 308
        Width = 715
        ExplicitTop = 308
        ExplicitWidth = 715
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
            GridView = ViewParametricTableError.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewParametricTableError.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  object cxButtonNext: TcxButton
    Left = 440
    Top = 344
    Width = 121
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButtonCancel: TcxButton
    Left = 576
    Top = 344
    Width = 121
    Height = 33
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
