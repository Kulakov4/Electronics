inherited QueryExtraCharge2: TQueryExtraCharge2
  inherited Label1: TLabel
    Width = 88
    Caption = 'ExtraCharge2'
    ExplicitWidth = 88
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvCheckReadOnly]
    UpdateOptions.CheckReadOnly = False
    SQL.Strings = (
      
        'select ID, IDExtraChargeType, cast(L || '#39'-'#39' || H as VARCHAR(30))' +
        ' Range, WholeSale'
      'FROM ExtraCharge2'
      'ORDER BY IDExtraChargeType, L')
  end
end
