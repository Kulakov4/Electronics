unit LoadParametricDataForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxGroupBox, cxLabel, Vcl.StdCtrls, cxRadioGroup,
  Vcl.Menus, System.ImageList, Vcl.ImgList, cxImageList, cxButtons, cxTextEdit,
  System.Actions, Vcl.ActnList;

type
  TfrmLoadParametricData = class(TfrmRoot)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxrbReplace: TcxRadioButton;
    cxrbAdd: TcxRadioButton;
    cxGroupBox2: TcxGroupBox;
    cxteFileName: TcxTextEdit;
    cxButton1: TcxButton;
    cxImageList1: TcxImageList;
    cxbtnOK: TcxButton;
    cxbtnCancel: TcxButton;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actOK: TAction;
    procedure actOKExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure cxteFileNamePropertiesChange(Sender: TObject);
  private
    function GetFileName: string;
    function GetReplace: Boolean;
    { Private declarations }
  protected
  public
    class function ShowDialog(const ACaption: string; var AFileName: String; var
        AReplace: Boolean): Boolean; static;
    property FileName: string read GetFileName;
    property Replace: Boolean read GetReplace;
    { Public declarations }
  end;

implementation

uses
  DialogUnit, SettingsController, System.IOUtils;

{$R *.dfm}

procedure TfrmLoadParametricData.actOKExecute(Sender: TObject);
begin
  inherited;
  if TFile.Exists(FileName) then
    ModalResult := mrOK
  else
    TDialog.Create.ErrorMessageDialog(Format('Файл %s не найден', [FileName]));
end;

procedure TfrmLoadParametricData.cxteFileNamePropertiesChange(Sender: TObject);
begin
  inherited;
  cxbtnOK.Enabled := cxteFileName.Text <> '';
end;

procedure TfrmLoadParametricData.FormCreate(Sender: TObject);
begin
  inherited;
  cxbtnOK.Enabled := False;
end;

procedure TfrmLoadParametricData.actOpenFileExecute(Sender: TObject);
var
  AFileName: string;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit;

  cxteFileName.Text := AFileName;
end;

function TfrmLoadParametricData.GetFileName: string;
begin
  Result := cxteFileName.Text;
end;

function TfrmLoadParametricData.GetReplace: Boolean;
begin
  Result := cxrbReplace.Checked;
end;

class function TfrmLoadParametricData.ShowDialog(const ACaption: string; var
    AFileName: String; var AReplace: Boolean): Boolean;
var
  AForm: TfrmLoadParametricData;
begin
  Assert(not ACaption.IsEmpty);
  AForm := TfrmLoadParametricData.Create(nil);
  try
    AForm.Caption := ACaption;
    Result := AForm.ShowModal = mrOK;
    if Result then
    begin
      AFileName := AForm.FileName;
      AReplace := AForm.Replace;
    end;

  finally
    FreeAndNil(AForm);
  end;
end;

end.
