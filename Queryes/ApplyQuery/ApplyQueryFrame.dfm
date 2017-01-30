object frmApplyQuery: TfrmApplyQuery
  Left = 0
  Top = 0
  Width = 129
  Height = 59
  TabOrder = 0
  object FDQuery: TFDQuery
    Connection = DMRepository.dbConnection
    UpdateObject = FDUpdateSQL
    Left = 8
    Top = 8
  end
  object FDUpdateSQL: TFDUpdateSQL
    Connection = DMRepository.dbConnection
    Left = 72
    Top = 8
  end
end
