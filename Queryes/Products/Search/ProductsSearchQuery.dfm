inherited QueryProductsSearch: TQueryProductsSearch
  inherited Label1: TLabel
    Width = 103
    Caption = 'ProductsSearch'
    ExplicitWidth = 103
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select'
      '       sp.Id,'
      '       pp.DescriptionId,'
      '       pp.subGroup,'
      '       pp.Value,'
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
      '('
      '    select '
      '        p.ID,'
      '            p.Value,'
      '            p.DescriptionId,'
      '            p.ParentProductId,'
      '            GROUP_CONCAT(pc.ExternalId) subGroup'
      '    from Products p'
      '    JOIN ProductProductCategories ppc ON ppc.ProductId = p.Id'
      '    JOIN ProductCategories pc ON pc.Id = ppc.ProductCategoryId'
      '    where p.ParentProductId is null'
      '    group by p.id'
      ') pp '
      'JOIN StorehouseProducts sp ON sp.ProductId = pp.Id'
      
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
      'WHERE instr('#39','#39' || :IDList || '#39','#39', '#39','#39' || pp.Id || '#39','#39') > 0')
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
