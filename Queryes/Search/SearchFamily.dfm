inherited QuerySearchFamily: TQuerySearchFamily
  Width = 162
  ExplicitWidth = 162
  inherited Label1: TLabel
    Width = 84
    Caption = 'SearchFamily'
    ExplicitWidth = 84
  end
  object fdqBase: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*'
      '    ,GROUP_CONCAT(pc.ExternalId) subGroup'
      '/* ComponentGroup'
      '    ,GROUP_CONCAT(pc.Value) ComponentGroup'
      'ComponentGroup */'
      '    ,GROUP_CONCAT(pc.id) CategoryIDList'
      '/* ParametersValues'
      '    ,pv.ID as IDProducer'
      '    ,pv.Value as Producer'
      '    ,pv2.ID as IDPackagePins'
      '    ,pv2.Value as PackagePins'
      '    ,pv3.ID as IDDatasheet'
      '    ,pv3.Value as Datasheet'
      '    ,pv4.ID as IDDiagram'
      '    ,pv4.Value as Diagram'
      '    ,pv5.ID as IDDrawing'
      '    ,pv5.Value as Drawing'
      '    ,pv6.ID as IDImage'
      '    ,pv6.Value as Image'
      'ParametersValues */'
      '/* Description'
      '    ,d.ComponentName DescriptionComponentName'
      '    ,d.Description'
      'Description */'
      'from Products p'
      'JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.Id'
      'JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategoryId'
      '/* ParametersValues'
      
        'left join ParameterValues2 pv on pv.ProductID = p.Id and pv.Para' +
        'mSubParamId = :ProducerParamSubParamID'
      
        'left join ParameterValues2 pv2 on pv2.ProductID = p.Id and pv2.P' +
        'aramSubParamId = :PackagePinsParamSubParamID'
      
        'left join ParameterValues2 pv3 on pv3.ProductID = p.Id and pv3.P' +
        'aramSubParamId = :DatasheetParamSubParamID'
      
        'left join ParameterValues2 pv4 on pv4.ProductID = p.Id and pv4.P' +
        'aramSubParamId = :DiagramParamSubParamID'
      
        'left join ParameterValues2 pv5 on pv5.ProductID = p.Id and pv5.P' +
        'aramSubParamId = :DrawingParamSubParamID'
      
        'left join ParameterValues2 pv6 on pv6.ProductID = p.Id and pv6.P' +
        'aramSubParamId = :ImageParamSubParamID'
      'ParametersValues */'
      '/* Description'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'Description */'
      'where 0=0  --p.ID = :ID '
      'and p.ParentProductId is null'
      'GROUP BY p.Id')
    Left = 64
    Top = 25
  end
end
