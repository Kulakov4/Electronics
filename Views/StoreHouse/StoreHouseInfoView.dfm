object ViewStorehouseInfo: TViewStorehouseInfo
  Left = 0
  Top = 0
  Width = 590
  Height = 429
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  OnClick = FrameClick
  object lblTitle: TcxLabel
    Left = 11
    Top = 11
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
    ParentColor = False
  end
  object lblExternalId: TcxLabel
    Left = 11
    Top = 38
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
    ParentColor = False
  end
  object lblResponsible: TcxLabel
    Left = 11
    Top = 65
    Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1077' '#1083#1080#1094#1086
    ParentColor = False
  end
  object lblAddress: TcxLabel
    Left = 11
    Top = 92
    Caption = #1040#1076#1088#1077#1089
    ParentColor = False
  end
  object cxTeTitle: TcxDBTextEdit
    Left = 152
    Top = 10
    DataBinding.DataField = 'Title'
    TabOrder = 4
    Width = 385
  end
  object cxTeResponsible: TcxDBTextEdit
    Left = 152
    Top = 64
    DataBinding.DataField = 'Responsible'
    TabOrder = 5
    Width = 385
  end
  object cxdbmAddress: TcxDBMemo
    Left = 152
    Top = 91
    DataBinding.DataField = 'Address'
    TabOrder = 6
    Height = 66
    Width = 385
  end
  object cxmeExternalId: TcxDBMaskEdit
    Left = 152
    Top = 37
    DataBinding.DataField = 'ExternalId'
    Properties.EditMask = '999;1;0'
    Properties.MaxLength = 0
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 385
  end
end
