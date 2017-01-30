inherited QueryChildCategories: TQueryChildCategories
  inherited Label1: TLabel
    Width = 100
    Caption = 'ChildCategories'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'SELECT pc.Id, pc.Value, pc.ParentId, pc.ShortValue,'
      'pc.ExternalId, pc.`Order`,'
      'pc2.ExternalId ParentExternalId'
      'FROM ProductCategories pc'
      'left join ProductCategories pc2'
      'on pc.ParentId = pc2.Id'
      'WHERE pc.parentId = :ParentId'
      'AND pc.id != 1')
    ParamData = <
      item
        Name = 'PARENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
