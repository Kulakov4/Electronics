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
  inherited qStoreHouseProducts: TfrmApplyQuery
    inherited FDUpdateSQL: TFDUpdateSQL
      InsertSQL.Strings = (
        'INSERT INTO STOREHOUSEPRODUCTS'
        '(STOREHOUSEID, PRODUCTID, COMPONENTGROUP, RELEASEDATE, '
        '  AMOUNT, PRICE, BATCHNUMBER, PACKAGING, '
        '  ORIGINCOUNTRY, CUSTOMSDECLARATIONNUMBER, STORAGE, '
        '  BARCODE, SELLER, STORAGEPLACE, ORIGINCOUNTRYCODE)'
        
          'VALUES (:NEW_STOREHOUSEID, :NEW_PRODUCTID, :NEW_COMPONENTGROUP, ' +
          ':NEW_RELEASEDATE, '
        '  :NEW_AMOUNT, :NEW_PRICE, :NEW_BATCHNUMBER, :NEW_PACKAGING, '
        
          '  :NEW_ORIGINCOUNTRY, :NEW_CUSTOMSDECLARATIONNUMBER, :NEW_STORAG' +
          'E, '
        
          '  :NEW_BARCODE, :NEW_SELLER, :NEW_STORAGEPLACE, :NEW_ORIGINCOUNT' +
          'RYCODE);'
        ''
        'SELECT ID, STOREHOUSEID, PRODUCTID, COMPONENTGROUP, '
        
          '  RELEASEDATE, AMOUNT, PRICE, BATCHNUMBER, PACKAGING, ORIGINCOUN' +
          'TRY, '
        
          '  CUSTOMSDECLARATIONNUMBER, STORAGE, BARCODE, SELLER, STORAGEPLA' +
          'CE, '
        '  ORIGINCOUNTRYCODE'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = LAST_INSERT_ROWID();')
      ModifySQL.Strings = (
        'UPDATE STOREHOUSEPRODUCTS'
        
          'SET STOREHOUSEID = :NEW_STOREHOUSEID, PRODUCTID = :NEW_PRODUCTID' +
          ', '
        
          '  COMPONENTGROUP = :NEW_COMPONENTGROUP, RELEASEDATE = :NEW_RELEA' +
          'SEDATE, '
        
          '  AMOUNT = :NEW_AMOUNT, PRICE = :NEW_PRICE, BATCHNUMBER = :NEW_B' +
          'ATCHNUMBER, '
        
          '  PACKAGING = :NEW_PACKAGING, ORIGINCOUNTRY = :NEW_ORIGINCOUNTRY' +
          ', '
        '  CUSTOMSDECLARATIONNUMBER = :NEW_CUSTOMSDECLARATIONNUMBER, '
        
          '  STORAGE = :NEW_STORAGE, BARCODE = :NEW_BARCODE, SELLER = :NEW_' +
          'SELLER, '
        
          '  STORAGEPLACE = :NEW_STORAGEPLACE, ORIGINCOUNTRYCODE = :NEW_ORI' +
          'GINCOUNTRYCODE'
        'WHERE ID = :OLD_ID;'
        'SELECT ID'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = :NEW_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, STOREHOUSEID, PRODUCTID, COMPONENTGROUP, '
        
          '  RELEASEDATE, AMOUNT, PRICE, BATCHNUMBER, PACKAGING, ORIGINCOUN' +
          'TRY, '
        
          '  CUSTOMSDECLARATIONNUMBER, STORAGE, BARCODE, SELLER, STORAGEPLA' +
          'CE, '
        '  ORIGINCOUNTRYCODE'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = :ID')
    end
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
      '       d.Description'
      ''
      'from StorehouseProducts sp'
      'join Products2 p on sp.ProductId = p.id'
      'LEFT JOIN Descriptions2 d on p.DescriptionId = d.ID'
      'where sp.StorehouseId = :vStorehouseId')
    ParamData = <
      item
        Name = 'VSTOREHOUSEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
