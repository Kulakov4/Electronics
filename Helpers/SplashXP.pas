/// /////////////////////////////////////////////////////////////////////////////
// //
// Sanders the Softwarer                            //
// //
// MessageForm - класс для вывода сообщений в ходе длительных операций    //
// //
// Программист Александр Просторов                       //
// //
/// /////////////////////////////////////////////////////////////////////////////

{ ----- Официоз ----------------------------------------------------------------

  Любой желающий может распространять этот модуль, дорабатывать его, использовать
  в собственных программных проектах, в том числе коммерческих, без необходимости
  в дополнительных разрешениях от автора. В любой версии модуля должна сохраняться
  информация об авторских правах и условиях распространения модуля.

  При распространении доработанных версий модуля прошу изменить имя модуля и
  базового класса для предотвращения коллизий между доработками различных авторов.

  Если Вы сделали интересную доработку и согласны распространять ее на этих
  условиях - сообщите о ней, и мы обговорим включение Вашей доработки в авторскую
  версию модуля. Также прошу сообщать о найденных ошибках, если такие будут.

  Автор: Sanders Prostorov, 2:5020/1583, softwarer@mail.ru, softwarer@nm.ru

  ------------------------------------------------------------------------------ }

{ ----- Описание ---------------------------------------------------------------

  Класс позволяет вывести на экран псевдомодальное окно и обновлять сообщения в
  нем, не прерывая выполнения некоторой длительной операции в основном потоке
  приложения. Класс используется примерно следующим образом:

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

  Вызовы Show и Close могут быть вложенными, но должна соблюдаться парность. Это
  позволяет вызывать одну подпрограмму, использующую класс, из другой подпрограммы,
  также использующей класс.

  При каждом вызове подпрограмм выполняется также Application.ProcessMessages.
  Существующие на момент первого (самого внешнего) вызова Show формы блокируются
  тем же механизмом, что и в случае TCustomForm.ShowModal; таким образом, несмотря
  на обработку сообщений, их кнопки и другие элементы управления остаются
  недоступными. Вызов подпрограммы Close следует размещать в секции finally, так
  как в противном случае окно сообщений может остаться на экране, в то время как
  другие формы будут недоступны.

  ------------------------------------------------------------------------------ }

{ ----- История развития -------------------------------------------------------

  ??.??.2000 Первая версия
  04.05.2004 Класс выделен в модуль и оформлен для свободного распространения

  ------------------------------------------------------------------------------ }

unit SplashXP;

interface

uses Classes, SysUtils, Forms, Controls, ExtCtrls, XPMan, Graphics;

type
  { Статический класс "окна сообщений" }
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
  { Окно и необходимые ему переменные }
  MsgForm: TForm;
  MsgPanel: TPanel;
  MsgDepth: integer = 0;
  ListDisabled: pointer = nil;
  Manif: TXPManifest;

  { Инициализация окна }

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

{ Запуск окна с сообщением }

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

{ Изменение текста в окне }

class procedure MessageForm.Text(const AMessage: string);
begin
  MsgPanel.Caption := AMessage;
  Application.ProcessMessages;
end;

{ Закрытие формы }

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
