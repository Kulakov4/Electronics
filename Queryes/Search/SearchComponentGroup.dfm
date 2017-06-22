inherited QuerySearchComponentGroup: TQuerySearchComponentGroup
  inherited Label1: TLabel
    Width = 156
    Caption = 'SearchComponentGroup'
    ExplicitWidth = 156
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ComponentGroups'
      'where 0=0')
  end
end
