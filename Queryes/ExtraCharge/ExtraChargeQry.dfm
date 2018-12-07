inherited QryExtraCharge: TQryExtraCharge
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ID, cast(L || '#39'-'#39' || H as VARCHAR(30)) Range, WholeSale'
      'FROM ExtraCharge'
      'ORDER BY L')
  end
end
