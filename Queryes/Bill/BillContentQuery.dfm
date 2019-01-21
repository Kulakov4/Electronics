inherited QueryBillContent: TQueryBillContent
  inherited Label1: TLabel
    Width = 69
    Caption = 'BillContent'
    ExplicitWidth = 69
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BillContent'
      'order by BillID')
  end
end
