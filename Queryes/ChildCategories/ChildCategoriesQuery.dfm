inherited QueryChildCategories: TQueryChildCategories
  Width = 199
  ExplicitWidth = 199
  inherited Label1: TLabel
    Width = 100
    Caption = 'ChildCategories'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      
        'SELECT pc.Id, pc.Value, pc.ParentId, pc.ExternalId, pc.ORD, pc2.' +
        'ExternalId ParentExternalId'
      'FROM ProductCategories pc'
      'left join ProductCategories pc2'
      'on pc.ParentId = pc2.Id'
      'WHERE pc.parentId = :ParentId')
    ParamData = <
      item
        Name = 'PARENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PRODUCTCATEGORIES'
      '(VALUE, PARENTID, EXTERNALID)'
      'VALUES (:NEW_VALUE, :NEW_PARENTID, :NEW_EXTERNALID);'
      'SELECT LAST_INSERT_AUTOGEN() AS ID')
    ModifySQL.Strings = (
      'UPDATE PRODUCTCATEGORIES'
      
        'SET VALUE = :NEW_VALUE, PARENTID = :NEW_PARENTID, EXTERNALID = :' +
        'NEW_EXTERNALID'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM PRODUCTCATEGORIES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      
        'SELECT pc.Id, pc.Value, pc.ParentId, pc.ExternalId, pc2.External' +
        'Id ParentExternalId'
      'FROM ProductCategories pc'
      'left join ProductCategories pc2'
      'on pc.ParentId = pc2.Id'
      'WHERE pc.ID = :ID')
    Left = 144
    Top = 24
  end
end
