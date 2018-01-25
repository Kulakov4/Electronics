inherited QueryParamSubParams: TQueryParamSubParams
  Width = 222
  ExplicitWidth = 222
  inherited Label1: TLabel
    Width = 113
    Caption = 'ParamSubParams'
    ExplicitWidth = 113
  end
  inherited FDQuery: TFDQuery
    IndexFieldNames = 'IdParameter'
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select psp.*, sp.Name, sp.Translation'
      'from ParamSubParams psp'
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
      'order by psp.IdParameter')
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
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
      'WHERE psp.ID = :ID')
    Left = 152
    Top = 24
  end
end
