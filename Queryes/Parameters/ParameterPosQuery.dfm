inherited QueryParameterPos: TQueryParameterPos
  inherited Label1: TLabel
    Width = 92
    Caption = 'ParameterPos'
    ExplicitWidth = 92
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ParameterPos'
      'order by id')
  end
end
