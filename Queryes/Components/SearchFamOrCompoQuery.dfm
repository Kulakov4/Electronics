inherited QuerySearchFamilyOrComp: TQuerySearchFamilyOrComp
  inherited Label1: TLabel
    Width = 143
    Caption = 'SearchFamOrCompQry'
    ExplicitWidth = 143
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    Id'
      'from'
      '    Products'
      'where '
      '    (0=0) and (1=1)  ')
  end
end
