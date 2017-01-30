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
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    { Public declarations }
  end;

var
  frmRoot: TfrmRoot;

implementation

{$R *.dfm}

constructor TfrmRoot.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmRoot.AfterConstruction;
begin
  inherited;
  // Scaled := True;
end;

{ Сделать форму независимой от основного окна программы }
procedure TfrmRoot.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmRoot.FormCreate(Sender: TObject);
begin
  TFormsHelper.StringToFormStats(TSettings.Create.GetValue('Forms',
    Name), Self);
end;

procedure TfrmRoot.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TSettings.Create.SetValue('Forms', Name,
    TFormsHelper.FormStatsToString(Self));
end;

end.
