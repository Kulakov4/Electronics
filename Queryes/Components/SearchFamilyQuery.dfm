inherited QrySearchFamily: TQrySearchFamily
  inherited Label1: TLabel
    Width = 106
    Caption = #1055#1086#1080#1089#1082' '#1089#1077#1084#1077#1081#1089#1090#1074
    ExplicitWidth = 106
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '  ParentProductId'
      'from'
      '    Products'
      'where '
      '    (0=0) and (ParentProductId is not null)')
  end
end
