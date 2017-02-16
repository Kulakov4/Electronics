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
      'SELECT p.Id,'
      '       p.DescriptionId,'
      '       p.Value,'
      '       GROUP_CONCAT(pc.ExternalId) subGroup,'
      '       p.ParentProductId,'
      '       Min(pc.ExternalId) CurCategoryExternalID,'
      '       pup.ID as IDProducer,'
      '       pup.Value as Producer,'
      '       pup2.ID as IDPackagePins,'
      '       pup2.Value as PackagePins,'
      '       pup3.ID as IDDatasheet,'
      '       pup3.Value as Datasheet,'
      '       pup4.ID as IDDiagram,'
      '       pup4.Value as Diagram,'
      '       pup5.ID as IDDrawing,'
      '       pup5.Value as Drawing,'
      '       pup6.ID as IDImage,'
      '       pup6.Value as Image,'
      '       d.Description'
      'FROM Products p'
      'JOIN ProductProductCategories ppc ON p.Id = ppc.ProductId'
      
        'JOIN ProductCategories pc ON pc.Id = ppc.ProductCategoryId      ' +
        ' '
      
        'left join ProductUnionParameters pup on pup.ProductID = p.Id and' +
        ' pup.UnionParameterId = :ProducerParameterID'
      
        'left join ProductUnionParameters pup2 on pup2.ProductID = p.Id a' +
        'nd pup2.UnionParameterId = :PackagePinsParameterID'
      
        'left join ProductUnionParameters pup3 on pup3.ProductID = p.Id a' +
        'nd pup3.UnionParameterId = :DatasheetParameterID'
      
        'left join ProductUnionParameters pup4 on pup4.ProductID = p.Id a' +
        'nd pup4.UnionParameterId = :DiagramParameterID'
      
        'left join ProductUnionParameters pup5 on pup5.ProductID = p.Id a' +
        'nd pup5.UnionParameterId = :DrawingParameterID'
      
        'left join ProductUnionParameters pup6 on pup6.ProductID = p.Id a' +
        'nd pup6.UnionParameterId = :ImageParameterID'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      
        'WHERE instr('#39','#39' || :IDList || '#39','#39'   ,    '#39','#39' || p.Id || '#39','#39') > 0' +
        ' '
      '      AND ParentProductId IS NULL'
      'GROUP BY p.Id'
      'ORDER BY p.value')
    ParamData = <
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
      end
      item
        Name = 'IDLIST'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
