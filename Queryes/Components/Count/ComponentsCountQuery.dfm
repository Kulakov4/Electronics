inherited QueryComponentsCount: TQueryComponentsCount
  inherited Label1: TLabel
    Width = 118
    Caption = 'ComponentsCount'
    ExplicitWidth = 118
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select count(*) components_count'
      'from products'
      'where ParentProductId is not null')
  end
end
