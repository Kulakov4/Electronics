unit StoreHouseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxPC, cxSplitter,
  cxContainer, cxEdit, cxListBox, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, StorehouseInfoView, cxLabel, Vcl.Menus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Contnrs, StoreHouseListQuery, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, ProductsSearchQuery, GridFrame,  ProductsBaseView,
  ProductsSearchView, dxSkinBlack, dxSkinBlue,  dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,  dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, System.Actions, Vcl.ActnList,
  StoreHouseMasterDetailUnit, ProductsView;

type
  TViewStoreHouse = class(TFrame)
    cxpgcntrlStorehouse: TcxPageControl;
    tsStorehouseInfo: TcxTabSheet;
    tsStorehouseProducts: TcxTabSheet;
    tvStorehouseList: TcxGridDBTableView;
    glStorehouseList: TcxGridLevel;
    CxGridStorehouseList: TcxGrid;
    cxspltrStorehouse: TcxSplitter;
    ViewStoreHouseInfo: TViewStorehouseInfo;
    clStorehouseListTitle: TcxGridDBColumn;
    pmStorehouseList: TPopupMenu;
    mniAddStorehouse: TMenuItem;
    mniDeleteStorehouse: TMenuItem;
    mniRenameStorehouse: TMenuItem;
    tsStorehouseSearch: TcxTabSheet;
    cxstylrpstry1: TcxStyleRepository;
    cxstylSelection: TcxStyle;
    ViewProductsSearch: TViewProductsSearch;
    ActionList: TActionList;
    actAddStorehouse: TAction;
    actRenameStorehouse: TAction;
    actDeleteStorehouse: TAction;
    ViewProducts: TViewProducts;
    procedure actAddStorehouseExecute(Sender: TObject);
    procedure actDeleteStorehouseExecute(Sender: TObject);
    procedure actRenameStorehouseExecute(Sender: TObject);
    procedure cxpgcntrlStorehousePageChanging(Sender: TObject;
      NewPage: TcxTabSheet; var AllowChange: Boolean);
    procedure tsStorehouseProductsShow(Sender: TObject);
    procedure tsStorehouseSearchShow(Sender: TObject);
    procedure tvStorehouseListCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure tvStorehouseListCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    F1: Boolean;
    F2: Boolean;
    FEventList: TObjectList;
    FIsShowSelection: Boolean;
    FStoreHouseMasterDetail: TStoreHouseMasterDetail;
    function GetQueryProductsSearch: TQueryProductsSearch;
    procedure SetQueryProductsSearch(const Value: TQueryProductsSearch);
    procedure SetStoreHouseMasterDetail(const Value: TStoreHouseMasterDetail);
  protected
  public
    property QueryProductsSearch: TQueryProductsSearch
      read GetQueryProductsSearch write SetQueryProductsSearch;
    property StoreHouseMasterDetail: TStoreHouseMasterDetail read
        FStoreHouseMasterDetail write SetStoreHouseMasterDetail;
  end;

implementation

{$R *.dfm}

uses
  NotifyEvents, System.UITypes, DialogUnit, ProjectConst;

procedure TViewStoreHouse.actAddStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  StoreHouseMasterDetail.qStoreHouseList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    StoreHouseMasterDetail.qStoreHouseList.FDQuery.DisableControls;
    try
      StoreHouseMasterDetail.qStoreHouseList.LocateOrAppend(Value);
    finally
      StoreHouseMasterDetail.qStoreHouseList.FDQuery.EnableControls;
    end;
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TViewStoreHouse.actDeleteStorehouseExecute(Sender: TObject);
begin
  StoreHouseMasterDetail.qStoreHouseList.TryPost;
  if StoreHouseMasterDetail.qStoreHouseList.FDQuery.RecordCount > 0 then
  begin
    if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    begin
      StoreHouseMasterDetail.qStoreHouseList.FDQuery.Delete;
    end;
  end;
end;

procedure TViewStoreHouse.actRenameStorehouseExecute(Sender: TObject);
var
  Value: string;

begin
  if tvStorehouseList.Controller.SelectedRecordCount > 0 then
  begin
    StoreHouseMasterDetail.qStoreHouseList.TryPost;
    Value := InputBox(sDatabase, sPleaseWrite, StoreHouseMasterDetail.qStoreHouseList.Title.AsString);
    if (Value <> '') then
    begin
      StoreHouseMasterDetail.qStoreHouseList.TryEdit;
      StoreHouseMasterDetail.qStoreHouseList.Title.AsString := Value;
      StoreHouseMasterDetail.qStoreHouseList.TryPost;
      clStorehouseListTitle.ApplyBestFit();
    end;
  end;
end;

procedure TViewStoreHouse.cxpgcntrlStorehousePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  { ѕри смене вкладки сфокусироватьс€ на гриде списка и затем сбросить фокус.
    Ёто принудительно обновит то, как должен грид отрисовыватьс€ }
  if CxGridStorehouseList.Enabled then
    CxGridStorehouseList.SetFocus;

  FIsShowSelection := NewPage.PageIndex <> 2;
  // не показывать выбор склада на вкладке поиска
  // CxGridStorehouseList.SetFocus;
  CxGridStorehouseList.Enabled := False;
  CxGridStorehouseList.Enabled := true;
  CxGridStorehouseList.Enabled := FIsShowSelection;
  if FIsShowSelection then
    CxGridStorehouseList.SetFocus;
  // CxGridStorehouseList.Enabled := true;
end;

function TViewStoreHouse.GetQueryProductsSearch: TQueryProductsSearch;
begin
  Result := ViewProductsSearch.QueryProductsSearch;
end;

procedure TViewStoreHouse.SetQueryProductsSearch(const Value
  : TQueryProductsSearch);
begin
  ViewProductsSearch.QueryProductsSearch := Value;
end;

procedure TViewStoreHouse.SetStoreHouseMasterDetail(const Value:
    TStoreHouseMasterDetail);
begin
  if FStoreHouseMasterDetail <> Value then
  begin
    FStoreHouseMasterDetail := Value;

    // ѕодписываемс€ на событи€
    if not Assigned(FEventList) then
      FEventList := TObjectList.Create
    else
      FEventList.Clear; // ќтписываемс€ от старых событий

    tvStorehouseList.DataController.DataSource :=
      FStoreHouseMasterDetail.qStoreHouseList.DataSource;

    // ѕрив€зываем дочернее представление к данным
    ViewStoreHouseInfo.QueryStoreHouseList := FStoreHouseMasterDetail.qStoreHouseList;
    ViewProducts.QueryProducts := FStoreHouseMasterDetail.qProducts;

    FIsShowSelection := true;
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TViewStoreHouse.tsStorehouseProductsShow(Sender: TObject);
begin
  if not F1 then
  begin
    ViewProducts.ApplyBestFitEx;
    F1 := true;
  end;
end;

procedure TViewStoreHouse.tsStorehouseSearchShow(Sender: TObject);
begin
  if not F2 then
  begin
    ViewProductsSearch.ApplyBestFitEx();
    F2 := true;
  end;
end;

procedure TViewStoreHouse.tvStorehouseListCellClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  CxGridStorehouseList.Enabled := False;
  CxGridStorehouseList.Enabled := true;
end;

procedure TViewStoreHouse.tvStorehouseListCustomDrawCell
  (Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  // if(AViewInfo.Selected) {and (Screen.ActiveControl = Sender.Site)} then
  if ((AViewInfo.Focused) or (AViewInfo.Selected)) and FIsShowSelection then
  begin
    ACanvas.Brush.Color := clHighlight;
    ACanvas.Font.Color := clWhite;
  end;
end;

end.
