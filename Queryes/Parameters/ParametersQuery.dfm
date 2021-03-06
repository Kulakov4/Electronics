inherited QueryParameters: TQueryParameters
  Width = 340
  Height = 86
  ExplicitWidth = 340
  ExplicitHeight = 86
  inherited Label1: TLabel
    Width = 76
    Caption = 'Parameters'
    ExplicitWidth = 76
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'IDParameterType'
      end>
    IndexName = 'idxOrder'
    UpdateOptions.AssignedValues = [uvRefreshMode, uvUpdateNonBaseFields]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select p.*, IFNULL(cp.id, 0) > 0 Checked, t.ID ParamSubParamID'
      'from Parameters p'
      'LEFT JOIN '
      '('
      '    select psp.ID, psp.IdParameter, psp.IdSubParameter'
      '    from ParamSubParams psp'
      
        '    join SubParameters sp on psp.IdSubParameter = sp.Id and sp.I' +
        'sDefault = 1'
      ') t on t.IdParameter = p.Id'
      ''
      
        'LEFT JOIN CategoryParams2 cp on (cp.ProductCategoryID=:ProductCa' +
        'tegoryID) and cp.ParamSubParamID = t.id '
      'where'
      'IDParameterType is not null'
      '/* ShowDuplicate'
      'and tablename in'
      '('
      '    select TableName'
      '    from Parameters'
      '    where IDParameterType is not null'
      '    group by TableName'
      '    having count(*) > 1'
      ')'
      'ShowDuplicate */'
      'and 0=0 '
      'order by p.IDParameterType, p.[Order]')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdqDeleteFromCategoryParams: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      
        'delete from CategoryParams2 where ParamSubParamId = :ParamSubPar' +
        'amId')
    Left = 240
    Top = 24
    ParamData = <
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
