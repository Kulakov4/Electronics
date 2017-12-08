inherited QueryParameterKinds: TQueryParameterKinds
  inherited Label1: TLabel
    Width = 103
    Caption = 'ParameterKinds'
    ExplicitWidth = 103
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ParameterKinds'
      'order by ID')
  end
end
