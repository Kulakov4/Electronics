unit DuplicateCategoryView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
  cxGridDBBandedTableView, cxGrid, DuplicateCategoryQuery, NotifyEvents,
  dxBarExtItems, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxBarBuiltInMenu;

type
  TViewDuplicateCategory = class(TfrmGrid)
    DataSource: TDataSource;
    clID: TcxGridDBBandedColumn;
    clCaption: TcxGridDBBandedColumn;
    actRecordCount: TAction;
    dxBarStatic1: TdxBarStatic;
    procedure actRecordCountExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewCellClick(Sender: TcxCustomGridTableView;
        ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift:
        TShiftState; var AHandled: Boolean);
  private
    FqDuplicateCategory: TQueryDuplicateCategory;
    procedure SetqDuplicateCategory(const Value: TQueryDuplicateCategory);
    { Private declarations }
  protected
    procedure DoAfterSearch(Sender: TObject);
  public
    procedure UpdateView; override;
    property qDuplicateCategory: TQueryDuplicateCategory read FqDuplicateCategory
        write SetqDuplicateCategory;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TViewDuplicateCategory.actRecordCountExecute(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TViewDuplicateCategory.cxGridDBBandedTableViewCellClick(Sender:
    TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
    AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;

  if FqDuplicateCategory = nil then
    Exit;

  qDuplicateCategory.OnDuplicateClick.CallEventHandlers(qDuplicateCategory);
end;

procedure TViewDuplicateCategory.DoAfterSearch(Sender: TObject);
begin
  UpdateView;
end;

procedure TViewDuplicateCategory.SetqDuplicateCategory(const Value:
    TQueryDuplicateCategory);
begin
  if FqDuplicateCategory = Value then
    Exit;

  FqDuplicateCategory := Value;

  if FqDuplicateCategory = nil then
    Exit;

  DataSource.DataSet := qDuplicateCategory;

  TNotifyEventWrap.Create( qDuplicateCategory.AfterSearch, DoAfterSearch, FEventList );
end;

procedure TViewDuplicateCategory.UpdateView;
begin
  if qDuplicateCategory = nil then
    Exit;

  actRecordCount.Caption := Format('Найдено совпадений: %d', [qDuplicateCategory.RecordCount]);
end;

end.
