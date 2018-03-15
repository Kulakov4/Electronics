inherited QueryFamilySearch: TQueryFamilySearch
  Width = 267
  Height = 85
  ExplicitWidth = 267
  ExplicitHeight = 85
  inherited Label1: TLabel
    Width = 84
    Caption = 'FamilySearch'
    ExplicitWidth = 84
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select'
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
      '  , PackagePins.ValueSet PackagePins'
      '  , cat.ExternalID'
      '  , cat.ExternalIDSet subGroup'
      'from Products p'
      'join'
      '('
      
        '    select ppc.ProductID, GROUP_CONCAT(pc.ExternalID,'#39','#39') Extern' +
        'alIDSet, min(pc.ExternalID) ExternalID'
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
      ''
      
        'WHERE instr('#39','#39' || :IDList || '#39','#39'   ,    '#39','#39' || p.Id || '#39','#39') > 0' +
        ' '
      '      AND p.ParentProductId IS NULL')
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
        Name = 'IDLIST'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
