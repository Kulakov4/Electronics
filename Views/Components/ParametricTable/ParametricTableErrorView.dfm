inherited ViewParametricTableError: TViewParametricTableError
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OptionsData.Editing = True
      object clButton: TcxGridDBBandedColumn
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actFix
            Default = True
            Kind = bkText
          end>
        Properties.ViewStyle = vsButtonsAutoWidth
        Options.IncSearch = False
        Options.ShowEditButtons = isebAlways
        Options.Moving = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
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
    object actFix: TAction
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100
      OnExecute = actFixExecute
    end
  end
  inherited cxImageList1: TcxImageList
    FormatVersion = 1
  end
end
