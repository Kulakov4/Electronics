inherited QryBill: TQryBill
  inherited Label1: TLabel
    Width = 17
    Caption = 'Bill'
    ExplicitWidth = 17
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ID, Number, BillDate, Dollar, Euro, ShipmentDate, Width'
      'from bill'
      'where (0=0) and (1=1)')
  end
end
