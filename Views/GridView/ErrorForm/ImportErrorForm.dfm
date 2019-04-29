inherited frmImportError: TfrmImportError
  Caption = #1054#1096#1080#1073#1082#1080' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077
  ClientHeight = 430
  ClientWidth = 610
  ExplicitWidth = 626
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Width = 609
    Height = 372
    ExplicitWidth = 609
    ExplicitHeight = 372
  end
  inherited cxbtnOK: TcxButton
    Left = 270
    Top = 387
    DropDownMenu = pmContinue
    Kind = cxbkDropDownButton
    ExplicitLeft = 270
    ExplicitTop = 387
  end
  inherited lblStatus: TcxLabel
    Top = 391
    ExplicitTop = 391
  end
  object cxButton2: TcxButton [3]
    Left = 439
    Top = 387
    Width = 163
    Height = 33
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object pmContinue: TPopupMenu [4]
    Left = 131
    Top = 35
    object N1: TMenuItem
      Action = actAll
      Default = True
    end
    object N2: TMenuItem
      Action = actSkip
    end
  end
end
