inherited frmImportProcess: TfrmImportProcess
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 527
  ClientWidth = 878
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 894
  ExplicitHeight = 566
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 878
    Height = 473
    ExplicitWidth = 878
    ExplicitHeight = 473
    inherited ViewGrid: TViewGrid
      Width = 876
      Height = 471
      ExplicitWidth = 876
      ExplicitHeight = 471
      inherited cxGrid: TcxGrid
        Width = 876
        Height = 424
        ExplicitWidth = 876
        ExplicitHeight = 424
      end
      inherited StatusBar: TStatusBar
        Top = 452
        Width = 876
        ExplicitTop = 452
        ExplicitWidth = 876
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
  object Panel1: TPanel [1]
    Left = 0
    Top = 473
    Width = 878
    Height = 54
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      878
      54)
    object cxbtnOK: TcxButton
      Left = 699
      Top = 9
      Width = 171
      Height = 38
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = cxbtnOKClick
    end
  end
end
