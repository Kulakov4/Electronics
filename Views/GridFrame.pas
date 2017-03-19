unit GridFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar, ColumnsBarButtonsHelper,
  cxGridBandedTableView, cxGridDBBandedTableView, System.Actions, Vcl.ActnList,
  System.Contnrs, Vcl.ComCtrls, Vcl.Menus, cxGridCustomPopupMenu,
  cxGridPopupMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxDropDownEdit,
  BaseQuery;

const
  WM_MY_APPLY_BEST_FIT = WM_USER + 109;
  WM_AfterKeyOrMouseDown = WM_USER + 55;

type
  TGridProcRef = reference to procedure(AView: TcxGridDBBandedTableView);

  TfrmGrid = class(TFrame)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    dxBarManager: TdxBarManager;
    dxbrMain: TdxBar;
    dxbrsbtmColumnsCustomization: TdxBarSubItem;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    ActionList: TActionList;
    StatusBar: TStatusBar;
    actCopyToClipboard: TAction;
    pmGrid: TPopupMenu;
    N1: TMenuItem;
    cxGridPopupMenu: TcxGridPopupMenu;
    procedure actCopyToClipboardExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGridDBBandedTableViewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridPopupMenuPopup(ASenderMenu: TComponent; AHitTest:
        TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
  private
    function GetMainView: TcxGridDBBandedTableView;
    { Private declarations }
  protected
    FColumnsBarButtons: TColumnsBarButtons;
    FEventList: TObjectList;
    FUpdateCount: Cardinal;
    procedure AfterKeyOrMouseDown(var Message: TMessage);
      message WM_AfterKeyOrMouseDown;
    procedure CreateColumnsBarButtons; virtual;
    procedure CreateFilterForExport(AView,
      ASource: TcxGridDBBandedTableView); virtual;
    procedure DoOnMyApplyBestFit(var Message: TMessage);
      message WM_MY_APPLY_BEST_FIT;
    function GetFocusedTableView: TcxGridDBBandedTableView; virtual;
    procedure InitializeLookupColumn(AView: TcxGridDBBandedTableView;
      AFieldName: string; ADataSource: TDataSource;
      ADropDownListStyle: TcxEditDropDownListStyle;
      const AListFieldNames: string; const AKeyFieldNames: string = 'ID');
    procedure InitializeComboBoxColumn(AView: TcxGridDBBandedTableView;
      AFieldName: string; ADropDownListStyle: TcxEditDropDownListStyle;
      AField: TField);
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ApplyBestFitEx; virtual;
    procedure ApplyBestFitFocusedBand; virtual;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure ExportViewToExcel(AView: TcxGridDBBandedTableView; AFileName: string;
        AGridProcRef: TGridProcRef = nil);
    procedure FocusColumnEditor(ALevel: Integer; AFieldName: string);
    procedure FocusSelectedRecord(AView: TcxGridDBBandedTableView);
    procedure PutInTheCenterFocusedRecord(AView: TcxGridDBBandedTableView);
    function GetDBBandedTableView(ALevel: Cardinal): TcxGridDBBandedTableView;
    function GetRow(ALevel: Cardinal; ARowIndex: Integer = -1)
      : TcxCustomGridRow;
    procedure LocateAndFocus(AMaster, ADetail: TQueryBase; ADetailID: Integer;
        const AMasterKeyFieldName, AFocusedColumnFieldName: string);
    procedure MyApplyBestFit; virtual;
    procedure PostMyApplyBestFitEvent;
    procedure UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
    procedure UpdateView; virtual;
    function GridView(ALevel: TcxGridLevel): TcxGridDBBandedTableView;
    property FocusedTableView: TcxGridDBBandedTableView
      read GetFocusedTableView;
    property MainView: TcxGridDBBandedTableView read GetMainView;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, System.Math, cxDBLookupComboBox, cxGridExportLink;

constructor TfrmGrid.Create(AOwner: TComponent);
begin
  inherited;
  FUpdateCount := 0;
  FEventList := TObjectList.Create;
end;

destructor TfrmGrid.Destroy;
begin
  FreeAndNil(FEventList);
  inherited;
end;

procedure TfrmGrid.actCopyToClipboardExecute(Sender: TObject);
var
  AView: TcxGridDBBandedTableView;
begin
  AView := GetFocusedTableView;
  if AView <> nil then
    AView.CopyToClipboard(False);
end;

procedure TfrmGrid.AfterConstruction;
begin
  inherited;
  CreateColumnsBarButtons;
end;

procedure TfrmGrid.AfterKeyOrMouseDown(var Message: TMessage);
begin
  UpdateView;
end;

procedure TfrmGrid.ApplyBestFitEx;
//var
//  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
//  I: Integer;
begin

  MainView.ApplyBestFit();
{
  for I := 0 to MainView.ColumnCount - 1 do
  begin
    AcxGridDBBandedColumn := MainView.Columns[I];
    AcxGridDBBandedColumn.MinWidth := AcxGridDBBandedColumn.Width;
  end;
}
end;

procedure TfrmGrid.ApplyBestFitFocusedBand;
var
  AColumn: TcxGridDBBandedColumn;
begin
  AColumn := (MainView.Controller.FocusedColumn as TcxGridDBBandedColumn);

  MainView.BeginBestFitUpdate;
  try
    AColumn.Position.Band.ApplyBestFit();
  finally
    MainView.EndBestFitUpdate;
  end;
end;

procedure TfrmGrid.BeginUpdate;
begin
  Inc(FUpdateCount);
  cxGrid.BeginUpdate();
end;

procedure TfrmGrid.CreateColumnsBarButtons;
begin
  if (cxGridDBBandedTableView.ItemCount > 0) and (FColumnsBarButtons = nil)
  then
    FColumnsBarButtons := TColumnsBarButtons.Create(Self,
      dxbrsbtmColumnsCustomization, cxGridDBBandedTableView);
end;

procedure TfrmGrid.CreateFilterForExport(AView,
  ASource: TcxGridDBBandedTableView);
begin
  AView.DataController.Filter.Assign(ASource.DataController.Filter);
end;

procedure TfrmGrid.cxGridDBBandedTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TfrmGrid.cxGridDBBandedTableViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PostMessage(Handle, WM_AfterKeyOrMouseDown, 0, 0);
end;

procedure TfrmGrid.cxGridPopupMenuPopup(ASenderMenu: TComponent; AHitTest:
    TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
var
  AColumn: TcxGridDBBandedColumn;
  AcxGridRecordCellHitTest: TcxGridRecordCellHitTest;
begin
  inherited;
  AColumn := nil;

  if (AHitTest is TcxGridRecordCellHitTest) then
  begin
    AcxGridRecordCellHitTest := (AHitTest as TcxGridRecordCellHitTest);
    if AcxGridRecordCellHitTest.Item is TcxGridDBBandedColumn then
    begin
      AColumn := AcxGridRecordCellHitTest.Item as TcxGridDBBandedColumn;
    end;
  end;

  OnGridPopupMenuPopup(AColumn);
end;

procedure TfrmGrid.DoOnMyApplyBestFit(var Message: TMessage);
begin
  inherited;
  MyApplyBestFit;
  // MainView.EndBestFitUpdate;
end;

procedure TfrmGrid.EndUpdate;
begin
  cxGrid.EndUpdate;
  Dec(FUpdateCount)
end;

procedure TfrmGrid.ExportViewToExcel(AView: TcxGridDBBandedTableView;
    AFileName: string; AGridProcRef: TGridProcRef = nil);
var
  Grid: TcxGrid;
  Level: TcxGridLevel;
  GridView: TcxGridDBBandedTableView;
begin
  Assert(not AFileName.IsEmpty);

  Grid := TcxGrid.Create(Self);
  Level := Grid.Levels.Add;
  GridView := Grid.CreateView(TcxGridDBBandedTableView) as TcxGridDBBandedTableView;
  GridView.DataController.DataSource := AView.DataController.DataSource;
  GridView.Assign(AView);
  GridView.OptionsView.Footer := False; // Футер экспортировать не будем

  // Фильтруем так-же как у образца
  CreateFilterForExport(GridView, AView);

  // Делаем скрытый грид такой-же по размерам как и наш
  Grid.Width := cxGrid.Width;
  Grid.Height := cxGrid.Height;
  // Выставляем тот-же шрифт
  Grid.Font.Assign(Font);

  Level.GridView := GridView;

  if Assigned(AGridProcRef) then
    AGridProcRef(GridView);

  // Экспортируем в Excel
  ExportGridToExcel(AFileName, Grid);

  FreeAndNil(GridView);
  FreeAndNil(Grid);
end;

procedure TfrmGrid.FocusColumnEditor(ALevel: Integer; AFieldName: string);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  try
    AView := GetDBBandedTableView(ALevel);
    AView.Focused := True;

    AColumn := AView.GetColumnByFieldName(AFieldName);
    // Site обеспечивает доступ к элементам размещённым на cxGrid
    AView.Site.SetFocus;
    // Показываем редактор для колонки
    AView.Controller.EditingController.ShowEdit(AColumn);
  except
    ; // Ошибки подавляем. Нельзя передать фокус невидимому окну
  end;
end;

procedure TfrmGrid.FocusSelectedRecord(AView: TcxGridDBBandedTableView);
begin
  if AView.Controller.SelectedRowCount > 0 then
    AView.Controller.SelectedRows[0].Focused := True;
end;

procedure TfrmGrid.PutInTheCenterFocusedRecord(AView: TcxGridDBBandedTableView);
var
  Cnt: Integer;
begin
  if AView.Controller.FocusedRecordIndex >= 0 then
  begin
    Cnt := AView.ViewInfo.RecordsViewInfo.VisibleCount;
    AView.Controller.TopRecordIndex := AView.Controller.FocusedRecordIndex -
      Round((Cnt + 1) / 2);
  end;
end;

function TfrmGrid.GetDBBandedTableView(ALevel: Cardinal)
  : TcxGridDBBandedTableView;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  AcxGridMasterDataRow: TcxGridMasterDataRow;
  I: Integer;
begin
  Result := nil;
  Assert(ALevel < 3);

  case ALevel of
    0:
      Result := cxGrid.Levels[0].GridView as TcxGridDBBandedTableView;
    1, 2:
      begin
        AcxGridDBBandedTableView := GetDBBandedTableView(ALevel - 1);
        if AcxGridDBBandedTableView = nil then
          Exit;

        I := AcxGridDBBandedTableView.DataController.FocusedRowIndex;
        if I < 0 then
          Exit;

        AcxGridMasterDataRow := GetDBBandedTableView(ALevel - 1).ViewData.Rows
          [I] as TcxGridMasterDataRow;
        // Спускаемся на дочерний уровень
        Result := AcxGridMasterDataRow.ActiveDetailGridView as
          TcxGridDBBandedTableView;
      end;
  else
    raise Exception.Create('Уровень должен быть от 0 до 2');
  end;
end;

function TfrmGrid.GetFocusedTableView: TcxGridDBBandedTableView;
begin
  Result := GetDBBandedTableView(0);
  if (Result <> nil) and (not Result.Focused) then
    Result := nil;
  {
    // Если не первый уровень в фокусе
    if (Result = nil) and (cxGrid.Levels.Count > 1) then
    begin
    Result := GetDBBandedTableView(1);
    if (Result <> nil) and (not Result.Focused) then
    Result := nil;
    end;
  }
end;

function TfrmGrid.GetMainView: TcxGridDBBandedTableView;
begin
  Result := cxGridLevel.GridView as TcxGridDBBandedTableView;
end;

function TfrmGrid.GetRow(ALevel: Cardinal; ARowIndex: Integer = -1)
  : TcxCustomGridRow;
var
  AcxGridDBBandedTableView: TcxGridDBBandedTableView;
  I: Integer;
begin
  Result := nil;
  AcxGridDBBandedTableView := GetDBBandedTableView(ALevel);
  I := IfThen(ARowIndex = -1,
    AcxGridDBBandedTableView.DataController.FocusedRowIndex, ARowIndex);
  if I >= 0 then
    Result := AcxGridDBBandedTableView.ViewData.Rows[I];
end;

procedure TfrmGrid.InitializeLookupColumn(AView: TcxGridDBBandedTableView;
  AFieldName: string; ADataSource: TDataSource;
  ADropDownListStyle: TcxEditDropDownListStyle; const AListFieldNames: string;
  const AKeyFieldNames: string = 'ID');
var
  AColumn: TcxGridDBBandedColumn;
  AcxLookupComboBoxProperties: TcxLookupComboBoxProperties;
begin
  Assert(ADataSource <> nil);
  Assert(not AListFieldNames.IsEmpty);
  Assert(not AKeyFieldNames.IsEmpty);
  AColumn := AView.GetColumnByFieldName(AFieldName);

  Assert(AColumn <> nil);
  // Assert(AColumn.Properties <> nil);

  AColumn.PropertiesClass := TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties :=
    AColumn.Properties as TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties.ListSource := ADataSource;
  AcxLookupComboBoxProperties.ListFieldNames := AListFieldNames;
  AcxLookupComboBoxProperties.KeyFieldNames := AKeyFieldNames;
  AcxLookupComboBoxProperties.DropDownListStyle := ADropDownListStyle;
end;

procedure TfrmGrid.InitializeComboBoxColumn(AView: TcxGridDBBandedTableView;
  AFieldName: string; ADropDownListStyle: TcxEditDropDownListStyle;
  AField: TField);
var
  AColumn: TcxGridDBBandedColumn;
  AcxComboBoxProperties: TcxComboBoxProperties;
begin
  AColumn := AView.GetColumnByFieldName(AFieldName);

  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxComboBoxProperties;
  AcxComboBoxProperties := AColumn.Properties as TcxComboBoxProperties;
  AcxComboBoxProperties.DropDownListStyle := ADropDownListStyle;

  // Заполняем выпадающий список значениями из запроса
  AcxComboBoxProperties.Items.Clear;
  AField.DataSet.First;
  while not AField.DataSet.Eof do
  begin
    AcxComboBoxProperties.Items.Add(AField.AsString);
    AField.DataSet.Next;
  end;
end;

procedure TfrmGrid.LocateAndFocus(AMaster, ADetail: TQueryBase; ADetailID:
    Integer; const AMasterKeyFieldName, AFocusedColumnFieldName: string);
var
  AColumn: TcxGridDBBandedColumn;
  //AcxGridMasterDataRow: TcxGridMasterDataRow;
  AView: TcxGridDBBandedTableView;
begin
  Assert(AMaster <> nil);
  Assert(ADetail <> nil);
  Assert(ADetailID > 0);
  Assert(not AMasterKeyFieldName.IsEmpty);
  Assert(not AFocusedColumnFieldName.IsEmpty);

  // Ищем запись в дочернем наборе данных
  if ADetail.LocateByPK(ADetailID) then
  begin
    // Ищем соответсвующую запись в главном наборе данных
    if AMaster.LocateByPK(ADetail.Field(AMasterKeyFieldName).Value) then
    begin
      // Получаем строку в гриде
//      AcxGridMasterDataRow := GetRow(0) as TcxGridMasterDataRow;
      // Раскрываем эту строку
      MainView.ViewData.Expand(True);

      // Получаем дочернее представление
      AView := GetDBBandedTableView(1);
      // Фокусируем его
      AView.Focused := True;
      PutInTheCenterFocusedRecord(AView);

      AColumn := AView.GetColumnByFieldName(AFocusedColumnFieldName);
      // Site обеспечивает доступ к элементам размещённым на cxGrid
      try
        AView.Site.SetFocus;
        // Показываем редактор для колонки
        AView.Controller.EditingController.ShowEdit(AColumn);
      except
        ; // Иногда возникает ошибка
      end;
    end;
  end;

end;

procedure TfrmGrid.MyApplyBestFit;
begin
  MainView.ApplyBestFit(nil, True, True);
end;

procedure TfrmGrid.PostMyApplyBestFitEvent;
begin
  // MainView.BeginBestFitUpdate;
  PostMessage(Handle, WM_MY_APPLY_BEST_FIT, 0, 0);
end;

procedure TfrmGrid.UpdateColumnsMinWidth(AView: TcxGridDBBandedTableView);
var
  AColumn: TcxGridDBBandedColumn;
  I: Integer;
  RealColumnWidth: Integer;
begin
  // изменяем минимальные размеры всех колонок
  for I := 0 to AView.ColumnCount - 1 do
  begin
    AColumn := AView.Columns[I];

    if AColumn.VisibleIndex >= 0 then
    begin
      RealColumnWidth := AView.ViewInfo.HeaderViewInfo.Items
        [AColumn.VisibleIndex].Width;

      if AColumn.MinWidth < RealColumnWidth then
        AColumn.MinWidth := RealColumnWidth;
    end;
  end;
end;

procedure TfrmGrid.UpdateView;
begin
end;

function TfrmGrid.GridView(ALevel: TcxGridLevel): TcxGridDBBandedTableView;
begin
  Assert(ALevel <> nil);
  Result := ALevel.GridView as TcxGridDBBandedTableView;
end;

procedure TfrmGrid.OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn);
begin
end;

end.
