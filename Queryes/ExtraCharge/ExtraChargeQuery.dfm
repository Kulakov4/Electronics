inherited QueryExtraCharge: TQueryExtraCharge
  Width = 133
  ExplicitWidth = 133
  inherited Label1: TLabel
    Width = 80
    Caption = 'ExtraCharge'
    ExplicitWidth = 80
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ID, L || '#39'-'#39' || H Range, WholeSale'
      'FROM ExtraCharge'
      'ORDER BY L')
  end
end
