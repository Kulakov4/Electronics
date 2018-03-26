object DM2: TDM2
  Left = 0
  Top = 0
  Caption = 'DM2'
  ClientHeight = 251
  ClientWidth = 673
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline qVersion: TQueryVersion
    Left = 0
    Top = 0
    Width = 125
    Height = 80
    TabOrder = 0
  end
  inline qTreeList: TQueryTreeList
    Left = 144
    Top = 0
    Width = 125
    Height = 80
    TabOrder = 1
    ExplicitLeft = 144
  end
  inline qChildCategories: TQueryChildCategories
    Left = 291
    Top = 0
    Width = 199
    Height = 77
    TabOrder = 2
    ExplicitLeft = 291
    ExplicitHeight = 77
  end
  inline qProducts: TQueryProducts
    Left = 16
    Top = 104
    Width = 139
    Height = 77
    TabOrder = 3
    ExplicitLeft = 16
    ExplicitTop = 104
  end
  inline qStoreHouseList: TQueryStoreHouseList
    Left = 410
    Top = 101
    Width = 208
    Height = 86
    TabOrder = 5
    ExplicitLeft = 410
    ExplicitTop = 101
  end
  inline qProductsSearch: TQueryProductsSearch
    Left = 197
    Top = 104
    Width = 190
    Height = 83
    TabOrder = 4
    ExplicitLeft = 197
    ExplicitTop = 104
  end
end
