inherited ComponentsMasterDetail: TComponentsMasterDetail
  Height = 105
  ExplicitHeight = 105
  inherited GridPanel1: TGridPanel
    Left = 3
    ControlCollection = <
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
        Control = qComponents
        Row = 0
      end
      item
        Column = 1
        Control = qComponentsDetail
        Row = 0
      end>
    ExplicitLeft = 3
    DesignSize = (
      294
      73)
    inline qComponents: TQueryComponents
      Left = 1
      Top = 1
      Width = 146
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 146
      ExplicitHeight = 71
    end
    inline qComponentsDetail: TQueryComponentsDetail
      Left = 147
      Top = 1
      Width = 146
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 147
      ExplicitTop = 1
      ExplicitWidth = 146
      ExplicitHeight = 71
    end
  end
  object fdqUpdateBody: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'update Products'
      'set BodyId = :BodyId'
      'where ID = :ID')
    Left = 51
    Top = 64
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
