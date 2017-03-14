inherited QueryParametersDetail: TQueryParametersDetail
  inherited Label1: TLabel
    Width = 113
    Caption = 'ParametersDetail'
    ExplicitWidth = 113
  end
  inherited FDQuery: TFDQuery
    OnUpdateRecord = FDQueryUpdateRecord
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvUpdateChngFields, uvLockWait, uvRefreshMode, uvCountUpdatedRecords, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.UpdateChangedFields = False
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.CountUpdatedRecords = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.CheckUpdatable = False
    UpdateOptions.AutoIncFields = 'Id'
    SQL.Strings = (
      'select p.id,'
      '       p.Value,'
      '       p.TableName,'
      '       p.ValueT,'
      '       p.IDParameterType,'
      '       p.[Order],'
      '       IFNULL(cp.IsEnabled, 0) > 0 IsAdded,'
      '       IFNULL(cp.IsAttribute, 0) > 0 IsAttribute'
      'from Parameters p'
      '       LEFT JOIN'
      '       ('
      '           SELECT *'
      '             FROM CategoryParams'
      '            WHERE ProductCategoryId = :ProductCategoryId'
      '       )'
      '       cp ON cp.ParameterId = p.id'
      ' WHERE p.ParentParameter IS NULL'
      '       and p.IDParameterType = :IDParameterType'
      ' ORDER BY p.[Order]       ')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IDPARAMETERTYPE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
