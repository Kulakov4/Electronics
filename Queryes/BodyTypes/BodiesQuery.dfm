inherited QueryBodies: TQueryBodies
  inherited Label1: TLabel
    Width = 42
    Caption = 'Bodies'
    ExplicitWidth = 42
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from Bodies')
  end
end
