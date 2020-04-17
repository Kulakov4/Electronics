inherited ViewProductsBase1: TViewProductsBase1
  inherited cxDBTreeList: TcxDBTreeList
    Top = 58
    Height = 521
    ExplicitTop = 58
    ExplicitHeight = 521
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
    ExplicitTop = 585
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      58
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
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end>
    end
    object dxBarManagerBar2: TdxBar [1]
      Caption = 'Price'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 29
      DockingStyle = dsTop
      FloatLeft = 1187
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Calibri'
      Font.Style = []
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxbeiExtraChargeType'
        end
        item
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
      OneOnRow = True
      Row = 1
      UseOwnFont = True
      Visible = True
      WholeRow = False
    end
    object cxbeiExtraChargeType: TcxBarEditItem
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Category = 0
      Hint = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxLookupComboBoxProperties'
      Properties.ListColumns = <>
      Properties.ListOptions.ShowHeader = False
      Properties.OnChange = cxbeiExtraChargeTypePropertiesChange
    end
    object cxbeiExtraCharge: TcxBarEditItem
      Caption = #1050#1086#1083'-'#1074#1086
      Category = 0
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090'.'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxPopupEditProperties'
      Properties.PopupAutoSize = False
      Properties.PopupHeight = 300
      Properties.PopupMinWidth = 350
      Properties.PopupSysPanelStyle = True
      Properties.PopupWidth = 400
      Properties.ReadOnly = True
    end
    object dxbcWholeSale: TdxBarCombo
      Caption = #1054#1087#1090'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1054#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcWholeSaleChange
      ShowCaption = True
      Width = 70
      OnDrawItem = dxbcWholeSaleDrawItem
      Items.Strings = (
        '')
      ItemIndex = -1
    end
    object dxbcMinWholeSale: TdxBarCombo
      Caption = #1052#1080#1085'. '#1086#1087#1090'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1086#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcMinWholeSaleChange
      ShowCaption = True
      Width = 70
      Text = '10'
      OnDrawItem = dxbcWholeSaleDrawItem
      Items.Strings = (
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15')
      ItemIndex = 2
    end
    object dxbbRubToDollar: TdxBarButton
      Action = actRubToDollar
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxbcRetail: TdxBarCombo
      Caption = #1056#1086#1079#1085'. '#1085#1072#1094#1077#1085#1082#1072
      Category = 0
      Hint = #1056#1086#1079#1085'. '#1085#1072#1094#1077#1085#1082#1072
      Visible = ivAlways
      OnChange = dxbcRetailChange
      ShowCaption = True
      Width = 70
      Text = '100'
      OnDrawItem = dxbcWholeSaleDrawItem
      Items.Strings = (
        '5'
        '10'
        '15'
        '20'
        '25'
        '30'
        '35'
        '40'
        '45'
        '50'
        '55'
        '60'
        '65'
        '70'
        '75'
        '80'
        '85'
        '90'
        '95'
        '100')
      ItemIndex = -1
    end
  end
  inherited ActionList: TActionList
    object actRubToDollar: TAction
      Caption = #8381'-$'
      Hint = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' '#1079#1072#1082#1091#1087#1086#1095#1085#1099#1077' '#1094#1077#1085#1099' '#1074' '#8381' '#1082' '#1082#1091#1088#1089#1091'$'
      OnExecute = actRubToDollarExecute
    end
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1072' '#1089#1076#1077#1083#1072#1085#1085#1099#1093' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actCreateBill: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1105#1090
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1089#1095#1105#1090
      ImageIndex = 45
      OnExecute = actCreateBillExecute
    end
    object actOpenInParametricTable: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 34
      OnExecute = actOpenInParametricTableExecute
    end
    object actClearPrice: TAction
      Caption = #1054#1095#1080#1089#1090#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081
      Hint = #1054#1095#1080#1089#1090#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081
      ImageIndex = 10
      OnExecute = actClearPriceExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
