unit ProductsSearchView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView2, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxButtonEdit, cxTLdxBarBuiltInMenu,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, cxCalc, System.Actions, Vcl.ActnList,
  cxBarEditItem, dxBar, cxClasses, cxInplaceContainer, cxDBTL, cxTLData,
  Vcl.Menus, Vcl.ComCtrls, cxDropDownEdit,
  ProductsSearchQuery;

type
  TViewProductsSearch2 = class(TViewProductsBase2)
    actPasteFromBuffer: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actClear: TAction;
    actSearch: TAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    clStorehouseId: TcxDBTreeListColumn;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    procedure actClearExecute(Sender: TObject);
    procedure actPasteFromBufferExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
  private
    function GetqProductsSearch: TQueryProductsSearch;
    procedure Search(ALike: Boolean);
    procedure SetqProductsSearch(const Value: TQueryProductsSearch);
    { Private declarations }
  protected
    procedure InitializeColumns; override;
  public
    procedure FocusValueColumn;
    procedure UpdateView; override;
    property qProductsSearch: TQueryProductsSearch read GetqProductsSearch write
        SetqProductsSearch;
    { Public declarations }
  end;

implementation

uses ClipboardUnit, SearchInterfaceUnit;

{$R *.dfm}

procedure TViewProductsSearch2.actClearExecute(Sender: TObject);
begin
  inherited;
  if CheckAndSaveChanges <> IDCANCEL then
  begin
    cxDBTreeList.BeginUpdate;
    try
      qProductsSearch.ClearSearchResult;
      UpdateView;
    finally
      cxDBTreeList.EndUpdate;
    end;
    FocusValueColumn;
  end;
end;

procedure TViewProductsSearch2.actPasteFromBufferExecute(Sender: TObject);
begin
  inherited;
  cxDBTreeList.BeginUpdate;
  try
    qProductsSearch.AppendRows
      (qProductsSearch.Value.FieldName,
      TClb.Create.GetRowsAsArray);
    UpdateView;

  finally
    cxDBTreeList.EndUpdate;
  end;
end;

procedure TViewProductsSearch2.actSearchExecute(Sender: TObject);
begin
  inherited;
  Search(False);
end;

procedure TViewProductsSearch2.cxDBTreeListEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  if qProductsSearch.Mode = SearchMode then
  begin
    if cxDBTreeList.LockUpdate > 0 then
      Exit;

    // ≈сли закончили редактирование наименовани€
    if (AColumn as TcxDBTreeListColumn).DataBinding.FieldName = clValue.
      DataBinding.FieldName then
    begin
      Search(True);
    end;
  end
  else
    inherited;

end;

procedure TViewProductsSearch2.FocusValueColumn;
begin
  cxDBTreeList.SetFocus;

  // ѕереводим колонку в режим редактировани€
  clValue.Editing := True;
end;

function TViewProductsSearch2.GetqProductsSearch: TQueryProductsSearch;
begin
  Result := qProductsBase as TQueryProductsSearch;
end;

procedure TViewProductsSearch2.InitializeColumns;
begin
  inherited;

  Assert(qProductsSearch <> nil);

  InitializeLookupColumn(clStorehouseId,
    qProductsSearch.qStoreHouseList.DataSource, lsEditFixedList,
    qProductsSearch.qStoreHouseList.Abbreviation.FieldName);
end;

procedure TViewProductsSearch2.Search(ALike: Boolean);
begin
  cxDBTreeList.BeginUpdate;
  try
    CheckAndSaveChanges;

    qProductsSearch.DoSearch(ALike);
    UpdateView;
  finally
    cxDBTreeList.EndUpdate;
  end;
  cxDBTreeList.ApplyBestFit;
  // cxDBTreeList.FullExpand;

  cxDBTreeList.SetFocus;
  // ѕереводим колонку в режим редактировани€
  clValue.Editing := True;
end;

procedure TViewProductsSearch2.SetqProductsSearch(const Value:
    TQueryProductsSearch);
begin
  if qProductsBase <> Value then
    qProductsBase := Value;
end;

procedure TViewProductsSearch2.UpdateView;
var
  Ok: Boolean;
begin
  inherited;
  Ok := (qProductsSearch <> nil) and
    (qProductsSearch.FDQuery.Active);

  actClear.Enabled := qProductsSearch.IsClearEnabled;

  actSearch.Enabled := qProductsSearch.IsSearchEnabled;

  actCommit.Enabled := Ok and qProductsSearch.HaveAnyChanges and
    (qProductsSearch.Mode = RecordsMode);

  actRollback.Enabled := actCommit.Enabled;

  actPasteFromBuffer.Enabled := qProductsSearch.Mode =
    SearchMode;


//  cxGridDBBandedTableView.OptionsData.Appending :=
//    qProductsSearch.qProductsSearch.Mode = SearchMode;

//  cxGridDBBandedTableView.OptionsData.Inserting :=
//    qProductsSearch.qProductsSearch.Mode = SearchMode;

  actExportToExcelDocument.Enabled := Ok and
    (cxDBTreeList.DataController.RecordCount > 0) and
    (qProductsSearch.Mode = RecordsMode);
end;

end.
