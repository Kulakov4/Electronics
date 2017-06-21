inherited frmGridView: TfrmGridView
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 478
  ClientWidth = 875
  ExplicitWidth = 891
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 875
    Height = 410
    ExplicitWidth = 875
    ExplicitHeight = 410
    inherited ViewGrid: TViewGrid
      Width = 873
      Height = 408
      ExplicitWidth = 873
      ExplicitHeight = 408
      inherited cxGrid: TcxGrid
        Width = 873
        Height = 361
        ExplicitWidth = 873
        ExplicitHeight = 361
      end
      inherited StatusBar: TStatusBar
        Top = 389
        Width = 873
        ExplicitTop = 389
        ExplicitWidth = 873
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
            HitTypes = [gvhtCell]
            Index = 0
          end>
      end
    end
  end
  object PanelBottom: TPanel [1]
    Left = 0
    Top = 410
    Width = 875
    Height = 68
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      875
      68)
    object lblStatus: TLabel
      Left = 16
      Top = 24
      Width = 4
      Height = 16
    end
    object cxbtnOK: TcxButton
      Left = 680
      Top = 16
      Width = 177
      Height = 36
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end
