inherited QuerySearchComponentOrFamily: TQuerySearchComponentOrFamily
  inherited Label1: TLabel
    Width = 118
    Caption = 'SearchComponent'
    ExplicitWidth = 118
  end
  object fdqBase: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*'
      '/* Producer'
      ',pv.Value Producer    '
      'Producer */'
      'from'
      '  Products p'
      '/* Producer  '
      '  join Products f on p.ParentProductId = f.id'
      
        '  join ParameterValues2 pv on pv.ProductID = f.Id and pv.ParamSu' +
        'bParamId = :ProducerParamSubParamID'
      '  and 1=1 --and pv.Value = :Producer  '
      'Producer */  '
      'where 0=0')
    Left = 72
    Top = 25
  end
end
