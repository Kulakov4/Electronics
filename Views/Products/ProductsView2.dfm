inherited ViewProducts2: TViewProducts2
  Width = 1206
  ExplicitWidth = 1206
  inherited cxDBTreeList: TcxDBTreeList
    Width = 1206
    ExplicitWidth = 1206
  end
  inherited StatusBar: TStatusBar
    Width = 1206
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
    ExplicitWidth = 1206
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
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
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'cxbeiExtraChargeType'
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
        end
        item
          Visible = True
          ItemName = 'dxbcMinWholeSale'
        end
        item
          Visible = True
          ItemName = 'dxbcRetail'
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
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
    object dxBarButton7: TdxBarButton [20]
      Action = actApplyBestFit
      Category = 0
    end
    object dxBarButton8: TdxBarButton [21]
      Action = actFullScreen
      Category = 0
    end
    object dxBarButton10: TdxBarButton [22]
      Action = actFilterAndExportToExcelDocument
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actColumnsAutoWidth2: TAction [16]
      Caption = #1040#1074#1090#1086#1096#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1086#1082
      OnExecute = actColumnsAutoWidth2Execute
    end
    object actFullScreen: TAction [23]
      Caption = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      Hint = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      ImageIndex = 35
      OnExecute = actFullScreenExecute
    end
    object actFilterAndExportToExcelDocument: TAction [24]
      Caption = #1042#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1089#1090#1088#1086#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1089#1090#1088#1086#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actFilterAndExportToExcelDocumentExecute
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
