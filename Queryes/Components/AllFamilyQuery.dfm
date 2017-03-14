inherited QueryAllFamily: TQueryAllFamily
  inherited Label1: TLabel
    Width = 55
    Caption = 'AllFamily'
    ExplicitWidth = 55
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.Id,'
      '    p.DescriptionId,'
      '    p.Value,'
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
      
        'where (p.ParentProductId is null) and ((p.ID = :ID) or (:ID = 0)' +
        ')')
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
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
end
