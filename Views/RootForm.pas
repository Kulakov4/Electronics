unit RootForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SettingsController, FormsHelper;

type
  TfrmRoot = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FAutoSaveFormSize: Boolean;
    procedure SetAutoSaveFormSize(const Value: Boolean);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoOnCaptionClick;
    procedure ClearSelection(AComponent: TComponent);
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  public
    constructor Create(AOwner: TComponent); override;
    property AutoSaveFormSize: Boolean read FAutoSaveFormSize
      write SetAutoSaveFormSize;
    { Public declarations }
  end;

implementation

uses
  System.Generics.Collections, SelectionInt, ProjectConst;

{$R *.dfm}

constructor TfrmRoot.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSaveFormSize := True;
end;

{ —делать форму независимой от основного окна программы }
procedure TfrmRoot.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmRoot.DoOnCaptionClick;
begin
  ClearSelection(Self);
end;

procedure TfrmRoot.FormCreate(Sender: TObject);
begin
  if FAutoSaveFormSize then
    TFormsHelper.StringToFormStats(TSettings.Create.GetValue('Forms',
      Name), Self);

  TFormsHelper.SetFont(Self, BaseFontSize);
end;

procedure TfrmRoot.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FAutoSaveFormSize then
    TSettings.Create.SetValue('Forms', Name,
      TFormsHelper.FormStatsToString(Self));
end;

procedure TfrmRoot.ClearSelection(AComponent: TComponent);
var
  i: Integer;
  ISel: ISelection;
begin
  for i := 0 to AComponent.ComponentCount - 1 do
  begin
    // if AComponent.Components[i] is TfrmGrid then
    // (AComponent.Components[i] as TfrmGrid).ClearSelection;
    if AComponent.Components[i].GetInterface(ISelection, ISel) then
      if ISel.HaveFocus then
        ISel.ClearSelection;

    // »щем среди дочерних компонентов
    ClearSelection(AComponent.Components[i]);
  end;
end;

procedure TfrmRoot.SetAutoSaveFormSize(const Value: Boolean);
begin
  FAutoSaveFormSize := Value;
end;

procedure TfrmRoot.WMSysCommand(var Message: TWMSysCommand);
begin
  if Message.CmdType = $F012 then // если клик по заголовку
  begin
    DoOnCaptionClick;
    Application.ProcessMessages;
  end;
  inherited; // вызвать стандартное действие
end;

end.
