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
      '       p.ParentProductId,'
      '       Min(pc.ExternalId) CurCategoryExternalID,'
      '       pv.ID as IDProducer,'
      '       pv.Value as Producer,'
      '       pv2.ID as IDPackagePins,'
      '       pv2.Value as PackagePins,'
      '       pv3.ID as IDDatasheet,'
      '       pv3.Value as Datasheet,'
      '       pv4.ID as IDDiagram,'
      '       pv4.Value as Diagram,'
      '       pv5.ID as IDDrawing,'
      '       pv5.Value as Drawing,'
      '       pv6.ID as IDImage,'
      '       pv6.Value as Image,'
      '       d.Description'
      '   FROM Products p'
      '   JOIN ProductProductCategories ppc ON p.Id = ppc.ProductId'
      '   JOIN ProductCategories pc ON pc.Id = ppc.ProductCategoryId  '
      
        '   left join ParameterValues pv on pv.ProductID = p.Id and pv.Pa' +
        'rameterId = :ProducerParameterID'
      
        '   left join ParameterValues pv2 on pv2.ProductID = p.Id and pv2' +
        '.ParameterId = :PackagePinsParameterID'
      
        '   left join ParameterValues pv3 on pv3.ProductID = p.Id and pv3' +
        '.ParameterId = :DatasheetParameterID'
      
        '   left join ParameterValues pv4 on pv4.ProductID = p.Id and pv4' +
        '.ParameterId = :DiagramParameterID'
      
        '   left join ParameterValues pv5 on pv5.ProductID = p.Id and pv5' +
        '.ParameterId = :DrawingParameterID'
      
        '   left join ParameterValues pv6 on pv6.ProductID = p.Id and pv6' +
        '.ParameterId = :ImageParameterID'
      '   LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      
        '   WHERE instr('#39','#39' || :IDList || '#39','#39'   ,    '#39','#39' || p.Id || '#39','#39') ' +
        '> 0 '
      '      AND ParentProductId IS NULL'
      'GROUP BY p.Id'
      ') t'
      'ORDER BY t.value')
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
