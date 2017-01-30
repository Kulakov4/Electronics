object QuerySearch: TQuerySearch
  Left = 0
  Top = 0
  Width = 139
  Height = 100
  TabOrder = 0
  object LabelSearch: TLabel
    Left = 16
    Top = 16
    Width = 63
    Height = 13
    Caption = 'SearchQuery'
  end
  object FDQuery: TFDQuery
    Connection = DMRepository.dbConnection
    Left = 16
    Top = 48
  end
end
