unit ProductsView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxTextEdit, cxBlobEdit,
  cxButtonEdit, cxSpinEdit, cxCurrencyEdit, dxSkinsdxBarPainter,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridCustomView, cxGrid, ProductsQuery,
  cxDBLookupComboBox;

type
  TViewProducts2 = class(TViewProductsBase)
    actAdd: TAction;
    actDelete: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    actPasteFromBuffer: TAction;
    actLoadFromExcel: TAction;
    actLoadFromExcelSheet: TAction;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    procedure actAddExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actLoadFromExcelExecute(Sender: TObject);
    procedure actLoadFromExcelSheetExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged(Sender:
        TcxCustomGridTableView);
    procedure StatusBarResize(Sender: TObject);
  private
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterLoad(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPost(Sender: TObject);
    procedure DoBeforeLoad(Sender: TObject);
    function GetQueryProducts: TQueryProducts;
    procedure SetQueryProducts(const Value: TQueryProducts);
    procedure UpdateProductCount;
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
  public
    property QueryProducts: TQueryProducts read GetQueryProducts write
        SetQueryProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DialogUnit, NotifyEvents, ProjectConst, RepositoryDataModule,
  System.Math, ClipboardUnit;

procedure TViewProducts2.actAddExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName( QueryProducts.Value.FieldName );
  // Site обеспечивает доступ к элементам размещённым на cxGrid
  AView.Site.SetFocus;
  // Показываем редактор для колонки
  AView.Controller.EditingController.ShowEdit(AColumn);

  UpdateView;
end;

procedure TViewProducts2.actDeleteExecute(Sender: TObject);
var
  AFocusedView: TcxGridDBBandedTableView;
begin

  if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDeleteProducts) then
  begin
    AFocusedView := FocusedTableView;
    if AFocusedView <> nil then
    begin

      BeginUpdate;
      try
        AFocusedView.Controller.DeleteSelection;
      finally
        EndUpdate
      end;

      UpdateView;
    end;
  end;

end;

procedure TViewProducts2.actLoadFromExcelExecute(Sender: TObject);
begin
  // Это надо переделать
  inherited;
end;

procedure TViewProducts2.actLoadFromExcelSheetExecute(Sender: TObject);
begin
  // Надо переделать
  inherited;
end;

procedure TViewProducts2.actPasteFromBufferExecute(Sender: TObject);
var
  ARows: TStringList;
begin
  Assert(QueryProducts <> nil);
  ARows := TClb.Create.GetRows;

  cxGridDBBandedTableView.BeginUpdate();
  try
    QueryProducts.AddStringList(ARows);
  finally
    cxGridDBBandedTableView.EndUpdate;
  end;

end;

procedure TViewProducts2.cxGridDBBandedTableViewSelectionChanged(Sender:
    TcxCustomGridTableView);
begin
  inherited;
  UpdateSelectedCount;
end;

procedure TViewProducts2.DoAfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts2.DoAfterLoad(Sender: TObject);
begin
  ApplyBestFitEx;
end;

procedure TViewProducts2.DoAfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProducts2.DoAfterPost(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts2.DoBeforeLoad(Sender: TObject);
begin
  UpdateView;
  { при выборе другого склада проверить наличие изменений в старом складе }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

function TViewProducts2.GetQueryProducts: TQueryProducts;
begin
  Result := QueryProductsBase as TQueryProducts;
end;

procedure TViewProducts2.SetQueryProducts(const Value: TQueryProducts);
begin
  if QueryProductsBase <> Value then
  begin
    QueryProductsBase := Value;

    FEventList.Clear;

    if QueryProducts <> nil then
    begin
      Assert(QueryProductsBase.QueryStoreHouseList <> nil);
      // Инициализируем Lookup колонки
      InitializeLookupColumn(MainView, 'StorehouseId',
        QueryProductsBase.QueryStoreHouseList.DataSource);


      // Подписываемся на события
      TNotifyEventWrap.Create(QueryProducts.Master.BeforeScrollI, DoBeforeLoad,
        FEventList);

      // Подписываемся на события
      TNotifyEventWrap.Create(QueryProducts.AfterLoad, DoAfterLoad, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterOpen, DoAfterOpen,
        FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterPost, DoAfterPost,
        FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterDelete,
        DoAfterDelete, FEventList);
    end;

    UpdateView;
  end;
end;

procedure TViewProducts2.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 2;
var
  I: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    if I <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[I].Width);
    end;
  end;
  x := IfThen(x >= 0, x, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := x;
end;

procedure TViewProducts2.UpdateProductCount;
begin
  // На выбранном складе
  StatusBar.Panels[0].Text :=
    Format('%d', [QueryProducts.FDQuery.RecordCount]);

  // На всех складах
  StatusBar.Panels[3].Text := Format('Всего: %d',
    [QueryProducts.TotalCount]);
end;

procedure TViewProducts2.UpdateSelectedCount;
begin
  StatusBar.Panels[1].Text :=
    Format('%d', [cxGridDBBandedTableView.DataController.GetSelectedCount]);
end;

end.
