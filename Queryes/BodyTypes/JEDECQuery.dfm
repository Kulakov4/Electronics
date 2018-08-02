inherited QueryJEDEC: TQueryJEDEC
  inherited Label1: TLabel
    Width = 37
    Caption = 'JEDEC'
    ExplicitWidth = 37
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from JEDEC'
      'order by JEDEC')
  end
end
