inherited ViewBillContent: TViewBillContent
  inherited cxDBTreeList: TcxDBTreeList
    Top = 28
    Height = 551
    OnAfterSummary = cxDBTreeListAfterSummary
    ExplicitTop = 28
    ExplicitHeight = 551
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
    DockControlHeights = (
      0
      0
      28
      0)
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
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end>
    end
    inherited dxBarManagerBar2: TdxBar
      Visible = False
    end
    inherited dxbsColumns: TdxBarSubItem
      ShowCaption = False
    end
    inherited dxbbCreateBill: TdxBarButton
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton [13]
      Action = actApplyBestFit
      Category = 0
    end
    inherited dxBarButton13: TdxBarButton
      Down = True
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
