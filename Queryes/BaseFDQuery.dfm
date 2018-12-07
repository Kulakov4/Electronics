object QryBase: TQryBase
  Left = 0
  Top = 0
  Width = 205
  Height = 75
  TabOrder = 0
  object FDQuery: TFDQuery
    Connection = DMRepository.dbConnection
    FetchOptions.AssignedValues = [evItems, evCache]
    Left = 24
    Top = 16
  end
end
