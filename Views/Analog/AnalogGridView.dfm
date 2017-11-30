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
  object Button1: TButton [3]
    Left = 144
    Top = 68
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 7
    OnClick = Button1Click
  end
  object PopupPanel: TPanel [4]
    Left = 67
    Top = 168
    Width = 233
    Height = 272
    Caption = 'PopupPanel'
    TabOrder = 8
    Visible = False
    inline PopupViewGridEx: TViewGridEx
      Left = 1
      Top = 1
      Width = 231
      Height = 270
      Align = alClient
      ExplicitLeft = -660
      ExplicitTop = -219
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 231
        Height = 251
      end
      inherited StatusBar: TStatusBar
        Top = 251
        Width = 231
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
    Left = 216
    Top = 280
  end
  object dxCalloutPopup1: TdxCalloutPopup
    AnimationOptions.FadeEffect = False
    AnimationOptions.MoveEffect = False
    Left = 392
    Top = 344
  end
end
