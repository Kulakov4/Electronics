inherited frmImportProcess: TfrmImportProcess
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 527
  ClientWidth = 878
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 894
  ExplicitHeight = 566
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Width = 878
    Height = 473
    ExplicitWidth = 878
    ExplicitHeight = 473
    inherited ViewGridEx: TViewGridEx
      Width = 878
      Height = 473
      ExplicitWidth = 878
      ExplicitHeight = 473
      inherited cxGrid: TcxGrid
        Width = 878
        Height = 426
        ExplicitWidth = 878
        ExplicitHeight = 426
      end
      inherited StatusBar: TStatusBar
        Top = 454
        Width = 878
        ExplicitTop = 454
        ExplicitWidth = 878
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
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  object Panel1: TPanel
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
