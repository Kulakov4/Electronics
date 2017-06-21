inherited QueryComponentGroups: TQueryComponentGroups
  inherited Label1: TLabel
    Width = 118
    Caption = 'ComponentGroups'
    ExplicitWidth = 118
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ComponentGroups'
      'order by ComponentGroup')
  end
end
