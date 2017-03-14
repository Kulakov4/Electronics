inherited QuerySearchFamilyByValue: TQuerySearchFamilyByValue
  inherited Label1: TLabel
    Width = 136
    Caption = 'SearchFamilyByValue'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*,'
      '    GROUP_CONCAT(pc.ExternalId) subGroup,'
      '    GROUP_CONCAT(pc.id) CategoryIDList,'
      '    pv.ID as IDProducer,'
      '    pv.Value as Producer,'
      '    pv2.ID as IDPackagePins,'
      '    pv2.Value as PackagePins,'
      '    pv3.ID as IDDatasheet,'
      '    pv3.Value as Datasheet,'
      '    pv4.ID as IDDiagram,'
      '    pv4.Value as Diagram,'
      '    pv5.ID as IDDrawing,'
      '    pv5.Value as Drawing,'
      '    pv6.ID as IDImage,'
      '    pv6.Value as Image'
      'from Products p'
      'JOIN ProductProductCategories ppc2 ON ppc2.ProductId = p.Id'
      'JOIN ProductCategories pc ON pc.Id = ppc2.ProductCategoryId'
      
        'left join ParameterValues pv on pv.ProductID = p.Id and pv.Param' +
        'eterId = :ProducerParameterID'
      
        'left join ParameterValues pv2 on pv2.ProductID = p.Id and pv2.Pa' +
        'rameterId = :PackagePinsParameterID'
      
        'left join ParameterValues pv3 on pv3.ProductID = p.Id and pv3.Pa' +
        'rameterId = :DatasheetParameterID'
      
        'left join ParameterValues pv4 on pv4.ProductID = p.Id and pv4.Pa' +
        'rameterId = :DiagramParameterID'
      
        'left join ParameterValues pv5 on pv5.ProductID = p.Id and pv5.Pa' +
        'rameterId = :DrawingParameterID'
      
        'left join ParameterValues pv6 on pv6.ProductID = p.Id and pv6.Pa' +
        'rameterId = :ImageParameterID'
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
