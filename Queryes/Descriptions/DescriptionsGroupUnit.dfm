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
        Control = qProducers
        Row = 0
      end>
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 604
    ExplicitHeight = 81
    inline qDescriptionsMaster: TQueryDescriptionsMaster
      Left = 1
      Top = 1
      Width = 201
      Height = 79
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 201
      ExplicitHeight = 79
    end
    inline qDescriptionsDetail: TQueryDescriptionsDetail
      Left = 202
      Top = 1
      Width = 201
      Height = 79
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 202
      ExplicitTop = 1
      ExplicitWidth = 201
      ExplicitHeight = 79
    end
    inline qProducers: TQueryProducers
      Left = 403
      Top = 1
      Width = 200
      Height = 78
      Anchors = []
      TabOrder = 2
      ExplicitLeft = 403
      ExplicitTop = 1
    end
  end
end
