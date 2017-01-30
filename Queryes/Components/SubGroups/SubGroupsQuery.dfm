inherited frmQuerySubGroups: TfrmQuerySubGroups
  inherited Label1: TLabel
    Width = 69
    Caption = 'SubGroups'
    ExplicitWidth = 69
  end
  inherited FDQuery: TFDQuery
    CachedUpdates = True
    SQL.Strings = (
      
        'select pc.*, case when pc.ExternalID = :MainExternalID then 1 el' +
        'se 0 end IsMain'
      'from ProductCategories pc'
      'where instr(:Value, '#39','#39' || pc.ExternalID || '#39','#39') > 0 '
      'order by IsMain desc, pc.ExternalId')
    ParamData = <
      item
        Name = 'MAINEXTERNALID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
