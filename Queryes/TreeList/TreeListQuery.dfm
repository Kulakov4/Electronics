inherited QueryTreeList: TQueryTreeList
  inherited Label1: TLabel
    Top = 11
    Width = 52
    Caption = 'TreeList'
    ExplicitTop = 11
    ExplicitWidth = 52
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select * from ProductCategories')
  end
end
