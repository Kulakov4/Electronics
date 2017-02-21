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
  dxSkinscxPCPainter, ProductsSearchQuery, GridFrame, ProductsBaseView,
  ProductsSearchView, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  StoreHouseGroupUnit, ProductsView;

type
  TViewStoreHouse = class(TFrame)
    cxpgcntrlStorehouse: TcxPageControl;
    tsStorehouseInfo: TcxTabSheet;
    tsStorehouseProducts: TcxTabSheet;
    tvStorehouseList: TcxGridDBTableView;
    glStorehouseList: TcxGridLevel;
    CxGridStorehouseList: TcxGrid;
    cxspltrStorehouse: TcxSplitter;
    clStorehouseListTitle: TcxGridDBColumn;
    pmStorehouseList: TPopupMenu;
    mniAddStorehouse: TMenuItem;
    mniDeleteStorehouse: TMenuItem;
    mniRenameStorehouse: TMenuItem;
    tsStorehouseSearch: TcxTabSheet;
    cxstylrpstry1: TcxStyleRepository;
    cxstylSelection: TcxStyle;
    ActionList: TActionList;
    actAddStorehouse: TAction;
    actRenameStorehouse: TAction;
    actDeleteStorehouse: TAction;
    ViewStorehouseInfo: TViewStorehouseInfo;
    ViewProducts: TViewProducts;
    ViewProductsSearch: TViewProductsSearch;
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
    FStoreHouseGroup: TStoreHouseGroup;
    function GetQueryProductsSearch: TQueryProductsSearch;
    procedure SetQueryProductsSearch(const Value: TQueryProductsSearch);
    procedure SetStoreHouseGroup(const Value: TStoreHouseGroup);
  protected
  public
    procedure LoadFromExcelDocument;
    property QueryProductsSearch: TQueryProductsSearch
      read GetQueryProductsSearch write SetQueryProductsSearch;
    property StoreHouseGroup: TStoreHouseGroup read FStoreHouseGroup
      write SetStoreHouseGroup;
  end;

implementation

{$R *.dfm}

uses
  NotifyEvents, System.UITypes, DialogUnit, ProjectConst, FieldInfoUnit,
  System.Generics.Collections, DialogUnit2, System.IOUtils;

procedure TViewStoreHouse.actAddStorehouseExecute(Sender: TObject);
var
  Value: string;
begin
  StoreHouseGroup.qStoreHouseList.TryPost;

  Value := InputBox(sDatabase, sPleaseWrite, '');
  if Value <> '' then
  begin
    StoreHouseGroup.qStoreHouseList.FDQuery.DisableControls;
    try
      StoreHouseGroup.qStoreHouseList.LocateOrAppend(Value);
    finally
      StoreHouseGroup.qStoreHouseList.FDQuery.EnableControls;
    end;
    clStorehouseListTitle.ApplyBestFit();
  end;
end;

procedure TViewStoreHouse.actDeleteStorehouseExecute(Sender: TObject);
begin
  StoreHouseGroup.qStoreHouseList.TryPost;
  if StoreHouseGroup.qStoreHouseList.FDQuery.RecordCount > 0 then
  begin
    if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDelete) then
    begin
      StoreHouseGroup.qStoreHouseList.FDQuery.Delete;
    end;
  end;
end;

procedure TViewStoreHouse.actRenameStorehouseExecute(Sender: TObject);
var
  Value: string;

begin
  if tvStorehouseList.Controller.SelectedRecordCount > 0 then
  begin
    StoreHouseGroup.qStoreHouseList.TryPost;
    Value := InputBox(sDatabase, sPleaseWrite,
      StoreHouseGroup.qStoreHouseList.Title.AsString);
    if (Value <> '') then
    begin
      StoreHouseGroup.qStoreHouseList.TryEdit;
      StoreHouseGroup.qStoreHouseList.Title.AsString := Value;
      StoreHouseGroup.qStoreHouseList.TryPost;
      clStorehouseListTitle.ApplyBestFit();
    end;
  end;
end;

procedure TViewStoreHouse.cxpgcntrlStorehousePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  { При смене вкладки сфокусироваться на гриде списка и затем сбросить фокус.
    Это принудительно обновит то, как должен грид отрисовываться }
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

procedure TViewStoreHouse.LoadFromExcelDocument;
var
  AFileName: String;
  m: TArray<String>;
  S: string;
begin
  // Открываем диалог выбора excel файла из последнего места
  if not TOpenExcelDialog.SelectInLastFolder(AFileName) then
    Exit;

  S := TPath.GetFileNameWithoutExtension(AFileName);

  m := S.Split([' ']);
  if Length(m) <= 1 then
    TDialog.Create.ErrorMessageDialog('Имя файла не содержит пробел');

  // Всё что до пробела - сокращённое название склада
  S := m[0];

  // Ищем склад с таким сокращением
  if StoreHouseGroup.qStoreHouseList.LocateByAbbreviation(S) then
    ViewProducts.LoadFromExcelDocument(AFileName)
  else
    TDialog.Create.ErrorMessageDialog
      (Format('Склад с сокращённым названием "%s" не найден', [S]));

end;

procedure TViewStoreHouse.SetQueryProductsSearch(const Value
  : TQueryProductsSearch);
begin
  ViewProductsSearch.QueryProductsSearch := Value;
end;

procedure TViewStoreHouse.SetStoreHouseGroup(const Value: TStoreHouseGroup);
begin
  if FStoreHouseGroup <> Value then
  begin
    FStoreHouseGroup := Value;

    // Подписываемся на события
    if not Assigned(FEventList) then
      FEventList := TObjectList.Create
    else
      FEventList.Clear; // Отписываемся от старых событий

    tvStorehouseList.DataController.DataSource :=
      FStoreHouseGroup.qStoreHouseList.DataSource;

    // Привязываем дочернее представление к данным
    ViewStorehouseInfo.QueryStoreHouseList := FStoreHouseGroup.qStoreHouseList;
    ViewProducts.QueryProducts := FStoreHouseGroup.qProducts;

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
