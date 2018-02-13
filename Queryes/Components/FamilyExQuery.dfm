inherited QueryFamilyEx: TQueryFamilyEx
  inherited Label1: TLabel
    Width = 53
    Caption = 'FamilyEx'
    ExplicitWidth = 53
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '  t.*'
      
        '  ,trim(ExternalID || REPLACE(subgroup2, '#39','#39'||ExternalID||'#39','#39', '#39 +
        ','#39'), '#39','#39') subGroup'
      'from'
      '('
      'select '
      '  p.*'
      '  , pv.ID AS IDProducer'
      '  , pv.Value AS Producer'
      '  , pv3.ID AS IDDatasheet'
      '  , pv3.Value AS Datasheet'
      '  , pv4.ID AS IDDiagram'
      '  , pv4.Value AS Diagram'
      '  , pv5.ID AS IDDrawing'
      '  , pv5.Value AS Drawing'
      '  , pv6.ID AS IDImage'
      '  , pv6.Value AS Image'
      '  , d.ComponentName DescriptionComponentName'
      '  , d.Description  '
      '  , pc.ExternalId'
      '  , PackagePins.ValueSet PackagePins'
      '  ,'#39','#39'||cat.ExternalIDSet||'#39','#39' subGroup2'
      '  ,  case when fa.FamilyId is null then 0 else 1 end analog'
      'from ProductProductCategories ppc'
      'join ProductCategories pc on ppc.ProductCategoryId = pc.Id'
      'join Products p on ppc.ProductId = p.id'
      'join'
      '('
      
        '    select ppc.ProductID, GROUP_CONCAT(pc.ExternalID,'#39','#39') Extern' +
        'alIDSet'
      '    from ProductProductCategories ppc'
      '    JOIN ProductCategories pc ON pc.Id = ppc.ProductCategoryId'
      '    group by ppc.ProductID'
      ') Cat on cat.ProductID = p.id'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'left join'
      '('
      '    select pv.ProductId, GROUP_CONCAT(pv.Value,'#39','#39') ValueSet'
      '    from ParameterValues2 pv'
      '    where '
      '    pv.ParamSubParamId = :PackagePinsParamSubParamID'
      '    group by pv.ProductId'
      ') PackagePins on PackagePins.ProductId = p.id'
      
        'LEFT JOIN ParameterValues2 pv ON pv.ProductID = p.Id AND pv.Para' +
        'mSubParamId = :ProducerParamSubParamID'
      
        'LEFT JOIN ParameterValues2 pv3 ON pv3.ProductID = p.Id AND pv3.P' +
        'aramSubParamId = :DatasheetParamSubParamID'
      
        'LEFT JOIN ParameterValues2 pv4 ON pv4.ProductID = p.Id AND pv4.P' +
        'aramSubParamId = :DiagramParamSubParamID'
      
        'LEFT JOIN ParameterValues2 pv5 ON pv5.ProductID = p.Id AND pv5.P' +
        'aramSubParamId = :DrawingParamSubParamID'
      
        'LEFT JOIN ParameterValues2 pv6 ON pv6.ProductID = p.Id AND pv6.P' +
        'aramSubParamId = :ImageParamSubParamID'
      'LEFT JOIN FamilyAnalog fa on fa.FamilyId = p.Id'
      'where ppc.ProductCategoryId = :vProductCategoryId'
      ') t')
    ParamData = <
      item
        Name = 'PACKAGEPINSPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCERPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DATASHEETPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DIAGRAMPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DRAWINGPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IMAGEPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'VPRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
