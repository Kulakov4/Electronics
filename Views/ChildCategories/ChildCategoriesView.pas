unit ChildCategoriesView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, ChildCategoriesQuery, DragHelper, HRTimer,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu;

type
  TViewChildCategories = class(TfrmGrid)
    clId: TcxGridDBBandedColumn;
    clExternalId: TcxGridDBBandedColumn;
    clValue: TcxGridDBBandedColumn;
    clParentExternalId: TcxGridDBBandedColumn;
    actRename: TAction;
    actAdd: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    clOrd: TcxGridDBBandedColumn;
    dxBarButton1: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewDragDrop(Sender, Source: TObject;
      X, Y: Integer);
    procedure cxGridDBBandedTableViewDragOver(Sender, Source: TObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxGridDBBandedTableViewStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure dxBarButton1Click(Sender: TObject);
  private
    FDragAndDropInfo: TDragAndDropInfo;
    FHRTimer: THRTimer;
    FqChildCategories: TQueryChildCategories;
    procedure SetqChildCategories(const Value: TQueryChildCategories);
    { Private declarations }
  protected
    procedure OnGridViewNoneHitTest(var AllowPopup: Boolean); override;
    procedure OnGridRecordCellPopupMenu(AColumn: TcxGridDBBandedColumn;
      var AllowPopup: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property qChildCategories: TQueryChildCategories read FqChildCategories
      write SetqChildCategories;
    { Public declarations }
  end;

implementation

uses
  ProjectConst, GridSort;

{$R *.dfm}

constructor TViewChildCategories.Create(AOwner: TComponent);
begin
  inherited;
  FDragAndDropInfo := TDragAndDropInfo.Create(clId, clOrd);

  GridSort.Add(TSortVariant.Create(clOrd, [clOrd]));
  ApplySort(MainView, clOrd);
end;

destructor TViewChildCategories.Destroy;
begin
  FreeAndNil( FDragAndDropInfo );
  inherited;
end;

procedure TViewChildCategories.actAddExecute(Sender: TObject);
var
  AValue: String;
begin
  inherited;
  qChildCategories.W.TryPost;

  AValue := InputBox(sDatabase, sPleaseWrite, '');

  if AValue.IsEmpty then
    Exit;

  qChildCategories.AddCategory(AValue);
end;

procedure TViewChildCategories.actRenameExecute(Sender: TObject);
var
  AValue: string;
begin
  inherited;
  FqChildCategories.W.TryPost;
  if FqChildCategories.FDQuery.RecordCount = 0 then
    Exit;

  AValue := InputBox(sDatabase, sPleaseWrite, FqChildCategories.W.Value.F.AsString);
  if (AValue <> '') and FqChildCategories.CheckPossibility
    (FqChildCategories.W.ParentID.F.AsInteger, AValue) then
  begin
    FqChildCategories.W.TryEdit;
    FqChildCategories.W.Value.F.AsString := AValue;
    FqChildCategories.W.TryPost;
  end;

end;

procedure TViewChildCategories.cxGridDBBandedTableViewDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  t: Double;
begin
  inherited;
  // Таймер должны были запустить
  Assert(FHRTimer <> nil);
  t := FHRTimer.ReadTimer;
  // Таймер больше не нужен
  FreeAndNil(FHRTimer);

  // Если это было случайное перемещение, то ничего не делаем
  if t < DragDropTimeOut then
    Exit;

  DoDragDrop(Sender as TcxGridSite, FDragAndDropInfo, qChildCategories, X, Y);

end;

procedure TViewChildCategories.cxGridDBBandedTableViewDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  DoDragOver(Sender as TcxGridSite, X, Y, Accept);
end;

procedure TViewChildCategories.cxGridDBBandedTableViewStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  inherited;
  DoOnStartDrag(Sender as TcxGridSite, FDragAndDropInfo);

  // Запускаем таймер чтобы рассчитать время переноса записей
  FHRTimer := THRTimer.Create(True);
end;

procedure TViewChildCategories.dxBarButton1Click(Sender: TObject);
begin
  inherited;

  ShowMessage(BoolToStr(qChildCategories.FDQuery.Connection.
    InTransaction, True));

end;

procedure TViewChildCategories.OnGridViewNoneHitTest(var AllowPopup: Boolean);
begin
  actDeleteEx.Enabled := False;
  actRename.Enabled := False;
  actCopyToClipboard.Enabled := False;
end;

procedure TViewChildCategories.OnGridRecordCellPopupMenu
  (AColumn: TcxGridDBBandedColumn; var AllowPopup: Boolean);
begin
  actDeleteEx.Enabled := True;
  actRename.Enabled := True;
  actCopyToClipboard.Enabled := True;
end;

procedure TViewChildCategories.SetqChildCategories
  (const Value: TQueryChildCategories);
begin
  if FqChildCategories = Value then
    Exit;

  FqChildCategories := Value;

  if FqChildCategories <> nil then
  begin
    MainView.DataController.DataSource := qChildCategories.W.DataSource;
  end;
end;

end.
