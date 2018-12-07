inherited QueryExtraChargeSimple: TQueryExtraChargeSimple
  inherited Label1: TLabel
    Width = 121
    Caption = 'ExtraChargeSimple'
    ExplicitWidth = 121
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ExtraCharge2'
      'where 0=0')
  end
end
