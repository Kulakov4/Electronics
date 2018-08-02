inherited ViewAnalogGrid: TViewAnalogGrid
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnMouseMove = cxGridDBBandedTableViewMouseMove
      OnInitEdit = cxGridDBBandedTableViewInitEdit
      OptionsData.Editing = True
      OptionsView.CellAutoHeight = True
      OptionsView.HeaderAutoHeight = True
      OptionsView.BandHeaders = True
      Bands = <
        item
          Visible = False
        end>
    end
  end
  inherited StatusBar: TStatusBar
    Visible = False
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
    Left = 190
    Top = 37
    Width = 698
    Height = 272
    TabOrder = 7
    Visible = False
    inline ViewGridPopupAnalog: TViewGridPopupAnalog
      Left = 1
      Top = 1
      Width = 696
      Height = 270
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 696
      ExplicitHeight = 270
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 696
        Height = 251
        ExplicitTop = 0
        ExplicitWidth = 696
        ExplicitHeight = 251
      end
      inherited StatusBar: TStatusBar
        Top = 251
        Width = 696
        Visible = False
        ExplicitTop = 251
        ExplicitWidth = 696
      end
      inherited dxBarManager: TdxBarManager
        PixelsPerInch = 96
        inherited dxbrMain: TdxBar
          Visible = False
        end
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        PopupMenus = <
          item
            GridView = ViewGridPopupAnalog.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewGridPopupAnalog.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    Left = 24
    Top = 168
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    inherited dxBarButton1: TdxBarButton
      Visible = ivNever
    end
    object dxBarButton2: TdxBarButton
      Action = actFullAnalog
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actNearAnalog
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actSave
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton5: TdxBarButton
      Action = actClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    Left = 104
    Top = 168
    object actShowPopup: TAction
      Caption = '...'
      OnExecute = actShowPopupExecute
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actClearExecute
    end
    object actFullAnalog: TAction
      Caption = #1055#1086#1083#1085#1099#1081' '#1072#1085#1072#1083#1086#1075
      ImageIndex = 9
      OnExecute = actFullAnalogExecute
    end
    object actNearAnalog: TAction
      Caption = #1041#1083#1080#1079#1082#1080#1081' '#1072#1085#1072#1083#1086#1075
      ImageIndex = 9
      OnExecute = actNearAnalogExecute
    end
    object actSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = actSaveExecute
    end
  end
  inherited pmGrid: TPopupMenu
    Left = 24
    Top = 240
    object N2: TMenuItem
      Action = actClear
    end
  end
  inherited cxGridPopupMenu: TcxGridPopupMenu
    Left = 112
    Top = 232
  end
  inherited DataSource: TDataSource
    Left = 16
  end
  inherited cxImageList1: TcxImageList
    FormatVersion = 1
    DesignInfo = 20971536
  end
  inherited UpdateDataTimer: TTimer
    Left = 96
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
    Left = 40
    Top = 400
  end
end
