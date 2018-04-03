unit ProductsView2;

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
  System.Generics.collections, FieldInfoUnit, ProductsExcelDataModule,
  Vcl.Menus, Vcl.ComCtrls, System.Contnrs, ProgressBarForm2, ExcelDataModule,
  cxDropDownEdit, ProductsQuery, cxTextEdit;

type
  TViewProducts2 = class(TViewProductsBase2)
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    procedure dxbeDollarChange(Sender: TObject);
    procedure dxbeDollarCurChange(Sender: TObject);
    procedure cxBarEditItem1PropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
  private
    procedure DoBeforeLoad(ASender: TObject);
    function GetqProducts: TQueryProducts;
    procedure SetqProducts(const Value: TQueryProducts);
    { Private declarations }
  protected
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount; override;
  public
    procedure LoadFromExcelDocument(const AFileName: String);
    property qProducts: TQueryProducts read GetqProducts write SetqProducts;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProgressBarForm, ProjectConst, CustomExcelTable,
  NotifyEvents, Data.DB, ProgressInfo, LoadFromExcelFileHelper,
  CustomErrorForm, HttpUnit;

procedure TViewProducts2.cxBarEditItem1PropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  x: Double;
begin
  inherited;
  x := StrToFloatDef( DisplayValue, 0 );
  if x > 0 then Exit;

  ErrorText := 'Редактируемое значение не является курсом валюты';
  Error := True;
end;

procedure TViewProducts2.DoBeforeLoad(ASender: TObject);
begin
  UpdateView;
  { при выборе другого склада проверить наличие изменений в старом складе }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

procedure TViewProducts2.dxbeDollarChange(Sender: TObject);
begin
  inherited;
  ;
end;

procedure TViewProducts2.dxbeDollarCurChange(Sender: TObject);
begin
  inherited;
  ;
end;

function TViewProducts2.GetqProducts: TQueryProducts;
begin
  Result := qProductsBase as TQueryProducts;
end;

procedure TViewProducts2.LoadFromExcelDocument(const AFileName: String);
begin
  Assert(not AFileName.IsEmpty);

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProductsExcelDM, TfrmCustomError,
    procedure (ASender: TObject)
    begin
      qProducts.LoadDataFromExcelTable(ASender as TProductsExcelTable);
    end
    );
  finally
    cxDBTreeList.FullCollapse;
    EndUpdate;
  end;
end;

procedure TViewProducts2.SetqProducts(const Value: TQueryProducts);
begin
  if qProductsBase = Value then
    Exit;

  // Отписываемся от событий
  FEventList.Clear;

  qProductsBase := Value;
  if qProductsBase <> nil then
  begin
    TNotifyEventWrap.Create(qProducts.BeforeLoad, DoBeforeLoad, FEventList);
  end;
end;

procedure TViewProducts2.UpdateProductCount;
begin
  inherited;

  // обновляем количество продуктов на всех складах
  StatusBar.Panels[3].Text := Format('%d', [qProducts.TotalCount]);
end;

end.
