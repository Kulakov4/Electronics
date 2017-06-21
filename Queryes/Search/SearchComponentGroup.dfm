inherited QuerySearchComponentGroup: TQuerySearchComponentGroup
  inherited Label1: TLabel
    Width = 156
    Caption = 'SearchComponentGroup'
    ExplicitWidth = 156
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ComponentGroups'
      'where upper(ComponentGroup) = upper(:ComponentGroup)')
    ParamData = <
      item
        Name = 'COMPONENTGROUP'
        ParamType = ptInput
      end>
  end
end
