inherited QueryReports: TQueryReports
  inherited Label1: TLabel
    Width = 45
    Caption = 'Report'
    ExplicitWidth = 45
  end
  inherited DataSource: TDataSource
    AutoEdit = False
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    ifnull(pup.Value, '#39#1053#1077' '#1079#1072#1076#1072#1085#39') '#1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100','
      '    p.Value '#1050#1086#1084#1087#1086#1085#1077#1085#1090','
      
        '    case when d.Description is null then '#39#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090#39' else '#39#39' e' +
        'nd '#1054#1087#1080#1089#1072#1085#1080#1077','
      
        '    case when pup3.Value is null then '#39#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090#39' else '#39#39' end ' +
        #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103','
      
        '    case when pup4.Value is null then '#39#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090#39' else '#39#39' end ' +
        #1057#1093#1077#1084#1072','
      
        '    case when pup5.Value is null then '#39#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090#39' else '#39#39' end ' +
        #1063#1077#1088#1090#1105#1078','
      
        '    case when pup6.Value is null then '#39#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090#39' else '#39#39' end ' +
        #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      'from products p'
      
        'left join ProductUnionParameters pup on pup.ProductID = p.Id and' +
        ' pup.UnionParameterId = :ProducerParameterID'
      
        'left join ProductUnionParameters pup2 on pup2.ProductID = p.Id a' +
        'nd pup2.UnionParameterId = :PackagePinsParameterID'
      
        'left join ProductUnionParameters pup3 on pup3.ProductID = p.Id a' +
        'nd pup3.UnionParameterId = :DatasheetParameterID'
      
        'left join ProductUnionParameters pup4 on pup4.ProductID = p.Id a' +
        'nd pup4.UnionParameterId = :DiagramParameterID'
      
        'left join ProductUnionParameters pup5 on pup5.ProductID = p.Id a' +
        'nd pup5.UnionParameterId = :DrawingParameterID'
      
        'left join ProductUnionParameters pup6 on pup6.ProductID = p.Id a' +
        'nd pup6.UnionParameterId = :ImageParameterID'
      'left join Descriptions2 d on p.Value = d.ComponentName'
      'where '
      ''
      '('
      'pup3.Value is null'
      'or pup4.Value is null'
      'or pup5.Value is null'
      'or pup6.Value is null'
      'or d.Description is null'
      ')'
      'and ParentProductID is null'
      'order by '#1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100', '#1050#1086#1084#1087#1086#1085#1077#1085#1090)
    ParamData = <
      item
        Name = 'PRODUCERPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PACKAGEPINSPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DATASHEETPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DIAGRAMPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DRAWINGPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IMAGEPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
