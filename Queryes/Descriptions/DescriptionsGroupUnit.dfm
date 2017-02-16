inherited DescriptionsGroup: TDescriptionsGroup
  Width = 604
  Height = 81
  ExplicitWidth = 604
  ExplicitHeight = 81
  inherited GridPanel1: TGridPanel
    Width = 604
    Height = 81
    ColumnCollection = <
      item
        Value = 33.500513086818390000
      end
      item
        Value = 33.500513086818390000
      end
      item
        Value = 32.998973826363220000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = qDescriptionsMaster
        Row = 0
      end
      item
        Column = 1
        Control = qDescriptionsDetail
        Row = 0
      end
      item
        Column = 2
        Control = qManufacturers2
        Row = 0
      end>
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 574
    ExplicitHeight = 145
    inline qDescriptionsMaster: TQueryDescriptionsMaster
      Left = 1
      Top = 1
      Width = 201
      Height = 79
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 67
      ExplicitTop = 1
      ExplicitWidth = 143
      ExplicitHeight = 125
    end
    inline qDescriptionsDetail: TQueryDescriptionsDetail
      Left = 202
      Top = 1
      Width = 201
      Height = 79
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 225
      ExplicitTop = 37
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
    inline qManufacturers2: TQueryManufacturers2
      Left = 403
      Top = 1
      Width = 200
      Height = 79
      Align = alClient
      TabOrder = 2
      ExplicitLeft = 387
      ExplicitTop = 37
      ExplicitWidth = 182
      ExplicitHeight = 71
    end
  end
end
