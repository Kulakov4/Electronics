inherited QueryFamily: TQueryFamily
  Width = 284
  Height = 76
  ExplicitWidth = 284
  ExplicitHeight = 76
  inherited Label1: TLabel
    Width = 39
    Caption = 'Family'
    ExplicitWidth = 39
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'SELECT p.Id,'
      '       p.DescriptionId,'
      '       p.Value,'
      '       GROUP_CONCAT(pc.ExternalId) subGroup,'
      '       p.ParentProductId,'
      '       ppc.rowid,'
      '       ('
      '           SELECT ExternalID'
      '             FROM ProductCategories'
      '            WHERE ProductCategories.Id = :vProductCategoryId'
      '       )'
      '       CurCategoryExternalID,'
      '       pv.ID AS IDProducer,'
      '       pv.Value AS Producer,'
      '       pv2.ID AS IDPackagePins,'
      '       pv2.Value AS PackagePins,'
      '       pv3.ID AS IDDatasheet,'
      '       pv3.Value AS Datasheet,'
      '       pv4.ID AS IDDiagram,'
      '       pv4.Value AS Diagram,'
      '       pv5.ID AS IDDrawing,'
      '       pv5.Value AS Drawing,'
      '       pv6.ID AS IDImage,'
      '       pv6.Value AS Image,'
      '       d.Description'
      '  FROM '
      'ProductProductCategories ppc'
      
        'JOIN Products p ON ppc.ProductId = p.Id AND p.ParentProductId IS' +
        ' NULL'
      'JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.Id'
      'JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategoryId'
      
        'LEFT JOIN ParameterValues pv ON pv.ProductID = p.Id AND pv.Param' +
        'eterId = :ProducerParameterID'
      
        'LEFT JOIN ParameterValues pv2 ON pv2.ProductID = p.Id AND pv2.Pa' +
        'rameterId = :PackagePinsParameterID'
      
        'LEFT JOIN ParameterValues pv3 ON pv3.ProductID = p.Id AND pv3.Pa' +
        'rameterId = :DatasheetParameterID'
      
        'LEFT JOIN ParameterValues pv4 ON pv4.ProductID = p.Id AND pv4.Pa' +
        'rameterId = :DiagramParameterID'
      
        'LEFT JOIN ParameterValues pv5 ON pv5.ProductID = p.Id AND pv5.Pa' +
        'rameterId = :DrawingParameterID'
      
        'LEFT JOIN ParameterValues pv6 ON pv6.ProductID = p.Id AND pv6.Pa' +
        'rameterId = :ImageParameterID'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'WHERE ppc.ProductCategoryId = :vProductCategoryId'
      'GROUP BY p.ID'
      'ORDER BY p.value')
    ParamData = <
      item
        Name = 'VPRODUCTCATEGORYID'
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
        Name = 'PACKAGEPINSPARAMETERID'
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
      end>
  end
end
