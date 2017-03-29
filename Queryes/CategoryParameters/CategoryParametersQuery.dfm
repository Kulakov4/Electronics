inherited QueryCategoryParameters: TQueryCategoryParameters
  Width = 320
  ExplicitWidth = 320
  inherited Label1: TLabel
    Width = 136
    Caption = 'CategoryParameters'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select cp.*, p.Value, p.TableName, p.ValueT'
      'from CategoryParams cp'
      'join Parameters p on cp.ParameterId = p.Id'
      'where ProductCategoryID = :ProductCategoryID')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  inherited DataSource: TDataSource
    Top = 25
  end
end
