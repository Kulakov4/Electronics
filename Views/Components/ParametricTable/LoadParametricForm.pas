unit LoadParametricForm;

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
  System.Actions, Vcl.ActnList, cxCheckBox, cxMaskEdit, cxDropDownEdit;

type
  TfrmLoadParametric = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxrbReplace: TcxRadioButton;
    cxrbAdd: TcxRadioButton;
    cxGroupBox2: TcxGroupBox;
    cxButton1: TcxButton;
    cxImageList1: TcxImageList;
    cxbtnOK: TcxButton;
    cxbtnCancel: TcxButton;
    ActionList1: TActionList;
    actOpenFile: TAction;
    actOK: TAction;
    cxGroupBox3: TcxGroupBox;
    cxcbFileName: TcxComboBox;
    procedure actOKExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure cxcbFileNamePropertiesChange(Sender: TObject);
  private const
    IniIdent: String = 'File';

  var
    function GetFileName: string;
    function GetReplace: Boolean;
    { Private declarations }
  protected
    FIniSection: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    property FileName: string read GetFileName;
    property Replace: Boolean read GetReplace;
    { Public declarations }
  end;

implementation

uses
  DialogUnit, SettingsController, System.IOUtils, System.StrUtils, FormsHelper,
  ProjectConst;

{$R *.dfm}

constructor TfrmLoadParametric.Create(AOwner: TComponent);
begin
  inherited;
  TFormsHelper.SetFont(Self, BaseFontSize);
end;

procedure TfrmLoadParametric.actOKExecute(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  if TFile.Exists(FileName) then
  begin
    i := cxcbFileName.Properties.Items.IndexOf(cxcbFileName.Text);
    if i >= 0 then
      cxcbFileName.Properties.Items.Delete(i);

    cxcbFileName.Properties.Items.Insert(0, cxcbFileName.Text);

    // Сохраняем список файлов в настройках
    TSettings.Create.SaveStrings(FIniSection, IniIdent,
      cxcbFileName.Properties.Items.ToStringArray);
    ModalResult := mrOK;
  end
  else
    TDialog.Create.ErrorMessageDialog(Format('Файл %s не найден', [FileName]));
end;

procedure TfrmLoadParametric.actOpenFileExecute(Sender: TObject);
var
  AFileName: string;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit;

  cxcbFileName.Text := AFileName;
end;

procedure TfrmLoadParametric.AfterConstruction;
begin
  inherited;
  cxbtnOK.Enabled := False;

  Assert(not FIniSection.IsEmpty);

  // Загружаем список последних файлов
  cxcbFileName.Properties.Items.AddStrings
    (TSettings.Create.LoadStrings(FIniSection, IniIdent));
end;

procedure TfrmLoadParametric.cxcbFileNamePropertiesChange(Sender: TObject);
begin
  cxbtnOK.Enabled := cxcbFileName.Text <> '';
end;

function TfrmLoadParametric.GetFileName: string;
begin
  Result := cxcbFileName.Text;
end;

function TfrmLoadParametric.GetReplace: Boolean;
begin
  Result := cxrbReplace.Checked;
end;

end.
