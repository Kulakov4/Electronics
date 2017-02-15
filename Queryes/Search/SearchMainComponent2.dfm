inherited QuerySearchMainComponent2: TQuerySearchMainComponent2
  inherited Label1: TLabel
    Width = 148
    Caption = 'SearchMainComponent'
    ExplicitWidth = 148
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*,'
      '    GROUP_CONCAT(pc.ExternalId) subGroup,'
      '    GROUP_CONCAT(pc.id) CategoryIDList,'
      '    pup.ID as IDProducer,'
      '    pup.Value as Producer,'
      '    pup2.ID as IDPackagePins,'
      '    pup2.Value as PackagePins,'
      '    pup3.ID as IDDatasheet,'
      '    pup3.Value as Datasheet,'
      '    pup4.ID as IDDiagram,'
      '    pup4.Value as Diagram,'
      '    pup5.ID as IDDrawing,'
      '    pup5.Value as Drawing,'
      '    pup6.ID as IDImage,'
      '    pup6.Value as Image'
      'from Products p'
      'JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.Id'
      'JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategoryId'
      
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
      'where upper(p.Value) = upper(:Value) '
      'and p.ParentProductId is null'
      'GROUP BY p.Id')
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
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
