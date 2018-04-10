inherited ViewProducts2: TViewProducts2
  inherited cxDBTreeList: TcxDBTreeList
    inherited clDescription: TcxDBTreeListColumn
      Properties.OnInitPopup = nil
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      56
      0)
    inherited dxBarManagerBar1: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end>
    end
    inherited dxBarManagerBar2: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxbeiDate'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 55
          Visible = True
          ItemName = 'cxbeiDollar'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 51
          Visible = True
          ItemName = 'cxbeiEuro'
        end
        item
          Visible = True
          ItemName = 'dxbbRefreshCources'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 84
          Visible = True
          ItemName = 'cxbeiExtraCharge'
        end
        item
          Visible = True
          ItemName = 'dxbcWholeSale'
        end>
    end
    object dxBarSubItem1: TdxBarSubItem [4]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton1: TdxBarButton [5]
      Action = actAddCategory
      Category = 0
    end
    object dxBarButton2: TdxBarButton [6]
      Action = actAddComponent
      Category = 0
    end
    object dxBarButton3: TdxBarButton [7]
      Action = actDelete
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton [8]
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton5: TdxBarButton [9]
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton6: TdxBarButton [10]
      Action = actOpenInParametricTable
      Category = 0
    end
    inherited cxbeiExtraCharge: TcxBarEditItem
      Properties.DropDownAutoSize = True
      Properties.GridMode = True
    end
    object dxBarSubItem2: TdxBarSubItem [15]
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end>
    end
    object dxBarButton9: TdxBarButton [16]
      Action = actExportToExcelDocument
      Category = 0
    end
    object cxbeiDate: TcxBarEditItem [17]
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      Category = 0
      Hint = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 72
    Top = 224
  end
end
