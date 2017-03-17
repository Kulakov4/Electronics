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
      'SELECT '
      '  t.*, '
      
        '  trim(CurCategoryExternalID || REPLACE(subgroup2, '#39','#39'||CurCateg' +
        'oryExternalID||'#39','#39', '#39','#39'), '#39','#39') subGroup'
      'from'
      '('
      '    SELECT p.Id,'
      '       p.DescriptionId,'
      '       p.Value,'
      '       '#39','#39'||GROUP_CONCAT(pc.ExternalId,'#39','#39')||'#39','#39' subGroup2,'
      '       ('
      '           SELECT ExternalID'
      '           FROM ProductCategories'
      '           WHERE ProductCategories.Id = :vProductCategoryId'
      '       )'
      '       CurCategoryExternalID,'
      '       p.ParentProductId,'
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
      '   FROM '
      '       ProductProductCategories ppc'
      
        '       JOIN Products p ON ppc.ProductId = p.Id AND p.ParentProdu' +
        'ctId IS NULL'
      
        '       JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.' +
        'Id'
      
        '       JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategory' +
        'Id'
      
        '       LEFT JOIN ParameterValues pv ON pv.ProductID = p.Id AND p' +
        'v.ParameterId = :ProducerParameterID'
      
        '       LEFT JOIN ParameterValues pv2 ON pv2.ProductID = p.Id AND' +
        ' pv2.ParameterId = :PackagePinsParameterID'
      
        '       LEFT JOIN ParameterValues pv3 ON pv3.ProductID = p.Id AND' +
        ' pv3.ParameterId = :DatasheetParameterID'
      
        '       LEFT JOIN ParameterValues pv4 ON pv4.ProductID = p.Id AND' +
        ' pv4.ParameterId = :DiagramParameterID'
      
        '       LEFT JOIN ParameterValues pv5 ON pv5.ProductID = p.Id AND' +
        ' pv5.ParameterId = :DrawingParameterID'
      
        '       LEFT JOIN ParameterValues pv6 ON pv6.ProductID = p.Id AND' +
        ' pv6.ParameterId = :ImageParameterID       '
      '       LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      '       WHERE ppc.ProductCategoryId = :vProductCategoryId'
      '       GROUP BY p.ID'
      ') t'
      'ORDER BY t.value')
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
