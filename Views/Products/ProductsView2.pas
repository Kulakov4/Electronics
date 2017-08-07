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
  ProductsExcelDataModule, ProductGroupUnit, Vcl.Menus;

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
    function GetProductGroup: TProductGroup;
    procedure SetProductGroup(const Value: TProductGroup);
    { Private declarations }
  public
    procedure LoadFromExcelDocument(const AFileName: String);
    property ProductGroup: TProductGroup read GetProductGroup
      write SetProductGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProgressBarForm, ProjectConst, CustomExcelTable;

function TViewProducts2.GetProductGroup: TProductGroup;
begin
  Result := ProductBaseGroup as TProductGroup;
end;

procedure TViewProducts2.LoadFromExcelDocument(const AFileName: String);
var
  // AFieldsInfo: TList<TFieldInfo>;
  AfrmError: TfrmError;
  AProductsExcelDM: TProductsExcelDM;
  OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  // AFieldsInfo := TList<TFieldInfo>.Create();
  cxDBTreeList.BeginUpdate;
  try

    AProductsExcelDM := TProductsExcelDM.Create(Self);
    try
      // Загружаем данные из Excel файла
      TfrmProgressBar.Process(AProductsExcelDM,
        procedure
        begin
          AProductsExcelDM.LoadExcelFile(AFileName);
        end, 'Загрузка складских данных', sRows);

      OK := AProductsExcelDM.ExcelTable.Errors.RecordCount = 0;
      // Если в ходе загрузки данных произошли ошибки (производитель не найден)
      if not OK then
      begin
        AfrmError := TfrmError.Create(Self);
        try
          AfrmError.ErrorTable := AProductsExcelDM.ExcelTable.Errors;
          // Показываем ошибки
          OK := AfrmError.ShowModal = mrOk;
          AProductsExcelDM.ExcelTable.ExcludeErrors(etError);
        finally
          FreeAndNil(AfrmError);
        end;
      end;
      if OK then
      begin
        // Сохраняем данные в БД
        TfrmProgressBar.Process(AProductsExcelDM.ExcelTable,
          procedure
          begin
            ProductGroup.qProducts.AppendList(AProductsExcelDM.ExcelTable);
          end, 'Сохранение складских данных в БД', sRecords);
      end;

    finally
      FreeAndNil(AProductsExcelDM);
    end;
  finally
    cxDBTreeList.FullCollapse;
    cxDBTreeList.EndUpdate;
    // FreeAndNil(AFieldsInfo);
  end;

end;

procedure TViewProducts2.SetProductGroup(const Value: TProductGroup);
begin
  if ProductBaseGroup <> Value then
    ProductBaseGroup := Value;
end;

end.
