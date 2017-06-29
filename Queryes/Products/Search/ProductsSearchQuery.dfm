inherited QueryProductsSearch: TQueryProductsSearch
  Width = 190
  Height = 83
  ExplicitWidth = 190
  ExplicitHeight = 83
  inherited Label1: TLabel
    Width = 103
    Caption = 'ProductsSearch'
    ExplicitWidth = 103
  end
  object fdqBase: TFDQuery
    SQL.Strings = (
      'select'
      '       sp.Id,'
      '       p.DescriptionId,'
      '       p.Value,'
      '       p.IDProducer,'
      '       sp.IDComponentGroup,'
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
      '       sp.IDCurrency,'
      '       sp.RATE1,'
      '       sp.RATE2,'
      '       p.PackagePins,'
      '       p.Datasheet,'
      '       p.Diagram,'
      '       p.Drawing,'
      '       p.Image,'
      '       d.Description'
      'from StorehouseProducts sp'
      'join Products2 p on sp.ProductId = p.id  --join'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      '--where'
      'order by sp.IDComponentGroup')
    Left = 145
    Top = 25
  end
end
