inherited DescriptionsMasterDetail: TDescriptionsMasterDetail
  Width = 574
  ExplicitWidth = 574
  inherited GridPanel1: TGridPanel
    Width = 550
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
    ExplicitWidth = 550
    DesignSize = (
      550
      73)
    inline qDescriptionsMaster: TQueryDescriptionsMaster
      Left = 30
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 30
      ExplicitTop = 1
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
    inline qDescriptionsDetail: TQueryDescriptionsDetail
      Left = 213
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 213
      ExplicitTop = 1
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
    inline qManufacturers2: TQueryManufacturers2
      Left = 367
      Top = 1
      Width = 182
      Height = 71
      Anchors = []
      TabOrder = 2
      ExplicitLeft = 367
      ExplicitTop = 1
      ExplicitWidth = 182
      ExplicitHeight = 71
    end
  end
end
