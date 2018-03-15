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
      
        'left join ParameterValues2 pv on pv.ProductID = p.Id and pv.Para' +
        'mSubParamId = :ProducerParamSubParamID'
      
        'left join ParameterValues2 pv2 on pv2.ProductID = p.Id and pv2.P' +
        'aramSubParamId = :PackagePinsParamSubParamID'
      
        'left join ParameterValues2 pv3 on pv3.ProductID = p.Id and pv3.P' +
        'aramSubParamId = :DatasheetParamSubParamID'
      
        'left join ParameterValues2 pv4 on pv4.ProductID = p.Id and pv4.P' +
        'aramSubParamId = :DiagramParamSubParamID'
      
        'left join ParameterValues2 pv5 on pv5.ProductID = p.Id and pv5.P' +
        'aramSubParamId = :DrawingParamSubParamID'
      
        'left join ParameterValues2 pv6 on pv6.ProductID = p.Id and pv6.P' +
        'aramSubParamId = :ImageParamSubParamID'
      
        'where (p.ParentProductId is null) and ((p.ID = :ID) or (:ID = 0)' +
        ')')
    ParamData = <
      item
        Name = 'PRODUCERPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PACKAGEPINSPARAMSUBPARAMID'
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
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
end
