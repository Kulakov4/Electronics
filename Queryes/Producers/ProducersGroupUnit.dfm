inherited ProducersGroup: TProducersGroup
  Width = 315
  Height = 90
  ExplicitWidth = 315
  ExplicitHeight = 90
  inherited GridPanel1: TGridPanel
    Width = 315
    Height = 90
    ControlCollection = <
      item
        Column = 0
        Control = qProducerTypes
        Row = 0
      end
      item
        Column = 1
        Control = qProducers
        Row = 0
      end>
    ExplicitWidth = 315
    ExplicitHeight = 90
    inline qProducerTypes: TQueryProducerTypes
      Left = 1
      Top = 1
      Width = 156
      Height = 88
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 156
      ExplicitHeight = 88
    end
    inline qProducers: TQueryProducers
      Left = 157
      Top = 1
      Width = 157
      Height = 88
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 157
      ExplicitTop = 1
      ExplicitWidth = 157
      ExplicitHeight = 88
    end
  end
end
