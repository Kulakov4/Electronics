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
      'select pg.id,'
      '       pg.Value,'
      '       pg.TableName,'
      '       pg.ValueT,'
      '       pg.IDParameterType,'
      '       pg.[Order],'
      '       IFNULL(upfc.IsEnabled, 0) > 0 IsAdded,'
      '       IFNULL(upfc.IsAttribute, 0) > 0 IsAttribute'
      'from UnionParameters pg'
      '       LEFT JOIN'
      '       ('
      '           SELECT *'
      '             FROM UnionParameterForCategories'
      '            WHERE ProductCategoryId = :ProductCategoryId'
      '       )'
      '       upfc ON upfc.UnionParameterId = pg.id'
      ' WHERE pg.ParentParameter IS NULL'
      '       and pg.IDParameterType = :IDParameterType'
      ' ORDER BY pg.[Order]       ')
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
