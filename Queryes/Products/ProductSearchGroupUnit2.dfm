inherited ProductSearchGroup: TProductSearchGroup
  Width = 202
  Height = 90
  ExplicitWidth = 202
  ExplicitHeight = 90
  inherited GridPanel1: TGridPanel
    Width = 202
    Height = 90
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = qProductsSearch
        Row = 0
      end>
    inline qProductsSearch: TQueryProductsSearch
      Left = 1
      Top = 1
      Width = 200
      Height = 88
      Align = alClient
      TabOrder = 0
      ExplicitTop = 2
      ExplicitWidth = 204
      ExplicitHeight = 143
    end
  end
end
