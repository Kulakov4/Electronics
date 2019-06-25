object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Database'
  ClientHeight = 636
  ClientWidth = 1215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object sbMain: TdxStatusBar
    Left = 0
    Top = 616
    Width = 1215
    Height = 20
    Panels = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object cxpcMain: TcxPageControl
    Left = 0
    Top = 28
    Width = 1215
    Height = 588
    Align = alClient
    TabOrder = 5
    Properties.ActivePage = cxtshComp
    Properties.CustomButtons.Buttons = <>
    OnChange = cxpcMainChange
    OnPageChanging = cxpcMainPageChanging
    ClientRectBottom = 584
    ClientRectLeft = 4
    ClientRectRight = 1211
    ClientRectTop = 27
    object cxtshComp: TcxTabSheet
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 0
      object cxpcComp2: TcxPageControl
        Left = 0
        Top = 0
        Width = 1207
        Height = 557
        Align = alClient
        TabOrder = 0
        Properties.ActivePage = cxtshCompGroup
        Properties.CustomButtons.Buttons = <>
        OnPageChanging = cxpcComp2PageChanging
        ClientRectBottom = 553
        ClientRectLeft = 4
        ClientRectRight = 1203
        ClientRectTop = 27
        object cxtshCompGroup: TcxTabSheet
          Caption = #1055#1086' '#1075#1088#1091#1087#1087#1072#1084
          ImageIndex = 0
          object pnlCompGroupLeft: TPanel
            Left = 0
            Top = 0
            Width = 253
            Height = 526
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
          end
          object cxspltrMain: TcxSplitter
            Left = 253
            Top = 0
            Width = 8
            Height = 526
            HotZoneClassName = 'TcxSimpleStyle'
            PositionAfterOpen = 200
            AutoSnap = True
            Control = pnlCompGroupLeft
          end
          object pnlCompGroupRight: TPanel
            Left = 261
            Top = 0
            Width = 938
            Height = 526
            Align = alClient
            TabOrder = 2
            object cxpcCompGroupRight: TcxPageControl
              Left = 1
              Top = 1
              Width = 936
              Height = 524
              Align = alClient
              TabOrder = 0
              Properties.ActivePage = cxtsCategory
              Properties.CustomButtons.Buttons = <>
              OnPageChanging = cxpcCompGroupRightPageChanging
              ClientRectBottom = 520
              ClientRectLeft = 4
              ClientRectRight = 932
              ClientRectTop = 27
              object cxtsCategory: TcxTabSheet
                Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1092#1091#1085#1082#1094#1080#1086#1085#1072#1083#1100#1085#1086#1081' '#1075#1088#1091#1087#1087#1099
                ImageIndex = 0
              end
              object cxtsCategoryComponents: TcxTabSheet
                Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1075#1088#1091#1087#1087#1099' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
                ImageIndex = 1
              end
              object cxtsCategoryParameters: TcxTabSheet
                Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
                ImageIndex = 2
              end
              object cxtsParametricTable: TcxTabSheet
                Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
                ImageIndex = 3
              end
            end
          end
        end
        object cxtshCompSearch: TcxTabSheet
          Caption = #1055#1086#1080#1089#1082
          ImageIndex = 1
        end
      end
      object pnlLoad: TPanel
        Left = 271
        Top = -3
        Width = 394
        Height = 26
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
    object cxtshWareHouse: TcxTabSheet
      Caption = #1057#1082#1083#1072#1076#1099
      ImageIndex = 1
      object cxpcWareHouse2: TcxPageControl
        Left = 0
        Top = 0
        Width = 1207
        Height = 557
        Align = alClient
        TabOrder = 0
        Properties.ActivePage = cxtshBill
        Properties.CustomButtons.Buttons = <>
        OnPageChanging = cxpcWareHouse2PageChanging
        ClientRectBottom = 553
        ClientRectLeft = 4
        ClientRectRight = 1203
        ClientRectTop = 27
        object cxtshWareHouse2: TcxTabSheet
          Caption = #1057#1082#1083#1072#1076#1099
          ImageIndex = 0
          object pnlStoreHouseLeft: TPanel
            Left = 0
            Top = 0
            Width = 253
            Height = 526
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
          end
          object cxSplitterStoreHouse: TcxSplitter
            Left = 253
            Top = 0
            Width = 8
            Height = 526
            HotZoneClassName = 'TcxSimpleStyle'
            Control = pnlStoreHouseLeft
          end
          object pnlStoreHouseRight: TPanel
            Left = 261
            Top = 0
            Width = 938
            Height = 526
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
        object cxtshBasket: TcxTabSheet
          Caption = #1050#1086#1088#1079#1080#1085#1072
          ImageIndex = 1
        end
        object cxtshBill: TcxTabSheet
          Caption = #1057#1095#1077#1090#1072
          ImageIndex = 2
          object pnlBillLeft: TPanel
            Left = 0
            Top = 0
            Width = 253
            Height = 526
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
          end
          object cxSplitter1: TcxSplitter
            Left = 253
            Top = 0
            Width = 8
            Height = 526
            HotZoneClassName = 'TcxSimpleStyle'
            Control = pnlBillLeft
          end
          object pnlBillCenter: TPanel
            Left = 261
            Top = 0
            Width = 938
            Height = 526
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
        object cxtshSearch: TcxTabSheet
          Caption = #1055#1086#1080#1089#1082
          ImageIndex = 3
        end
      end
    end
  end
  object bmMain: TdxBarManager
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    ShowHint = False
    UseSystemFont = False
    Left = 40
    Top = 104
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object dxbrMainBar1: TdxBar
      Caption = #1055#1072#1085#1077#1083#1100' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 815
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtm1'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbrMainBar2: TdxBar
      Caption = #1055#1072#1085#1077#1083#1100' '#1089' '#1080#1082#1086#1085#1082#1072#1084#1080
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 170
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 314
      FloatTop = 155
      FloatClientWidth = 51
      FloatClientHeight = 48
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnSettings'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1060#1072#1081#1083
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbbOptions'
        end
        item
          Visible = True
          ItemName = 'dxbrsprtr1'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn2'
        end>
    end
    object dxbrsbtm1: TdxBarSubItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtn3'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn5'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn6'
        end
        item
          Visible = True
          ItemName = 'dxbrbtn7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxbbOptions: TdxBarButton
      Action = actSelectDataBasePath
      Category = 0
    end
    object dxbrsprtr1: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object dxbrbtn2: TdxBarButton
      Action = actExit
      Category = 0
    end
    object dxbrbtn3: TdxBarButton
      Action = actShowProducers
      Category = 0
    end
    object dxbrbtn5: TdxBarButton
      Action = actShowParameters
      Category = 0
    end
    object dxbrbtn6: TdxBarButton
      Action = actShowDescriptions
      Category = 0
    end
    object dxbrbtn7: TdxBarButton
      Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      Category = 0
      Visible = ivNever
    end
    object dxbrbtnSettings: TdxBarButton
      Action = actSelectDataBasePath
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actShowBodyTypes3
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actSaveAll
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton10: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Action = actShowExtraCharge
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 48
    Top = 419
    object actShowProducers: TAction
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      OnExecute = actShowProducersExecute
    end
    object actShowDescriptions: TAction
      Caption = #1050#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
      OnExecute = actShowDescriptionsExecute
    end
    object actShowParameters: TAction
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      OnExecute = actShowParametersExecute
    end
    object actShowBodyTypes2: TAction
      Caption = 'actShowBodyTypes2'
      OnExecute = actShowBodyTypes2Execute
    end
    object actShowBodyTypes3: TAction
      Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
      OnExecute = actShowBodyTypes3Execute
    end
    object actSelectDataBasePath: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 30
      OnExecute = actSelectDataBasePathExecute
    end
    object actSaveAll: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1105
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1105
      ImageIndex = 3
      OnExecute = actSaveAllExecute
    end
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actLoadBodyTypes: TAction
      Caption = #1050#1086#1088#1087#1091#1089#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 25
    end
    object actShowExtraCharge: TAction
      Caption = #1054#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
      OnExecute = actShowExtraChargeExecute
    end
    object actComponentsTab: TAction
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      OnExecute = actComponentsTabExecute
    end
    object actTest: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 20
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    OnHint = ApplicationEventsHint
    Left = 172
    Top = 303
  end
end
