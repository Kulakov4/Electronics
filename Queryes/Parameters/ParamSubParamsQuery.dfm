inherited QueryParamSubParams: TQueryParamSubParams
  Width = 324
  ExplicitWidth = 324
  inherited Label1: TLabel
    Width = 113
    Caption = 'ParamSubParams'
    ExplicitWidth = 113
  end
  inherited FDQuery: TFDQuery
    IndexFieldNames = 'IdParameter'
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateOptions.UpdateTableName = 'ParamSubParams'
    UpdateOptions.KeyFields = 'Id'
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      
        'select psp.*, sp.Name, sp.Translation, IFNULL(cp.id, 0) > 0 Chec' +
        'ked'
      'from ParamSubParams psp'
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
      
        'LEFT JOIN CategoryParams2 cp on cp.ProductCategoryId = :ProductC' +
        'ategoryId and cp.ParamSubParamID = psp.id '
      'where sp.IsDefault = 0 and 0=0'
      'order by psp.IdParameter')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
  object FDUpdateSQL: TFDUpdateSQL
    Connection = DMRepository.dbConnection
    InsertSQL.Strings = (
      'INSERT INTO PARAMSUBPARAMS'
      '(IDPARAMETER, IDSUBPARAMETER)'
      'VALUES (:NEW_IDPARAMETER, :NEW_IDSUBPARAMETER);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE PARAMSUBPARAMS'
      
        'SET IDPARAMETER = :NEW_IDPARAMETER, IDSUBPARAMETER = :NEW_IDSUBP' +
        'ARAMETER'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM PARAMSUBPARAMS'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'select psp.*, sp.Name, sp.Translation'
      'from ParamSubParams psp'
      'LEFT join SubParameters sp on psp.IdSubParameter = sp.Id'
      'WHERE psp.ID = :NEW_ID')
    Left = 152
    Top = 24
  end
end
