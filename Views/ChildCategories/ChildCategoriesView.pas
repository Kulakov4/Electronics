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
  cxGridDBBandedTableView, cxGrid, ChildCategoriesQuery;

type
  TViewChildCategories = class(TfrmGrid)
    clFunctionalGroupId: TcxGridDBBandedColumn;
    clFunctionalGroupExternalId: TcxGridDBBandedColumn;
    clFunctionalGroupValue: TcxGridDBBandedColumn;
    clFunctionalGroupOrder: TcxGridDBBandedColumn;
    clFunctionalGroupParentExternalId: TcxGridDBBandedColumn;
    actRename: TAction;
    actAdd: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure actAddExecute(Sender: TObject);
    procedure actRenameExecute(Sender: TObject);
  private
    FqChildCategories: TQueryChildCategories;
    procedure SetqChildCategories(const Value: TQueryChildCategories);
    { Private declarations }
  public
    property qChildCategories: TQueryChildCategories read FqChildCategories
      write SetqChildCategories;
    { Public declarations }
  end;

implementation

uses
  ProjectConst;

{$R *.dfm}

procedure TViewChildCategories.actAddExecute(Sender: TObject);
var
  AValue: String;
begin
  inherited;
  qChildCategories.TryPost;

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
  FqChildCategories.TryPost;
  if FqChildCategories.FDQuery.RecordCount = 0 then
    Exit;

  AValue := InputBox(sDatabase, sPleaseWrite, FqChildCategories.Value.AsString);
  if (AValue <> '') and FqChildCategories.CheckPossibility
    (FqChildCategories.ParentID.AsInteger, AValue) then
  begin
    FqChildCategories.TryEdit;
    FqChildCategories.Value.AsString := AValue;
    FqChildCategories.TryPost;
  end;

end;

procedure TViewChildCategories.SetqChildCategories
  (const Value: TQueryChildCategories);
begin
  if FqChildCategories = Value then
    Exit;

  FqChildCategories := Value;

  if FqChildCategories <> nil then
  begin
    MainView.DataController.DataSource := qChildCategories.DataSource;
  end;
end;

end.
