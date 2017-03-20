object QueryBase: TQueryBase
  Left = 0
  Top = 0
  Width = 125
  Height = 80
  TabOrder = 0
  object Label1: TLabel
    Left = 6
    Top = 5
    Width = 74
    Height = 16
    Caption = 'QueryName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object FDQuery: TFDQuery
    BeforeOpen = FDQueryBeforeOpen
    Connection = DMRepository.dbConnection
    Left = 9
    Top = 25
  end
end
