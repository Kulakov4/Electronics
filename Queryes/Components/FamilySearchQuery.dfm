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
      '    from ParameterValues pv'
      '    where '
      '    pv.ParameterId = :PackagePinsParameterID'
      '    group by pv.ProductId'
      ') PackagePins on PackagePins.ProductId = p.id'
      
        'LEFT JOIN ParameterValues pv ON pv.ProductID = p.Id AND pv.Param' +
        'eterId = :ProducerParameterID'
      
        'LEFT JOIN ParameterValues pv3 ON pv3.ProductID = p.Id AND pv3.Pa' +
        'rameterId = :DatasheetParameterID'
      
        'LEFT JOIN ParameterValues pv4 ON pv4.ProductID = p.Id AND pv4.Pa' +
        'rameterId = :DiagramParameterID'
      
        'LEFT JOIN ParameterValues pv5 ON pv5.ProductID = p.Id AND pv5.Pa' +
        'rameterId = :DrawingParameterID'
      
        'LEFT JOIN ParameterValues pv6 ON pv6.ProductID = p.Id AND pv6.Pa' +
        'rameterId = :ImageParameterID'
      ''
      
        'WHERE instr('#39','#39' || :IDList || '#39','#39'   ,    '#39','#39' || p.Id || '#39','#39') > 0' +
        ' '
      '      AND p.ParentProductId IS NULL')
    ParamData = <
      item
        Name = 'PACKAGEPINSPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCERPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DATASHEETPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DIAGRAMPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DRAWINGPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IMAGEPARAMETERID'
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
