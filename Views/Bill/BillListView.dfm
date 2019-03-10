inherited ViewBill: TViewBill
  inherited cxGrid: TcxGrid
    ExplicitTop = 0
    ExplicitHeight = 472
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    inherited actDeleteEx: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1089#1095#1105#1090
    end
  end
end
