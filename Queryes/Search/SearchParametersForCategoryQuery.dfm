inherited QuerySearchParametersForCategory: TQuerySearchParametersForCategory
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select upfc.*'
      'from unionparameterForCategories upfc'
      'where upfc.ProductCategoryID = :IDCategory'
      'order by upfc.[Order] desc')
    ParamData = <
      item
        Name = 'IDCATEGORY'
        DataType = ftInteger
        ParamType = ptInput
        Value = 54
      end>
    object FDQueryId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryProductCategoryId: TIntegerField
      FieldName = 'ProductCategoryId'
      Origin = 'ProductCategoryId'
    end
    object FDQueryUnionParameterId: TIntegerField
      FieldName = 'UnionParameterId'
      Origin = 'UnionParameterId'
    end
    object FDQueryOrder: TIntegerField
      FieldName = 'Order'
      Origin = '"Order"'
    end
    object FDQueryIsEnabled: TBooleanField
      FieldName = 'IsEnabled'
      Origin = 'IsEnabled'
    end
    object FDQueryIsAttribute: TBooleanField
      FieldName = 'IsAttribute'
      Origin = 'IsAttribute'
    end
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO UNIONPARAMETERFORCATEGORIES'
      '("ORDER", ISENABLED, ISATTRIBUTE)'
      'VALUES (:NEW_ORDER, :NEW_ISENABLED, :NEW_ISATTRIBUTE);'
      
        'SELECT LAST_INSERT_AUTOGEN() AS ID, PRODUCTCATEGORYID, UNIONPARA' +
        'METERID, '
      '  "ORDER" AS "ORDER", ISENABLED, ISATTRIBUTE'
      'FROM UNIONPARAMETERFORCATEGORIES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE UNIONPARAMETERFORCATEGORIES'
      
        'SET "ORDER" = :NEW_ORDER, ISENABLED = :NEW_ISENABLED, ISATTRIBUT' +
        'E = :NEW_ISATTRIBUTE'
      'WHERE ID = :OLD_ID;'
      
        'SELECT ID, PRODUCTCATEGORYID, UNIONPARAMETERID, "ORDER" AS "ORDE' +
        'R", '
      '  ISENABLED, ISATTRIBUTE'
      'FROM UNIONPARAMETERFORCATEGORIES'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM UNIONPARAMETERFORCATEGORIES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      
        'SELECT LAST_INSERT_AUTOGEN() AS ID, PRODUCTCATEGORYID, UNIONPARA' +
        'METERID, '
      '  "ORDER" AS "ORDER", ISENABLED, ISATTRIBUTE'
      'FROM UNIONPARAMETERFORCATEGORIES'
      'WHERE ID = :ID')
    Left = 88
    Top = 48
  end
end
