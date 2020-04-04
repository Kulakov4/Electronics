unit CompFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxBar, cxClasses, System.Actions, Vcl.ActnList,
  NotifyEvents;

type
  TfrmComp = class(TFrame)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    ActionList: TActionList;
    actLoadFromExcelFolder: TAction;
    actLoadFromExcelDocument: TAction;
    actLoadParametricTable: TAction;
    actLoadParametricData: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarSubItem4: TdxBarSubItem;
    actLoadParametricTableRange: TAction;
    dxBarButton5: TdxBarButton;
    dxBarSubItem5: TdxBarSubItem;
    actAutoBindingDoc: TAction;
    actAutoBindingDescriptions: TAction;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    procedure actAutoBindingDescriptionsExecute(Sender: TObject);
    procedure actAutoBindingDocExecute(Sender: TObject);
    procedure actLoadFromExcelDocumentExecute(Sender: TObject);
    procedure actLoadFromExcelFolderExecute(Sender: TObject);
    procedure actLoadParametricDataExecute(Sender: TObject);
    procedure actLoadParametricTableExecute(Sender: TObject);
  private
    FOnLoadCompFromExcelFolder: TNotifyEventsEx;
    FOnLoadCompFromExcelDocument: TNotifyEventsEx;
    FOnLoadParametricTable: TNotifyEventsEx;
    FOnLoadParametricData: TNotifyEventsEx;
    FOnAutoBindingDoc: TNotifyEventsEx;
    FOnAutoBindingDescription: TNotifyEventsEx;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnLoadCompFromExcelFolder: TNotifyEventsEx read
        FOnLoadCompFromExcelFolder;
    property OnLoadCompFromExcelDocument: TNotifyEventsEx read
        FOnLoadCompFromExcelDocument;
    property OnLoadParametricTable: TNotifyEventsEx read FOnLoadParametricTable;
    property OnLoadParametricData: TNotifyEventsEx read FOnLoadParametricData;
    property OnAutoBindingDoc: TNotifyEventsEx read FOnAutoBindingDoc;
    property OnAutoBindingDescription: TNotifyEventsEx read
        FOnAutoBindingDescription;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, FormsHelper, ProjectConst;

constructor TfrmComp.Create(AOwner: TComponent);
begin
  inherited;
  FOnLoadCompFromExcelFolder := TNotifyEventsEx.Create(Self);
  FOnLoadCompFromExcelDocument := TNotifyEventsEx.Create(Self);
  FOnLoadParametricTable := TNotifyEventsEx.Create(Self);
  FOnLoadParametricData := TNotifyEventsEx.Create(Self);
  FOnAutoBindingDoc := TNotifyEventsEx.Create(Self);
  FOnAutoBindingDescription := TNotifyEventsEx.Create(Self);
  TFormsHelper.SetFont(Self, BaseFontSize);
end;

destructor TfrmComp.Destroy;
begin
  inherited;
  FreeAndNil(FOnLoadCompFromExcelFolder);
  FreeAndNil(FOnLoadCompFromExcelDocument);
  FreeAndNil(FOnLoadParametricTable);
  FreeAndNil(FOnLoadParametricData);
  FreeAndNil(FOnAutoBindingDoc);
  FreeAndNil(FOnAutoBindingDescription);
end;

procedure TfrmComp.actAutoBindingDescriptionsExecute(Sender: TObject);
begin
  FOnAutoBindingDescription.CallEventHandlers(Self);
end;

procedure TfrmComp.actAutoBindingDocExecute(Sender: TObject);
begin
  FOnAutoBindingDoc.CallEventHandlers(Self);
end;

procedure TfrmComp.actLoadFromExcelDocumentExecute(Sender: TObject);
begin
  FOnLoadCompFromExcelDocument.CallEventHandlers(Self);
end;

procedure TfrmComp.actLoadFromExcelFolderExecute(Sender: TObject);
begin
  FOnLoadCompFromExcelFolder.CallEventHandlers(Self);
end;

procedure TfrmComp.actLoadParametricDataExecute(Sender: TObject);
begin
  FOnLoadParametricData.CallEventHandlers(Self);
end;

procedure TfrmComp.actLoadParametricTableExecute(Sender: TObject);
begin
  FOnLoadParametricTable.CallEventHandlers(Self);
end;

end.
