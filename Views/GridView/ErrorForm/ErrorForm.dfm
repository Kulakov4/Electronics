inherited frmError: TfrmError
  Caption = #1054#1096#1080#1073#1082#1080
  ClientHeight = 447
  ClientWidth = 812
  ExplicitWidth = 828
  ExplicitHeight = 486
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 812
    Height = 379
    ExplicitWidth = 812
    ExplicitHeight = 379
    inherited ViewImportError: TViewGrid
      Width = 810
      Height = 377
      ExplicitWidth = 810
      ExplicitHeight = 377
      inherited cxGrid: TcxGrid
        Width = 810
        Height = 330
        ExplicitWidth = 810
        ExplicitHeight = 330
      end
      inherited StatusBar: TStatusBar
        Top = 358
        Width = 810
        ExplicitTop = 358
        ExplicitWidth = 810
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
            GridView = ViewImportError.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewImportError.pmGrid
          end>
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 379
    Width = 812
    Height = 68
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      812
      68)
    object cxlblTotalErrors: TcxLabel
      Left = 16
      Top = 21
      Caption = 'cxlblTotalErrors'
    end
    object cxbtnOK: TcxButton
      Left = 633
      Top = 14
      Width = 171
      Height = 38
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
end
