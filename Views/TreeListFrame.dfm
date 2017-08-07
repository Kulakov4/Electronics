object frmTreeList: TfrmTreeList
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 28
    Width = 320
    Height = 212
    Align = alClient
    Bands = <>
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.CellHints = True
    OptionsBehavior.HeaderHints = True
    OptionsCustomizing.BandVertSizing = False
    OptionsCustomizing.ColumnVertSizing = False
    OptionsSelection.HideFocusRect = False
    OptionsSelection.InvertSelect = False
    OptionsSelection.MultiSelect = True
    PopupMenu = PopupMenu
    RootValue = -1
    Styles.OnGetBandHeaderStyle = cxDBTreeListStylesGetBandHeaderStyle
    TabOrder = 0
    OnCustomDrawDataCell = cxDBTreeListCustomDrawDataCell
    OnEdited = cxDBTreeListEdited
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
    UseSystemFont = True
    Left = 72
    Top = 80
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
      FloatLeft = 330
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
  end
  object ActionList: TActionList
    Left = 168
    Top = 80
    object actCopy: TAction
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnExecute = actCopyExecute
    end
  end
  object PopupMenu: TPopupMenu
    Left = 168
    Top = 152
    object N1: TMenuItem
      Action = actCopy
    end
  end
end
