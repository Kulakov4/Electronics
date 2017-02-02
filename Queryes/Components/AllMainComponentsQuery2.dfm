inherited QueryAllMainComponents2: TQueryAllMainComponents2
  inherited Label1: TLabel
    Width = 126
    Caption = 'AllMainComponents'
    ExplicitWidth = 126
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select p.*'
      'from Products p'
      'where p.ParentProductId is null')
  end
end
