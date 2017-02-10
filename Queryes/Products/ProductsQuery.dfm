inherited QueryProducts: TQueryProducts
  Width = 264
  Height = 153
  ExplicitWidth = 264
  ExplicitHeight = 153
  inherited Label1: TLabel
    Width = 58
    Caption = 'Products'
    ExplicitWidth = 58
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select'
      '       sp.Id,'
      '       pp.DescriptionId,'
      '       dp.Value,'
      '       pp.subGroup,'
      '       pp.ParentProductId, '
      '       sp.StorehouseId,'
      '       sp.Amount,'
      '       sp.Price,'
      '       sp.ProductId,'
      '       sp.ReleaseDate,'
      '       sp.BatchNumber,'
      '       sp.Packaging,'
      '       sp.OriginCountry,'
      '       sp.CustomsDeclarationNumber,'
      '       sp.Storage,'
      '       sp.Barcode,'
      '       sp.Seller,'
      '       sp.StoragePlace,'
      '       sp.OriginCountryCode,'
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
      'from'
      'StorehouseProducts sp'
      'join Products dp on sp.ProductId = dp.Id'
      'join'
      '('
      '    select '
      '        p.ID,'
      '            p.Value,'
      '            p.DescriptionId,'
      '            p.ParentProductId,'
      '            GROUP_CONCAT(pc.ExternalId) subGroup'
      '    from Products p'
      
        '    LEFT JOIN ProductProductCategories ppc ON ppc.ProductId = p.' +
        'Id'
      
        '    LEFT JOIN ProductCategories pc ON pc.Id = ppc.ProductCategor' +
        'yId'
      '    where p.ParentProductId is null'
      '    group by p.id'
      ') pp on dp.ParentProductId = pp.Id'
      
        'LEFT JOIN ProductUnionParameters pup ON pup.ProductID = pp.Id AN' +
        'D pup.UnionParameterId = :ProducerParameterID'
      
        'LEFT JOIN ProductUnionParameters pup2 ON pup2.ProductID = pp.Id ' +
        'AND pup2.UnionParameterId = :PackagePinsParameterID'
      
        'LEFT JOIN ProductUnionParameters pup3 ON pup3.ProductID = pp.Id ' +
        'AND pup3.UnionParameterId = :DatasheetParameterID'
      
        'LEFT JOIN ProductUnionParameters pup4 ON pup4.ProductID = pp.Id ' +
        'AND pup4.UnionParameterId = :DiagramParameterID'
      
        'LEFT JOIN ProductUnionParameters pup5 ON pup5.ProductID = pp.Id ' +
        'AND pup5.UnionParameterId = :DrawingParameterID'
      
        'LEFT JOIN ProductUnionParameters pup6 ON pup6.ProductID = pp.Id ' +
        'AND pup6.UnionParameterId = :ImageParameterID'
      'LEFT JOIN Descriptions2 d on pp.DescriptionId = d.ID'
      'where sp.StorehouseId = :vStorehouseId')
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
        Name = 'VSTOREHOUSEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
