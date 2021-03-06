unit GridViewEx;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridView, cxGraphics, cxControls,
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
  cxGridDBBandedTableView, cxGrid, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls,
  NotifyEvents, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxBarBuiltInMenu, cxImageList, dxDateRanges, DSWrap;

const
  WM_ON_UPDATE_DATA = WM_USER + 125;

type
  TViewGridEx = class(TViewGrid)
    DataSource: TDataSource;
    cxImageList1: TcxImageList;
    UpdateDataTimer: TTimer;
    procedure DataSourceUpdateData(Sender: TObject);
    procedure UpdateDataTimerTimer(Sender: TObject);
  private
    FApplyBestFitOnUpdateData: Boolean;
    // TODO: FOnAssignDataSet
    /// / TODO: FDataSet
    /// /  FDataSet: TDataSet;
    FOnAssignDataSet: TNotifyEventsEx;
    FOnUpdateDataPost: Boolean;
    // TODO: SetDataSet
    // procedure SetDataSet(const Value: TDataSet);
    { Private declarations }
  protected
    // TODO: AssignDataSet
    // procedure AssignDataSet; virtual;
    procedure DoOnUpdateData(var Message: TMessage); message WM_ON_UPDATE_DATA;
    procedure SetDSWrap(const Value: TDSWrap); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateStatusBar;
    procedure UpdateView; override;
    property ApplyBestFitOnUpdateData: Boolean read FApplyBestFitOnUpdateData
      write FApplyBestFitOnUpdateData;
    // TODO: OnAssignDataSet
    /// / TODO: DataSet
    /// /  property DataSet: TDataSet read FDataSet write SetDataSet;
    property OnAssignDataSet: TNotifyEventsEx read FOnAssignDataSet;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TViewGridEx.Create(AOwner: TComponent);
begin
  inherited;
  FOnAssignDataSet := TNotifyEventsEx.Create(Self);
  UpdateView;
end;

destructor TViewGridEx.Destroy;
begin
  FreeAndNil(FOnAssignDataSet);
  inherited;
end;

// TODO: AssignDataSet
// procedure TViewGridEx.AssignDataSet;
// begin
// inherited;
// DataSource.DataSet := FDataSet;
/// / ���������� ������������� � ������
// MainView.DataController.DataSource := DataSource;
// InitColumns;
// MyCreateColumnsBarButtons;
//
// MyApplyBestFit;
// UpdateStatusBar;
// UpdateView;
// end;

procedure TViewGridEx.DataSourceUpdateData(Sender: TObject);
begin
  inherited;
  if (not FApplyBestFitOnUpdateData) or FOnUpdateDataPost then
    Exit;

  UpdateDataTimer.Enabled := True;
  FOnUpdateDataPost := True;
end;

procedure TViewGridEx.DoOnUpdateData(var Message: TMessage);
begin
  inherited;
  MyApplyBestFit;
  FOnUpdateDataPost := False;
end;

procedure TViewGridEx.SetDSWrap(const Value: TDSWrap);
begin
  if DSWrap = Value then
    Exit;

  if (DSWrap <> nil) and (Assigned(DSWrap.DataSource.OnUpdateData)) then
    DSWrap.DataSource.OnUpdateData := nil;

  inherited;

  if (DSWrap <> nil) and (not Assigned(DSWrap.DataSource.OnUpdateData)) then
    DSWrap.DataSource.OnUpdateData := DataSourceUpdateData;

  FOnAssignDataSet.CallEventHandlers(Self);
end;

// TODO: SetDataSet
// procedure TViewGridEx.SetDataSet(const Value: TDataSet);
// begin
// if FDataSet = Value then
// Exit;
//
// FDataSet := Value;
// if FDataSet <> nil then
// begin
// AssignDataSet;
// end
// else
// begin
// DataSource.DataSet := nil;
// end;
// FOnAssignDataSet.CallEventHandlers(Self);
// end;

procedure TViewGridEx.UpdateDataTimerTimer(Sender: TObject);
begin
  inherited;
  UpdateDataTimer.Enabled := False;
  PostMessage(Handle, WM_ON_UPDATE_DATA, 0, 0);
end;

procedure TViewGridEx.UpdateStatusBar;
begin
  if (DSWrap <> nil) and (DSWrap.DataSet.Active) then
    StatusBar.Panels[0].Text := Format('����� �������: %d',
      [DSWrap.DataSet.RecordCount]);
end;

procedure TViewGridEx.UpdateView;
begin
  actExportToExcel.Enabled := (DSWrap <> nil) and
    (DSWrap.DataSet.RecordCount > 0);
end;

end.
