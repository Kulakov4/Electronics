inherited QryBill2: TQryBill2
  inherited Label1: TLabel
    Width = 25
    Caption = 'Bill2'
    ExplicitWidth = 25
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct b.*'
      'from bill b'
      'join BillContent bc on bc.BillID = b.ID'
      'join StorehouseProducts sp on bc.StorehouseProductID = sp.Id'
      'where 0=0')
  end
end
