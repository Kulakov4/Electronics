inherited QryBill: TQryBill
  inherited Label1: TLabel
    Width = 17
    Caption = 'Bill'
    ExplicitWidth = 17
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from bill')
  end
end
