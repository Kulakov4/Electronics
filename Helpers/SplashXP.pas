/// /////////////////////////////////////////////////////////////////////////////
// //
// Sanders the Softwarer                            //
// //
// MessageForm - ����� ��� ������ ��������� � ���� ���������� ��������    //
// //
// ����������� ��������� ���������                       //
// //
/// /////////////////////////////////////////////////////////////////////////////

{ ----- ������� ----------------------------------------------------------------

  ����� �������� ����� �������������� ���� ������, ������������ ���, ������������
  � ����������� ����������� ��������, � ��� ����� ������������, ��� �������������
  � �������������� ����������� �� ������. � ����� ������ ������ ������ �����������
  ���������� �� ��������� ������ � �������� ��������������� ������.

  ��� ��������������� ������������ ������ ������ ����� �������� ��� ������ �
  �������� ������ ��� �������������� �������� ����� ����������� ��������� �������.

  ���� �� ������� ���������� ��������� � �������� �������������� �� �� ����
  �������� - �������� � ���, � �� ��������� ��������� ����� ��������� � ���������
  ������ ������. ����� ����� �������� � ��������� �������, ���� ����� �����.

  �����: Sanders Prostorov, 2:5020/1583, softwarer@mail.ru, softwarer@nm.ru

  ------------------------------------------------------------------------------ }

{ ----- �������� ---------------------------------------------------------------

  ����� ��������� ������� �� ����� ��������������� ���� � ��������� ��������� �
  ���, �� �������� ���������� ��������� ���������� �������� � �������� ������
  ����������. ����� ������������ �������� ��������� �������:

  procedure TSomeForm.SomeActionExecute ;
  begin
  try
  MessageForm.Show ( 'Some Action', 'Start...' ) ;
  ...
  MessageForm.Text ( 'In process...' ) ;
  ...
  MessageForm.Text ( 'Near finish...' ) ;
  ...
  finally
  MessageForm.Close ;
  end ;
  end ;

  ������ Show � Close ����� ���� ����������, �� ������ ����������� ��������. ���
  ��������� �������� ���� ������������, ������������ �����, �� ������ ������������,
  ����� ������������ �����.

  ��� ������ ������ ����������� ����������� ����� Application.ProcessMessages.
  ������������ �� ������ ������� (������ ��������) ������ Show ����� �����������
  ��� �� ����������, ��� � � ������ TCustomForm.ShowModal; ����� �������, ��������
  �� ��������� ���������, �� ������ � ������ �������� ���������� ��������
  ������������. ����� ������������ Close ������� ��������� � ������ finally, ���
  ��� � ��������� ������ ���� ��������� ����� �������� �� ������, � �� ����� ���
  ������ ����� ����� ����������.

  ------------------------------------------------------------------------------ }

{ ----- ������� �������� -------------------------------------------------------

  ??.??.2000 ������ ������
  04.05.2004 ����� ������� � ������ � �������� ��� ���������� ���������������

  ------------------------------------------------------------------------------ }

unit SplashXP;

interface

uses Classes, SysUtils, Forms, Controls, ExtCtrls, XPMan, Graphics;

type
  { ����������� ����� "���� ���������" }
  MessageForm = class
  public
    class procedure Show(const ACaption, AMessage: string);
    class procedure ShowEx(const ACaption, AMessage: string;
      APosition: TPosition);
    class procedure Text(const AMessage: string);
    class procedure Close;
  end;

implementation

var
  { ���� � ����������� ��� ���������� }
  MsgForm: TForm;
  MsgPanel: TPanel;
  MsgDepth: integer = 0;
  ListDisabled: pointer = nil;
  Manif: TXPManifest;

  { ������������� ���� }

procedure CreateMessageForm;
begin
  MsgForm := TForm.Create(nil);
  with MsgForm do
  begin
    BorderIcons := [];
    BorderStyle := bsDialog;
    // Position := poScreenCenter;
    Position := poMainFormCenter;
    ClientHeight := 48;
    ClientWidth := 360;
  end;
  MsgPanel := TPanel.Create(nil);
  with MsgPanel do
  begin
    Align := alClient;
    BevelInner := bvLowered;
    Parent := MsgForm;
    Font.Size := 8;
    Font.Color := clBlue;
  end;
  Manif := TXPManifest.Create(MsgForm);

end;

{ ������ ���� � ���������� }

class procedure MessageForm.Show(const ACaption, AMessage: string);
begin
  Text(AMessage);
  if MsgDepth > 0 then
    Inc(MsgDepth)
  else
  begin
    MsgForm.Caption := ACaption;
    MsgForm.Position := poMainFormCenter;
    MsgForm.Show;
    ListDisabled := DisableTaskWindows(MsgForm.Handle);
    MsgDepth := 1;
    Application.ProcessMessages;
  end;
end;

{ ��������� ������ � ���� }

class procedure MessageForm.Text(const AMessage: string);
begin
  MsgPanel.Caption := AMessage;
  Application.ProcessMessages;
end;

{ �������� ����� }

class procedure MessageForm.Close;
begin
  if MsgDepth > 1 then
    Dec(MsgDepth)
  else
  begin
    EnableTaskWindows(ListDisabled);
    ListDisabled := nil;
    MsgForm.Close;
    MsgDepth := 0;
  end;
end;

class procedure MessageForm.ShowEx(const ACaption, AMessage: string;
  APosition: TPosition);
begin
  Text(AMessage);
  if MsgDepth > 0 then
    Inc(MsgDepth)
  else
  begin
    MsgForm.Caption := ACaption;
    MsgForm.Position := APosition;
    MsgForm.Show;
    ListDisabled := DisableTaskWindows(MsgForm.Handle);
    MsgDepth := 1;
    Application.ProcessMessages;
  end;

end;

initialization

CreateMessageForm;

finalization

FreeAndNil(MsgForm);

end.
