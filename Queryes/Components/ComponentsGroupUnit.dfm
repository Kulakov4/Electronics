inherited ComponentsGroup: TComponentsGroup
  Width = 514
  Height = 122
  ExplicitWidth = 514
  ExplicitHeight = 122
  inherited GridPanel1: TGridPanel
    Width = 514
    Height = 122
    ControlCollection = <
      item
        Column = -1
        Row = -1
      end
      item
        Column = -1
        Row = -1
      end
      item
        Column = -1
        Row = -1
      end
      item
        Column = -1
        Row = 0
      end
      item
        Column = 0
        Control = qFamily
        Row = 0
      end
      item
        Column = 1
        Control = qComponents
        Row = 0
      end>
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 514
    ExplicitHeight = 122
    inline qFamily: TQueryFamily
      Left = 1
      Top = 1
      Width = 256
      Height = 120
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 256
      ExplicitHeight = 120
    end
    inline qComponents: TQueryComponents
      Left = 257
      Top = 1
      Width = 256
      Height = 120
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 257
      ExplicitTop = 1
      ExplicitWidth = 256
      ExplicitHeight = 120
    end
  end
  object fdqUpdateBody: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'update Products'
      'set BodyId = :BodyId'
      'where ID = :ID')
    Left = 11
    Top = 80
    ParamData = <
      item
        Name = 'BODYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
