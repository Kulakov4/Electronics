inherited QryMaxBillNumber: TQryMaxBillNumber
  inherited Label1: TLabel
    Width = 92
    Caption = 'MaxBillNumber'
    ExplicitWidth = 92
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from bill'
      
        'where number = (select ifnull(max(number), 0) MaxNumber from bil' +
        'l)')
  end
end
