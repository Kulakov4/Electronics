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
      '       p.DescriptionId,'
      '       p.Value,'
      '       p.IDProducer,'
      '       sp.ComponentGroup,'
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
      'WHERE p.ID = 0')
  end
  object FDBaseQuery: TFDQuery
    SQL.Strings = (
      'select'
      '       sp.Id,'
      '       p.DescriptionId,'
      '       p.Value,'
      '       p.IDProducer,'
      '       sp.ComponentGroup,'
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
      '       p.PackagePins,'
      '       p.Datasheet,'
      '       p.Diagram,'
      '       p.Drawing,'
      '       p.Image,'
      '       d.Description'
      'from StorehouseProducts sp'
      'join Products2 p on sp.ProductId = p.id  --join'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      '--where')
    Left = 16
    Top = 88
  end
end
