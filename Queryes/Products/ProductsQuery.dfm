inherited QueryProducts: TQueryProducts
  Width = 139
  Height = 77
  ExplicitWidth = 139
  ExplicitHeight = 77
  inherited Label1: TLabel
    Width = 58
    Caption = 'Products'
    ExplicitWidth = 58
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      '('
      'select'
      '    cg.id ID,'
      '    cg.ComponentGroup Value,'
      '    sp.StorehouseId,    '
      '    1 IsGroup,'
      '    NULL IDComponentGroup, '
      '    NULL IDProducer, '
      '    NULL Amount,'
      '    NULL Price,'
      '    NULL ProductId,'
      '    NULL ReleaseDate,'
      '    NULL BatchNumber,'
      '    NULL Packaging,'
      '    NULL OriginCountry,'
      '    NULL CustomsDeclarationNumber,'
      '    NULL Storage,'
      '    NULL Barcode,'
      '    NULL Seller,'
      '    NULL StoragePlace,'
      '    NULL OriginCountryCode,'
      '    NULL IDCurrency,'
      '    NULL PackagePins,'
      '    NULL Datasheet,'
      '    NULL Diagram,'
      '    NULL Drawing,'
      '    NULL Image,'
      '    NULL DescriptionComponentName,'
      '    NULL Description    '
      'from StorehouseProducts sp'
      'join ComponentGroups cg on sp.IDComponentGroup = cg.id'
      'union'
      'select'
      '       -sp.Id,'
      '       p.Value,'
      '       sp.StorehouseId,'
      '       0 IsGroup,       '
      '       sp.IDComponentGroup,'
      '       p.IDProducer,'
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
      '       sp.IDCurrency,'
      '       p.PackagePins,'
      '       p.Datasheet,'
      '       p.Diagram,'
      '       p.Drawing,'
      '       p.Image,'
      '       d.ComponentName DescriptionComponentName,'
      '       d.Description'
      'from StorehouseProducts sp'
      'join Products2 p on sp.ProductId = p.id'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      ')'
      'where StorehouseId = :vStorehouseId')
    ParamData = <
      item
        Name = 'VSTOREHOUSEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
