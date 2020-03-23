inherited ViewProductsBasket2: TViewProductsBasket2
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
          ItemName = 'cxbeiDate'
        end
        item
          Visible = True
          ItemName = 'cxbeiDollar'
        end
        item
          Visible = True
          ItemName = 'cxbeiEuro'
        end
        item
          Visible = True
          ItemName = 'dxbbRefreshCources'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end>
    end
    object dxBarButton2: TdxBarButton
      Action = actBasketDelete
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actBasketClear
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actCommit
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actRollback
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actCreateBill
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actBasketClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1088#1079#1080#1085#1091
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1088#1079#1080#1085#1091
      ImageIndex = 10
      OnExecute = actBasketClearExecute
    end
    object actBasketDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1082#1086#1088#1079#1080#1085#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1082#1086#1088#1079#1080#1085#1099
      ImageIndex = 2
      OnExecute = actBasketDeleteExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
