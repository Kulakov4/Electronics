inherited QueryProductsBase: TQueryProductsBase
  Width = 258
  Height = 149
  ExplicitWidth = 258
  ExplicitHeight = 149
  inherited Label1: TLabel
    Caption = 'ProductsBaseQuery'
  end
  inline qStoreHouseProducts: TfrmApplyQuery [1]
    Left = 123
    Top = 81
    Width = 125
    Height = 59
    TabOrder = 1
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
          ParamType = ptInput
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
  inherited qProducts: TfrmApplyQuery [2]
  end
  inherited FDQuery: TFDQuery [3]
    Left = 73
  end
end
