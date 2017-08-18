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
  System.Generics.collections, FieldInfoUnit, ErrorForm,
  ProductsExcelDataModule, ProductGroupUnit, Vcl.Menus, Vcl.ComCtrls,
  System.Contnrs, ProgressBarForm2, ExcelDataModule;

type
  TViewProducts2 = class(TViewProductsBase2)
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
  private
    procedure DoBeforeLoad(ASender: TObject);
    function GetProductGroup: TProductGroup;
    procedure SetProductGroup(const Value: TProductGroup);
    { Private declarations }
  protected
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount; override;
  public
    procedure LoadFromExcelDocument(const AFileName: String);
    property ProductGroup: TProductGroup read GetProductGroup
      write SetProductGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProgressBarForm, ProjectConst, CustomExcelTable,
  NotifyEvents, Data.DB, ProgressInfo, LoadFromExcelFileHelper;

procedure TViewProducts2.DoBeforeLoad(ASender: TObject);
begin
  UpdateView;
  { ��� ������ ������� ������ ��������� ������� ��������� � ������ ������ }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

function TViewProducts2.GetProductGroup: TProductGroup;
begin
  Result := ProductBaseGroup as TProductGroup;
end;

procedure TViewProducts2.LoadFromExcelDocument(const AFileName: String);
begin
  Assert(not AFileName.IsEmpty);

  BeginUpdate;
  try
    TLoad.Create.LoadAndProcess(AFileName, TProductsExcelDM, TfrmError,
    procedure (ASender: TObject)
    begin
      ProductGroup.qProducts.AppendList(ASender as TProductsExcelTable);
    end
    );
  finally
    cxDBTreeList.FullCollapse;
    EndUpdate;
  end;
end;

procedure TViewProducts2.SetProductGroup(const Value: TProductGroup);
begin
  if ProductBaseGroup = Value then
    Exit;

  // ������������ �� �������
  FEventList.Clear;

  ProductBaseGroup := Value;
  if ProductBaseGroup <> nil then
  begin
    TNotifyEventWrap.Create(ProductGroup.qProducts.BeforeLoad, DoBeforeLoad,
      FEventList);
  end;
end;

procedure TViewProducts2.UpdateProductCount;
begin
  inherited;

  // ��������� ���������� ��������� �� ���� �������
  StatusBar.Panels[3].Text := Format('%d', [ProductGroup.qProducts.TotalCount]);
end;

end.
