unit PathSettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Winapi.ShlObj,
  cxShellCommon, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxShellComboBox,
  Vcl.StdCtrls, Vcl.Menus, cxButtons, System.Actions, Vcl.ActnList, RootForm,
  dxBarBuiltInMenu, cxPC, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxClasses, cxShellBrowserDialog,
  System.Generics.Collections, DialogUnit;

{$WARN UNIT_PLATFORM OFF}

type
  TfrmPathSettings = class(TForm)
    ActionList1: TActionList;
    actBrowseOutlineDrawingFolder: TAction;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    actBrowseLandPatternFolder: TAction;
    actBrowseImageFolder: TAction;
    cxPageControl: TcxPageControl;
    cxtshBodyTypes: TcxTabSheet;
    cxtshComponents: TcxTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cxteBodyOutlineDrawingFolder: TcxTextEdit;
    cxteBodyLandPatternFolder: TcxTextEdit;
    cxteBodyImageFolder: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    Label4: TLabel;
    cxteComponentsDataSheetFolder: TcxTextEdit;
    cxButton6: TcxButton;
    Label5: TLabel;
    cxteComponentsImageFolder: TcxTextEdit;
    cxButton7: TcxButton;
    actBrowseComponentsDataSheetFolder: TAction;
    actBrowseComponentsImageFolder: TAction;
    Label6: TLabel;
    cxteComponentsDrawingFolder: TcxTextEdit;
    cxButton8: TcxButton;
    actBrowseComponentsDrawingFolder: TAction;
    Label7: TLabel;
    cxteComponentsDiagramFolder: TcxTextEdit;
    cxButton9: TcxButton;
    actBrowseComponentsSchemeFolder: TAction;
    cxTabSheet1: TcxTabSheet;
    Label8: TLabel;
    cxteDataBasePath: TcxTextEdit;
    cxButton10: TcxButton;
    actBrowseDatabasePath: TAction;
    procedure actBrowseComponentsDataSheetFolderExecute(Sender: TObject);
    procedure actBrowseComponentsDrawingFolderExecute(Sender: TObject);
    procedure actBrowseComponentsImageFolderExecute(Sender: TObject);
    procedure actBrowseComponentsSchemeFolderExecute(Sender: TObject);
    procedure actBrowseDatabasePathExecute(Sender: TObject);
    procedure actBrowseImageFolderExecute(Sender: TObject);
    procedure actBrowseLandPatternFolderExecute(Sender: TObject);
    procedure actBrowseOutlineDrawingFolderExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FTextBoxes: TList<TcxTextEdit>;
    function Check: Boolean;
    procedure InternalSelectDirectory(var ATextEdit: TcxTextEdit;
      AOpenDialogClass: TOpenDialogClass);
    procedure LoadFromSettings;
    procedure SaveToSettings;
    function UpdatePath(const APath, AOldDBPath, ANewDBPath: string): string;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

uses SettingsController, System.IOUtils, Vcl.FileCtrl;

{$R *.dfm}

constructor TfrmPathSettings.Create(AOwner: TComponent);
begin
  inherited;
  FTextBoxes := TList<TcxTextEdit>.Create();
  FTextBoxes.Add(cxteBodyOutlineDrawingFolder);
  FTextBoxes.Add(cxteBodyLandPatternFolder);
  FTextBoxes.Add(cxteBodyImageFolder);
  FTextBoxes.Add(cxteComponentsDataSheetFolder);
  FTextBoxes.Add(cxteComponentsImageFolder);
  FTextBoxes.Add(cxteComponentsDrawingFolder);
  FTextBoxes.Add(cxteComponentsDiagramFolder);

  LoadFromSettings;
end;

destructor TfrmPathSettings.Destroy;
begin
  FreeAndNil(FTextBoxes);
  inherited;
end;

procedure TfrmPathSettings.actBrowseComponentsDataSheetFolderExecute
  (Sender: TObject);
begin
  InternalSelectDirectory(cxteComponentsDataSheetFolder,
    TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseComponentsDrawingFolderExecute
  (Sender: TObject);
begin
  InternalSelectDirectory(cxteComponentsDrawingFolder,
    TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseComponentsImageFolderExecute
  (Sender: TObject);
begin
  InternalSelectDirectory(cxteComponentsImageFolder, TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseComponentsSchemeFolderExecute
  (Sender: TObject);
begin
  InternalSelectDirectory(cxteComponentsDiagramFolder,
    TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseDatabasePathExecute(Sender: TObject);
var
  ANewDBPath: string;
  AOldDBPath: string;
  te: TcxTextEdit;
begin
  AOldDBPath := cxteDataBasePath.Text;
  InternalSelectDirectory(cxteDataBasePath, TDatabaselFilesFolderOpenDialog);
  ANewDBPath := cxteDataBasePath.Text;

  // При изменении пути к БД обновляются пути к её подпапкам
  if AOldDBPath <> ANewDBPath then
  begin
    for te in FTextBoxes do
    begin
      te.Text := UpdatePath(te.Text, AOldDBPath, ANewDBPath);
    end;
  end;
end;

procedure TfrmPathSettings.actBrowseImageFolderExecute(Sender: TObject);
begin
  InternalSelectDirectory(cxteBodyImageFolder, TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseLandPatternFolderExecute(Sender: TObject);
begin
  InternalSelectDirectory(cxteBodyLandPatternFolder, TPDFFilesFolderOpenDialog);
end;

procedure TfrmPathSettings.actBrowseOutlineDrawingFolderExecute
  (Sender: TObject);
begin
  InternalSelectDirectory(cxteBodyOutlineDrawingFolder,
    TPDFFilesFolderOpenDialog);
end;

function TfrmPathSettings.Check: Boolean;
var
  AMsg: string;
  ANotExistsDir: TList<String>;
  ATextEdit: TcxTextEdit;
  S: string;
begin
  ANotExistsDir := TList<String>.Create;
  try
    // Цикл по всем текстбоксам
    for ATextEdit in FTextBoxes do
    begin
      if not TDirectory.Exists(ATextEdit.Text) then
      begin
        ANotExistsDir.Add(ATextEdit.Text);
      end;
    end;

    Result := ANotExistsDir.Count = 0;

    if not Result then
    begin
      AMsg := '';
      for S in ANotExistsDir do
      begin
        AMsg := AMsg + Format(#13#10 + 'Папка %s не существует', [S]);
      end;
      AMsg := AMsg + Format(#13#10 + 'Создать несуществующие папки?', [S]);
      AMsg := AMsg.Trim([#13, #10]);

      Result := TDialog.Create.CreateFolderDialog(AMsg) = IDYes;
      if Result then
      begin
        for S in ANotExistsDir do
        begin
          TDirectory.CreateDirectory(S);
        end;
      end;
    end;
  finally
    FreeAndNil(ANotExistsDir);
  end;
end;

procedure TfrmPathSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if ModalResult = mrOk then
  begin
    SaveToSettings;
  end;
end;

procedure TfrmPathSettings.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose := ModalResult <> mrOk;

  if CanClose then
    Exit;

  CanClose := TDirectory.Exists(cxteDataBasePath.Text);
  if not CanClose then
    TDialog.Create.DirectoryNotExistDialog(cxteDataBasePath.Text)
  else
  begin
    CanClose := Check
  end;
end;

procedure TfrmPathSettings.InternalSelectDirectory(var ATextEdit: TcxTextEdit;
  AOpenDialogClass: TOpenDialogClass);
var
  ARootDir: string;
  ADir: string;
  AFileName: string;
begin
  ARootDir := '';
  // открываемый в дереве путь
  ADir := ATextEdit.Text;

  while not TDirectory.Exists(ADir) and not ADir.IsEmpty do
    ADir := TDirectory.GetParent(ADir);

  // обзор
  // AFileName := TDialog.Create.OpenFolderDialog(ADir);
  AFileName := TDialog.Create.OpenDialog(AOpenDialogClass, ADir);
  if AFileName <> '' then
    ATextEdit.Text := TPath.GetDirectoryName(AFileName);
end;

procedure TfrmPathSettings.LoadFromSettings;
begin
  cxteDataBasePath.Text := TSettings.Create.DataBasePath;

  cxteBodyOutlineDrawingFolder.Text :=
    TSettings.Create.BodyTypesOutlineDrawingFolder;

  cxteBodyLandPatternFolder.Text := TSettings.Create.BodyTypesLandPatternFolder;

  cxteBodyImageFolder.Text := TSettings.Create.BodyTypesImageFolder;

  cxteComponentsDataSheetFolder.Text :=
    TSettings.Create.ComponentsDatasheetFolder;

  cxteComponentsImageFolder.Text := TSettings.Create.ComponentsImageFolder;

  cxteComponentsDrawingFolder.Text := TSettings.Create.ComponentsDrawingFolder;

  cxteComponentsDiagramFolder.Text := TSettings.Create.ComponentsDiagramFolder;
end;

procedure TfrmPathSettings.SaveToSettings;
begin
  TSettings.Create.DataBasePath := cxteDataBasePath.Text;

  TSettings.Create.BodyTypesOutlineDrawingFolder :=
    cxteBodyOutlineDrawingFolder.Text;

  TSettings.Create.BodyTypesLandPatternFolder := cxteBodyLandPatternFolder.Text;

  TSettings.Create.BodyTypesImageFolder := cxteBodyImageFolder.Text;

  TSettings.Create.ComponentsDrawingFolder := cxteComponentsDrawingFolder.Text;

  TSettings.Create.ComponentsImageFolder := cxteComponentsImageFolder.Text;

  TSettings.Create.ComponentsDiagramFolder := cxteComponentsDiagramFolder.Text;

  TSettings.Create.ComponentsDatasheetFolder :=
    cxteComponentsDataSheetFolder.Text;
end;

function TfrmPathSettings.UpdatePath(const APath, AOldDBPath,
  ANewDBPath: string): string;
var
  S: string;
begin
  Result := APath;

  if TPath.IsRelativePath(APath) then
    Result := TPath.Combine(ANewDBPath, APath)
  else
  begin
    // Если путь начинается с пути до базы данных
    if APath.IndexOf(AOldDBPath) = 0 then
    begin
      S := TPath.Combine(ANewDBPath, APath.Substring(AOldDBPath.Length + 1));
//      if TDirectory.Exists(S) then
        Result := S;
    end;
  end;
end;

end.
