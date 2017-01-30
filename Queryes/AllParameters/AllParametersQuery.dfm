inherited QueryAllParameters: TQueryAllParameters
  inherited Label1: TLabel
    Width = 92
    Caption = 'AllParameters'
    ExplicitWidth = 92
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select  *'
      'from UnionParameters'
      'order by ParentParameter')
  end
end
