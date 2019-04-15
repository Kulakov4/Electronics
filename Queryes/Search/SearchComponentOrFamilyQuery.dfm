inherited QuerySearchComponentOrFamily: TQuerySearchComponentOrFamily
  inherited Label1: TLabel
    Width = 118
    Caption = 'SearchComponent'
    ExplicitWidth = 118
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*'
      '/* Producer'
      ',pv.Value Producer    '
      ',f.ID FamilyID'
      ',f.Value FamilyValue'
      'Producer */'
      'from'
      '  Products p'
      '/* Producer  '
      '  join Products f on p.ParentProductId = f.id'
      
        '  join ParameterValues2 pv on pv.ProductID = f.Id and pv.ParamSu' +
        'bParamId = :ProducerParamSubParamID'
      '  and 2=2 --and pv.Value = :Producer  '
      'Producer */  '
      'where (0=0) and (1=1)')
  end
end
