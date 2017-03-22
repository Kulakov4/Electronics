inherited QueryChildCategories: TQueryChildCategories
  inherited Label1: TLabel
    Width = 100
    Caption = 'ChildCategories'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'SELECT pc.Id, pc.Value, pc.ParentId, pc.ExternalId, pc2.External' +
        'Id ParentExternalId'
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
end
