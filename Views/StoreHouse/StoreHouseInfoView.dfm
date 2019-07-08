object ViewStorehouseInfo: TViewStorehouseInfo
  Left = 0
  Top = 0
  Width = 558
  Height = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object lblTitle: TcxLabel
    Left = 11
    Top = 11
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
    ParentColor = False
  end
  object lblExternalId: TcxLabel
    Left = 11
    Top = 79
    Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
    ParentColor = False
  end
  object lblResponsible: TcxLabel
    Left = 11
    Top = 114
    Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1077' '#1083#1080#1094#1086
    ParentColor = False
  end
  object lblAddress: TcxLabel
    Left = 11
    Top = 152
    Caption = #1040#1076#1088#1077#1089
    ParentColor = False
  end
  object cxTeResponsible: TcxDBTextEdit
    Left = 152
    Top = 114
    DataBinding.DataField = 'Responsible'
    TabOrder = 1
    Width = 385
  end
  object cxdbmAddress: TcxDBMemo
    Left = 152
    Top = 152
    DataBinding.DataField = 'Address'
    TabOrder = 2
    Height = 66
    Width = 385
  end
  object cxdbteAbbreviation: TcxDBTextEdit
    Left = 152
    Top = 79
    DataBinding.DataField = 'Abbreviation'
    TabOrder = 0
    Width = 385
  end
  object cxdbmTitle: TcxDBMemo
    Left = 152
    Top = 11
    DataBinding.DataField = 'Title'
    TabOrder = 7
    Height = 57
    Width = 385
  end
end
