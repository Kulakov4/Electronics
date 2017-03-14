inherited QuerySearchParametersForCategory: TQuerySearchParametersForCategory
  Width = 135
  ExplicitWidth = 135
  inherited Label1: TLabel
    Width = 201
    Caption = 'SearchParametersForCategory'
    ExplicitWidth = 201
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select cp.*'
      'from CategoryParams cp'
      'where cp.ProductCategoryID = :IDCategory'
      'order by cp.[Order] desc')
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
    end
    object FDQueryProductCategoryId: TIntegerField
      FieldName = 'ProductCategoryId'
      Origin = 'ProductCategoryId'
    end
    object FDQueryParameterId: TIntegerField
      FieldName = 'ParameterId'
      Origin = 'ParameterId'
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
      'INSERT INTO CategoryParams'
      '("ORDER", ISENABLED, ISATTRIBUTE)'
      'VALUES (:NEW_ORDER, :NEW_ISENABLED, :NEW_ISATTRIBUTE);'
      'SELECT ID, PRODUCTCATEGORYID, PARAMETERID, '
      '  "ORDER" AS "ORDER", ISENABLED, ISATTRIBUTE'
      'FROM CategoryParams'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE CategoryParams'
      
        'SET "ORDER" = :NEW_ORDER, ISENABLED = :NEW_ISENABLED, ISATTRIBUT' +
        'E = :NEW_ISATTRIBUTE'
      'WHERE ID = :OLD_ID;'
      'SELECT ID, PRODUCTCATEGORYID, PARAMETERID, "ORDER" AS "ORDER", '
      '  ISENABLED, ISATTRIBUTE'
      'FROM CategoryParams'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM CategoryParams'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, PRODUCTCATEGORYID, PARAMETERID, '
      '  "ORDER" AS "ORDER", ISENABLED, ISATTRIBUTE'
      'FROM CategoryParams'
      'WHERE ID = :ID')
    Left = 72
    Top = 24
  end
end
