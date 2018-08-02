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
      'select ID, cast(L || '#39'-'#39' || H as VARCHAR(30)) Range, WholeSale'
      'FROM ExtraCharge'
      'ORDER BY L')
  end
end
