inherited QueryVersion: TQueryVersion
  inherited Label1: TLabel
    Width = 49
    Caption = 'Version'
    ExplicitWidth = 49
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from dbVersion')
  end
end
