inherited ViewAnalogGrid: TViewAnalogGrid
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnInitEdit = cxGridDBBandedTableViewInitEdit
      OptionsData.Editing = True
      OptionsView.CellAutoHeight = True
      OptionsView.BandHeaders = True
      Bands = <
        item
          Visible = False
        end>
    end
  end
  object cxEditorButton: TcxButton [2]
    Left = 280
    Top = 68
    Width = 20
    Height = 25
    Action = actShowPopup
    TabOrder = 6
  end
  object PopupPanel: TPanel [3]
    Left = 15
    Top = 186
    Width = 430
    Height = 272
    Caption = 'PopupPanel'
    TabOrder = 7
    Visible = False
    inline PopupViewGridEx: TViewGridEx
      Left = 1
      Top = 1
      Width = 428
      Height = 270
      Align = alClient
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 428
      ExplicitHeight = 270
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 428
        Height = 251
        ExplicitTop = 0
        ExplicitWidth = 428
        ExplicitHeight = 251
        inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
          OptionsData.Editing = True
          OptionsView.Header = False
        end
      end
      inherited StatusBar: TStatusBar
        Top = 251
        Width = 428
        Visible = False
        ExplicitTop = 251
        ExplicitWidth = 428
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
            GridView = PopupViewGridEx.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = PopupViewGridEx.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited ActionList: TActionList
    object actShowPopup: TAction
      Caption = '...'
      OnExecute = actShowPopupExecute
    end
  end
  inherited cxImageList1: TcxImageList
    FormatVersion = 1
  end
  object EditorTimer: TTimer
    Interval = 300
    OnTimer = EditorTimerTimer
    Left = 24
    Top = 48
  end
  object dxCalloutPopup1: TdxCalloutPopup
    AnimationOptions.FadeEffect = False
    AnimationOptions.MoveEffect = False
    LookAndFeel.Kind = lfOffice11
    LookAndFeel.NativeStyle = False
    PopupControl = PopupPanel
    Rounded = True
    OnHide = dxCalloutPopup1Hide
    Left = 472
    Top = 344
  end
end
