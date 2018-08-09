object ProductsFrame: TProductsFrame
  Left = 0
  Top = 0
  Width = 998
  Height = 635
  ParentShowHint = False
  ShowHint = False
  TabOrder = 0
  object cxpcStorehouse: TcxPageControl
    Left = 0
    Top = 28
    Width = 998
    Height = 607
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tsStorehouseSearch
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 603
    ClientRectLeft = 4
    ClientRectRight = 994
    ClientRectTop = 24
    object tsStorehouseInfo: TcxTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1082#1083#1072#1076#1077
      ImageIndex = 0
    end
    object tsStorehouseProducts: TcxTabSheet
      Caption = #1058#1086#1074#1072#1088#1099
      ImageIndex = 1
    end
    object tsStorehouseSearch: TcxTabSheet
      Caption = #1055#1086#1080#1089#1082
      ImageIndex = 2
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    ShowHint = False
    UseSystemFont = True
    Left = 64
    Top = 280
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Main'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 1008
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem3'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 20
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 29
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton2: TdxBarButton
      Action = actBindDescriptions
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 144
    Top = 280
    object actLoadFromExcelDocument: TAction
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actBindDescriptions: TAction
      Caption = #1050#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
      ImageIndex = 29
      OnExecute = actBindDescriptionsExecute
    end
  end
end
