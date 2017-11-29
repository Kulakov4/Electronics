inherited ViewAnalogGrid3: TViewAnalogGrid3
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
    Left = 440
    Top = 52
    Width = 20
    Height = 25
    Caption = '...'
    TabOrder = 6
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
      Caption = #1042#1089#1087#1083#1099#1074#1072#1102#1097#1072#1103' '#1092#1086#1088#1084#1072
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
end
