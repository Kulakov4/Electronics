inherited ViewProductsBasket: TViewProductsBasket
  inherited cxDBTreeList: TcxDBTreeList
    inherited clSaleCount: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleCount
          Kind = skSum
        end>
    end
    inherited clSaleR: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleR
          Kind = skSum
        end>
    end
    inherited clSaleD: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleD
          Kind = skSum
        end>
    end
    inherited clSaleE: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleE
          Kind = skSum
        end>
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
    PixelsPerInch = 96
    inherited dxBarManagerBar1: TdxBar
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
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actBasketDelete
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actBasketClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actBasketDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actBasketDeleteExecute
    end
    object actBasketClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actBasketClearExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
