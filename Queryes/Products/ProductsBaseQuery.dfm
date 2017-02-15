inherited QueryProductsBase: TQueryProductsBase
  Width = 258
  Height = 149
  ExplicitWidth = 258
  ExplicitHeight = 149
  inherited Label1: TLabel
    Width = 128
    Caption = 'ProductsBaseQuery'
    ExplicitWidth = 128
  end
  inline qStoreHouseProducts: TfrmApplyQuery [1]
    Left = 123
    Top = 81
    Width = 125
    Height = 59
    TabOrder = 0
    ExplicitLeft = 123
    ExplicitTop = 81
    ExplicitWidth = 125
    inherited FDQuery: TFDQuery
      SQL.Strings = (
        'select *'
        'from StoreHouseproducts'
        'where ID=:ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = Null
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
      InsertSQL.Strings = (
        'INSERT INTO STOREHOUSEPRODUCTS'
        '(STOREHOUSEID, PRODUCTID, RELEASEDATE, AMOUNT, '
        '  PRICE, BATCHNUMBER, PACKAGING, ORIGINCOUNTRY, '
        '  CUSTOMSDECLARATIONNUMBER, STORAGE, BARCODE, '
        '  SELLER, STORAGEPLACE, ORIGINCOUNTRYCODE)'
        
          'VALUES (:NEW_STOREHOUSEID, :NEW_PRODUCTID, :NEW_RELEASEDATE, :NE' +
          'W_AMOUNT, '
        
          '  :NEW_PRICE, :NEW_BATCHNUMBER, :NEW_PACKAGING, :NEW_ORIGINCOUNT' +
          'RY, '
        '  :NEW_CUSTOMSDECLARATIONNUMBER, :NEW_STORAGE, :NEW_BARCODE, '
        '  :NEW_SELLER, :NEW_STORAGEPLACE, :NEW_ORIGINCOUNTRYCODE);'
        ''
        'SELECT ID, STOREHOUSEID, PRODUCTID, RELEASEDATE, '
        
          '  AMOUNT, PRICE, BATCHNUMBER, PACKAGING, ORIGINCOUNTRY, CUSTOMSD' +
          'ECLARATIONNUMBER, '
        '  STORAGE, BARCODE, SELLER, STORAGEPLACE, ORIGINCOUNTRYCODE'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = LAST_INSERT_AUTOGEN()')
      ModifySQL.Strings = (
        'UPDATE STOREHOUSEPRODUCTS'
        
          'SET STOREHOUSEID = :NEW_STOREHOUSEID, PRODUCTID = :NEW_PRODUCTID' +
          ', '
        
          '  RELEASEDATE = :NEW_RELEASEDATE, AMOUNT = :NEW_AMOUNT, PRICE = ' +
          ':NEW_PRICE, '
        '  BATCHNUMBER = :NEW_BATCHNUMBER, PACKAGING = :NEW_PACKAGING, '
        
          '  ORIGINCOUNTRY = :NEW_ORIGINCOUNTRY, CUSTOMSDECLARATIONNUMBER =' +
          ' :NEW_CUSTOMSDECLARATIONNUMBER, '
        
          '  STORAGE = :NEW_STORAGE, BARCODE = :NEW_BARCODE, SELLER = :NEW_' +
          'SELLER, '
        
          '  STORAGEPLACE = :NEW_STORAGEPLACE, ORIGINCOUNTRYCODE = :NEW_ORI' +
          'GINCOUNTRYCODE'
        'WHERE ID = :OLD_ID;'
        
          'SELECT ID, STOREHOUSEID, PRODUCTID, RELEASEDATE, AMOUNT, PRICE, ' +
          'BATCHNUMBER, '
        '  PACKAGING, ORIGINCOUNTRY, CUSTOMSDECLARATIONNUMBER, STORAGE, '
        '  BARCODE, SELLER, STORAGEPLACE, ORIGINCOUNTRYCODE'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = :NEW_ID')
      DeleteSQL.Strings = (
        'DELETE FROM STOREHOUSEPRODUCTS'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, STOREHOUSEID, PRODUCTID, RELEASEDATE, '
        
          '  AMOUNT, PRICE, BATCHNUMBER, PACKAGING, ORIGINCOUNTRY, CUSTOMSD' +
          'ECLARATIONNUMBER, '
        '  STORAGE, BARCODE, SELLER, STORAGEPLACE, ORIGINCOUNTRYCODE'
        'FROM STOREHOUSEPRODUCTS'
        'WHERE ID = :ID')
    end
  end
  inline qProducts: TfrmApplyQuery [2]
    Left = 129
    Top = 16
    Width = 129
    Height = 59
    TabOrder = 1
    ExplicitLeft = 129
    ExplicitTop = 16
    inherited FDQuery: TFDQuery
      Active = True
      SQL.Strings = (
        'select *'
        'from Products2'
        'where ID=:ID')
      ParamData = <
        item
          Name = 'ID'
          DataType = ftInteger
          ParamType = ptInput
          Value = Null
        end>
    end
    inherited FDUpdateSQL: TFDUpdateSQL
      InsertSQL.Strings = (
        'INSERT INTO PRODUCTS2'
        '(IDPRODUCER, VALUE, DATASHEET, DRAWING, DIAGRAM, '
        '  IMAGE, PACKAGEPINS, DESCRIPTIONID)'
        
          'VALUES (:NEW_IDPRODUCER, :NEW_VALUE, :NEW_DATASHEET, :NEW_DRAWIN' +
          'G, :NEW_DIAGRAM, '
        '  :NEW_IMAGE, :NEW_PACKAGEPINS, :NEW_DESCRIPTIONID);'
        ''
        'SELECT ID, IDPRODUCER, VALUE, DATASHEET, DRAWING, DIAGRAM, '
        '  IMAGE, PACKAGEPINS, DESCRIPTIONID'
        'FROM PRODUCTS2'
        'WHERE ID = LAST_INSERT_ROWID();')
      ModifySQL.Strings = (
        'UPDATE PRODUCTS2'
        
          'SET IDPRODUCER = :NEW_IDPRODUCER, VALUE = :NEW_VALUE, DATASHEET ' +
          '= :NEW_DATASHEET, '
        
          '  DRAWING = :NEW_DRAWING, DIAGRAM = :NEW_DIAGRAM, IMAGE = :NEW_I' +
          'MAGE, '
        
          '  PACKAGEPINS = :NEW_PACKAGEPINS, DESCRIPTIONID = :NEW_DESCRIPTI' +
          'ONID'
        'WHERE ID = :OLD_ID;')
      DeleteSQL.Strings = (
        'DELETE FROM PRODUCTS2'
        'WHERE ID = :OLD_ID')
      FetchRowSQL.Strings = (
        'SELECT ID, IDPRODUCER, VALUE, DATASHEET, DRAWING, '
        '  DIAGRAM, IMAGE, PACKAGEPINS, DESCRIPTIONID'
        'FROM PRODUCTS2'
        'WHERE ID = :ID')
    end
  end
  inherited FDQuery: TFDQuery
    Left = 17
  end
  inherited DataSource: TDataSource
    Left = 80
    Top = 25
  end
end
