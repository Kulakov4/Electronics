inherited QueryBillContentSimple: TQueryBillContentSimple
  inherited Label1: TLabel
    Width = 69
    Caption = 'BillContent'
    ExplicitWidth = 69
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BillContent'
      'where (0=0)')
  end
end
