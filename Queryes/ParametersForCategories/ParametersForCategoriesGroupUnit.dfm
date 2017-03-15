inherited ParametersForCategoriesGroup: TParametersForCategoriesGroup
  Width = 400
  Height = 81
  ExplicitWidth = 400
  ExplicitHeight = 81
  inherited GridPanel1: TGridPanel
    Width = 400
    Height = 81
    ControlCollection = <
      item
        Column = -1
        Row = 0
      end
      item
        Column = 0
        Control = qParameterTypes
        Row = 0
      end
      item
        Column = 1
        Control = qParametersDetail
        Row = 0
      end>
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 400
    ExplicitHeight = 81
    inline qParameterTypes: TQueryParameterTypes
      Left = 1
      Top = 1
      Width = 199
      Height = 79
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 199
      ExplicitHeight = 79
    end
    inline qParametersDetail: TQueryParametersDetail
      Left = 200
      Top = 1
      Width = 199
      Height = 79
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 200
      ExplicitTop = 1
      ExplicitWidth = 199
      ExplicitHeight = 79
    end
  end
end
