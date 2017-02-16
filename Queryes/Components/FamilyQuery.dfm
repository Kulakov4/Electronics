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
      '       pup.ID AS IDProducer,'
      '       pup.Value AS Producer,'
      '       pup2.ID AS IDPackagePins,'
      '       pup2.Value AS PackagePins,'
      '       pup3.ID AS IDDatasheet,'
      '       pup3.Value AS Datasheet,'
      '       pup4.ID AS IDDiagram,'
      '       pup4.Value AS Diagram,'
      '       pup5.ID AS IDDrawing,'
      '       pup5.Value AS Drawing,'
      '       pup6.ID AS IDImage,'
      '       pup6.Value AS Image,'
      '       d.Description'
      '  FROM '
      'ProductProductCategories ppc'
      
        'JOIN Products p ON ppc.ProductId = p.Id AND p.ParentProductId IS' +
        ' NULL'
      'JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.Id'
      'JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategoryId'
      
        'LEFT JOIN ProductUnionParameters pup ON pup.ProductID = p.Id AND' +
        ' pup.UnionParameterId = :ProducerParameterID'
      
        'LEFT JOIN ProductUnionParameters pup2 ON pup2.ProductID = p.Id A' +
        'ND pup2.UnionParameterId = :PackagePinsParameterID'
      
        'LEFT JOIN ProductUnionParameters pup3 ON pup3.ProductID = p.Id A' +
        'ND pup3.UnionParameterId = :DatasheetParameterID'
      
        'LEFT JOIN ProductUnionParameters pup4 ON pup4.ProductID = p.Id A' +
        'ND pup4.UnionParameterId = :DiagramParameterID'
      
        'LEFT JOIN ProductUnionParameters pup5 ON pup5.ProductID = p.Id A' +
        'ND pup5.UnionParameterId = :DrawingParameterID'
      
        'LEFT JOIN ProductUnionParameters pup6 ON pup6.ProductID = p.Id A' +
        'ND pup6.UnionParameterId = :ImageParameterID'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'WHERE ppc.ProductCategoryId = :vProductCategoryId'
      'GROUP BY p.ID'
      'ORDER BY p.value'
      '')
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
