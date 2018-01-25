inherited QuerySubParameters2: TQuerySubParameters2
  inherited Label1: TLabel
    Width = 100
    Caption = 'SubParameters'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from SubParameters')
  end
end
