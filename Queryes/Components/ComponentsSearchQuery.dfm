inherited QueryComponentsSearch: TQueryComponentsSearch
  inherited Label1: TLabel
    Width = 125
    Caption = 'ComponentsSearch'
    ExplicitWidth = 125
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '  p.*,'
      '  '#39#39' Producer, '
      '  pv2.ID AS IDPackagePins,'
      '  pv2.Value AS PackagePins,'
      '  '#39#39' Datasheet,'
      '  '#39#39' Diagram,'
      '  '#39#39' Drawing,'
      '  '#39#39' Image,'
      '  '#39#39' DescriptionComponentName,'
      '  '#39#39' Description'
      'from Products p'
      
        'LEFT JOIN ParameterValues2 pv2 ON pv2.ProductID = p.Id AND pv2.P' +
        'aramSubParamId = :PackagePinsParamSubParamID'
      'where (0=0)'
      'order by ParentProductId')
    ParamData = <
      item
        Name = 'PACKAGEPINSPARAMSUBPARAMID'
        ParamType = ptInput
      end>
  end
end
