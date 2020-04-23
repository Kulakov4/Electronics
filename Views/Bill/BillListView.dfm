inherited ViewBill: TViewBill
  inherited cxGrid: TcxGrid
    Top = 86
    Height = 386
    ExplicitTop = 82
    ExplicitHeight = 390
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnEditing = cxGridDBBandedTableViewEditing
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
    end
  end
  object PopupPanel: TPanel [2]
    Left = 248
    Top = 304
    Width = 161
    Height = 97
    TabOrder = 6
    Visible = False
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 88
      Height = 18
      Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
    end
    object DateTimePicker: TDateTimePicker
      Left = 10
      Top = 34
      Width = 138
      Height = 21
      Date = 43802.000000000000000000
      Time = 0.711747812500107100
      TabOrder = 0
    end
    object cxPopupBtnOK: TcxButton
      Left = 74
      Top = 64
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cxPopupBtnOKClick
    end
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      86
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxbbShip'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = #1060#1080#1083#1100#1090#1088
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 903
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
          ItemName = 'cxbeiPeriodComboBox'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 117
          Visible = True
          ItemName = 'cxbeiShippedComboBox'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = True
      Visible = True
      WholeRow = False
    end
    object dxbmbPeriod: TdxBar [2]
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 57
      DockingStyle = dsTop
      FloatLeft = 903
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Calibri'
      Font.Style = []
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          UserDefine = [udWidth]
          UserWidth = 87
          Visible = True
          ItemName = 'cxbeiBeginDate'
        end
        item
          Visible = True
          ItemName = 'cxbeiEndDate'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
      OneOnRow = True
      Row = 2
      UseOwnFont = True
      Visible = True
      WholeRow = False
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = actDeleteEx
      Category = 0
    end
    object dxbbShip: TdxBarButton
      Action = actShip
      Category = 0
    end
    object cxbeiPeriodComboBox: TcxBarEditItem
      Caption = #1055#1077#1088#1080#1086#1076
      Category = 0
      Hint = #1055#1077#1088#1080#1086#1076
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #1055#1088#1086#1080#1079#1074#1086#1083#1100#1085#1086
        #1057#1077#1075#1086#1076#1085#1103
        '7 '#1076#1085#1077#1081
        '30 '#1076#1085#1077#1081
        '90 '#1076#1085#1077#1081
        '365 '#1076#1085#1077#1081)
      Properties.OnEditValueChanged = cxbeiPeriodComboBoxPropertiesEditValueChanged
      InternalEditValue = '30 '#1076#1085#1077#1081
    end
    object cxbeiBeginDate: TcxBarEditItem
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
      Category = 0
      Hint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
      Visible = ivAlways
      OnChange = cxbeiBeginDateChange
      Width = 90
      PropertiesClassName = 'TcxDateEditProperties'
    end
    object cxbeiEndDate: TcxBarEditItem
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Category = 0
      Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Visible = ivAlways
      OnChange = cxbeiEndDateChange
      Width = 90
      PropertiesClassName = 'TcxDateEditProperties'
    end
    object dxBarButton3: TdxBarButton
      Action = actApplyCustomFilter
      Category = 0
      PaintStyle = psCaptionInMenu
    end
    object cxbeiShippedComboBox: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = #1058#1080#1087' '#1089#1095#1105#1090#1072
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #1042#1089#1077
        #1054#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077
        #1053#1077#1086#1090#1075#1088#1091#1078#1077#1085#1085#1099#1077)
      Properties.OnEditValueChanged = cxbeiShippedComboBoxPropertiesEditValueChanged
      InternalEditValue = #1042#1089#1077
    end
    object dxBarButton4: TdxBarButton
      Action = actEdit
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
  end
  inherited ActionList: TActionList
    inherited actDeleteEx: TAction
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1095#1105#1090
    end
    object actShip: TAction
      Caption = #1054#1090#1075#1088#1091#1079#1080#1090#1100
      Hint = #1054#1090#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 48
      OnExecute = actShipExecute
    end
    object actApplyCustomFilter: TAction
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      ImageIndex = 28
      OnExecute = actApplyCustomFilterExecute
    end
    object actEdit: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1095#1105#1090
      ImageIndex = 18
      OnExecute = actEditExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
  end
  object dxCalloutPopup: TdxCalloutPopup
    PopupControl = PopupPanel
    OnHide = dxCalloutPopupHide
    OnShow = dxCalloutPopupShow
    Left = 144
    Top = 208
  end
end
