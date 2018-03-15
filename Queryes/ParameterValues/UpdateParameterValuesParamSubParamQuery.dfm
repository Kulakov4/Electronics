inherited qUpdateParameterValuesParamSubParam: TqUpdateParameterValuesParamSubParam
  Width = 279
  ExplicitWidth = 279
  inherited Label1: TLabel
    Width = 264
    Caption = 'UpdateParameterValuesParamSubParam'
    ExplicitWidth = 264
  end
  object fdqDelete: TFDQuery
    SQL.Strings = (
      'delete FROM ParameterValues2'
      'where ParamSubParamId = :OldParamSubParamId'
      'and ProductID IN'
      '    ('
      '      select ID'
      '      from Products p'
      
        '      join ProductProductCategories PPC ON p.Id = PPC.ProductId ' +
        'and PPC.ProductCategoryId = :ProductCategoryId'
      '    )')
    Left = 64
    Top = 24
    ParamData = <
      item
        Name = 'OLDPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdqUpdate: TFDQuery
    SQL.Strings = (
      'update ParameterValues2'
      'set ParamSubParamId = :NewParamSubParamId'
      'where ParamSubParamId = :OldParamSubParamId'
      'and ProductID IN'
      '    ('
      '      select ID'
      '      from Products p'
      
        '      join ProductProductCategories PPC ON p.Id = PPC.ProductId ' +
        'and PPC.ProductCategoryId = :ProductCategoryId'
      '    )')
    Left = 120
    Top = 24
    ParamData = <
      item
        Name = 'NEWPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OLDPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
