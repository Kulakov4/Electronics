inherited QueryComponentsDetailCount: TQueryComponentsDetailCount
  inherited Label1: TLabel
    Width = 155
    Caption = 'ComponentsDetailCount'
    ExplicitWidth = 155
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select count(*) components_count'
      'from products'
      'where ParentProductId is not null')
  end
end
