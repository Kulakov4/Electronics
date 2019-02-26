unit StoreHouseListView;

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
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB,
  cxDBData, dxBarBuiltInMenu, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, StoreHouseListQuery;

type
  TViewStoreHouse = class(TfrmGrid)
    actAddStorehouse: TAction;
    actRenameStorehouse: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure actAddStorehouseExecute(Sender: TObject);
    procedure actRenameStorehouseExecute(Sender: TObject);
  private
    FqStoreHouseList: TQueryStoreHouseList;
    function GetclAbbreviation: TcxGridDBBandedColumn;
    function GetclTitle: TcxGridDBBandedColumn;
    function GetW: TStoreHouseListW;
    procedure SetqStoreHouseList(const Value: TQueryStoreHouseList);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateView; override;
    property clAbbreviation: TcxGridDBBandedColumn read GetclAbbreviation;
    property clTitle: TcxGridDBBandedColumn read GetclTitle;
    property qStoreHouseList: TQueryStoreHouseList read FqStoreHouseList
      write SetqStoreHouseList;
    property W: TStoreHouseListW read GetW;
    { Public declarations }
  end;

implementation

uses
  ProjectConst;

{$R *.dfm}

constructor TViewStoreHouse.Create(AOwner: TComponent);
begin
  inherited;
  DeleteMessages.Add(cxGridLevel, '������� �����?');
end;

procedure TViewStoreHouse.actAddStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  qStoreHouseList.W.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    qStoreHouseList.W.LocateOrAppend(Value);
    MainView.ApplyBestFit();
  end;
end;

procedure TViewStoreHouse.actRenameStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  W.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, W.Title.F.AsString);

  if (Value.IsEmpty) or (Value = W.Title.F.AsString) then
    Exit;

  W.TryEdit;
  W.Title.F.AsString := Value;
  W.TryPost;
  MainView.ApplyBestFit();
end;

function TViewStoreHouse.GetclAbbreviation: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Abbreviation.FieldName);
end;

function TViewStoreHouse.GetclTitle: TcxGridDBBandedColumn;
begin
  Result := MainView.GetColumnByFieldName(W.Title.FieldName);
end;

function TViewStoreHouse.GetW: TStoreHouseListW;
begin
  Result := FqStoreHouseList.W;
end;

procedure TViewStoreHouse.SetqStoreHouseList(const Value: TQueryStoreHouseList);
begin
  if FqStoreHouseList = Value then
    Exit;

  FEventList.Clear;
  FqStoreHouseList := Value;

  if FqStoreHouseList = nil then
    Exit;

  MainView.DataController.DataSource := FqStoreHouseList.W.DataSource;
  MainView.DataController.CreateAllItems(True);
  clAbbreviation.Visible := False;
  MainView.ApplyBestFit;
end;

procedure TViewStoreHouse.UpdateView;
var
  OK: Boolean;
begin
  OK := (qStoreHouseList <> nil) and (qStoreHouseList.FDQuery.Active);

  actAddStorehouse.Enabled := OK;
  actDeleteEx.Enabled := OK and (MainView.Controller.SelectedRowCount > 0);
  actRenameStorehouse.Enabled := OK and
    (MainView.Controller.SelectedRowCount = 1);
end;

end.
