unit AutoBindingDocForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, cxCheckBox, cxGroupBox, Vcl.StdCtrls, cxRadioGroup,
  Vcl.Menus, cxButtons, System.Actions, Vcl.ActnList,
  System.Generics.Collections, DocFieldInfo;

type
  TfrmAutoBindingDoc = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxcbDatasheet: TcxCheckBox;
    cxcbDiagram: TcxCheckBox;
    cxcbDrawing: TcxCheckBox;
    cxcbImage: TcxCheckBox;
    GroupBox1: TGroupBox;
    cxrbNoRange: TcxRadioButton;
    cxrbNarrowRange: TcxRadioButton;
    cxbtnAllDB: TcxButton;
    cxbtnCategoryDB: TcxButton;
    cxbtnCancel: TcxButton;
    ActionList: TActionList;
    actAll: TAction;
    actCategory: TAction;
    cxGroupBox2: TcxGroupBox;
    cxcbAbsentDoc: TcxCheckBox;
    procedure actAllUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDocs: TList<TDocFieldInfo>;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Docs: TList<TDocFieldInfo> read FDocs;
    { Public declarations }
  end;

implementation

uses
  FormsHelper;

{$R *.dfm}

constructor TfrmAutoBindingDoc.Create(AOwner: TComponent);
begin
  inherited;
  FDocs := TList<TDocFieldInfo>.Create;
  TFormsHelper.SetFont(Self);
end;

destructor TfrmAutoBindingDoc.Destroy;
begin
  FreeAndNil(FDocs);
  inherited;
end;

procedure TfrmAutoBindingDoc.actAllUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cxcbDatasheet.Checked or cxcbDiagram.Checked or
    cxcbDrawing.Checked or cxcbImage.Checked;
end;

procedure TfrmAutoBindingDoc.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if cxcbDatasheet.Checked then
    FDocs.Add(TComponentDatasheetDoc.Create);

  if cxcbDiagram.Checked then
    FDocs.Add(TComponentDiagramDoc.Create);

  if cxcbDrawing.Checked then
    FDocs.Add(TComponentDrawingDoc.Create);

  if cxcbImage.Checked then
    FDocs.Add(TComponentImageDoc.Create);
end;

end.
