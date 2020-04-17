object frmDictonary: TfrmDictonary
  Left = 0
  Top = 0
  Caption = 'frmDictonary'
  ClientHeight = 478
  ClientWidth = 790
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 350
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    790
    478)
  PixelsPerInch = 96
  TextHeight = 18
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 429
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btnOk: TcxButton
    Left = 536
    Top = 435
    Width = 115
    Height = 37
    Action = actOk
    Anchors = [akRight, akBottom]
    TabOrder = 1
  end
  object btnCancel: TcxButton
    Left = 666
    Top = 435
    Width = 115
    Height = 37
    Action = actCancel
    Anchors = [akRight, akBottom]
    TabOrder = 2
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 32
    Top = 432
    object actOk: TAction
      Caption = #1054#1050
      ImageIndex = 3
      OnExecute = actOkExecute
    end
    object actCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 14
      OnExecute = actCancelExecute
    end
  end
end
