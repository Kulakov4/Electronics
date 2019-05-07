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
  System.Actions, Vcl.ActnList, cxCheckBox, cxMaskEdit, cxDropDownEdit;

type
  TfrmLoadParametricData = class(TForm)
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
    cxcbLoadComponentGroup: TcxCheckBox;
    cxcbShowParametricTable: TcxCheckBox;
    cxcbFileName: TcxComboBox;
    procedure actOKExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure cxcbLoadComponentGroupClick(Sender: TObject);
    procedure cxcbFileNamePropertiesChange(Sender: TObject);
  private const
    IniIdent: String = 'File';

  var
    FIniSection: string;
    function GetFileName: string;
    function GetLoadComponentGroup: Boolean;
    function GetReplace: Boolean;
    function GetShowParametricTable: Boolean;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent; AParametricTable: Boolean);
    property FileName: string read GetFileName;
    property LoadComponentGroup: Boolean read GetLoadComponentGroup;
    property Replace: Boolean read GetReplace;
    property ShowParametricTable: Boolean read GetShowParametricTable;
    { Public declarations }
  end;

implementation

uses
  DialogUnit, SettingsController, System.IOUtils, System.StrUtils;

{$R *.dfm}

constructor TfrmLoadParametricData.Create(AOwner: TComponent;
  AParametricTable: Boolean);
begin
  inherited Create(AOwner);
  Caption := IfThen(AParametricTable, 'Загрузка параметрической таблицы',
    'Загрузка параметрических данных');

  FIniSection := IfThen(AParametricTable, 'ParametricTableFiles',
    'ParametricDataFiles');

  cxbtnOK.Enabled := False;

  // Загружаем список последних файлов
  cxcbFileName.Properties.Items.AddStrings
    (TSettings.Create.LoadStrings(FIniSection, IniIdent));
end;

procedure TfrmLoadParametricData.actOKExecute(Sender: TObject);
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

procedure TfrmLoadParametricData.actOpenFileExecute(Sender: TObject);
var
  AFileName: string;
begin
  inherited;
  if not TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.ParametricDataFolder, '', AFileName) then
    Exit;

  cxcbFileName.Text := AFileName;
end;

procedure TfrmLoadParametricData.cxcbFileNamePropertiesChange(Sender: TObject);
begin
  cxbtnOK.Enabled := cxcbFileName.Text <> '';
end;

procedure TfrmLoadParametricData.cxcbLoadComponentGroupClick(Sender: TObject);
begin
  cxcbShowParametricTable.Enabled := cxcbLoadComponentGroup.Checked;

  if not cxcbShowParametricTable.Enabled then
    cxcbShowParametricTable.Checked := False;
end;

function TfrmLoadParametricData.GetFileName: string;
begin
  Result := cxcbFileName.Text;
end;

function TfrmLoadParametricData.GetLoadComponentGroup: Boolean;
begin
  Result := cxcbLoadComponentGroup.Checked;
end;

function TfrmLoadParametricData.GetReplace: Boolean;
begin
  Result := cxrbReplace.Checked;
end;

function TfrmLoadParametricData.GetShowParametricTable: Boolean;
begin
  Result := cxcbShowParametricTable.Checked;
end;

end.
