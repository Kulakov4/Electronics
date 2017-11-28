unit AnalogGridView3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewEx, cxGraphics, cxControls,
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
  System.ImageList, Vcl.ImgList, cxGridCustomPopupMenu, cxGridPopupMenu,
  Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, AnalogQueryes,
  System.Generics.Collections, StrHelper, ParametersForCategoryQuery,
  BandsInfo;

type
  TViewAnalogGrid3 = class(TViewGridEx)
  private
    FAnalogGroup: TAnalogGroup;
    FBandsInfo: TBandsInfo;
    FColumns: TList<TcxGridDBBandedColumn>;
    procedure CreateColumn(AView: TcxGridDBBandedTableView; AIDParameter: Integer;
        const ABandCaption, AColumnCaption, AFieldName: String; AVisible: Boolean;
        const AHint: string; ACategoryParamID, AOrder, APosID: Integer);
    procedure DeleteBands;
    procedure DeleteColumns;
    procedure SetAnalogGroup(const Value: TAnalogGroup);
    { Private declarations }
  protected
    procedure InitColumns; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AnalogGroup: TAnalogGroup read FAnalogGroup write SetAnalogGroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TViewAnalogGrid3.Create(AOwner: TComponent);
begin
  inherited;
  FColumns := TList<TcxGridDBBandedColumn>.Create;
  FBandsInfo := TBandsInfo.Create;
end;

destructor TViewAnalogGrid3.Destroy;
begin
  FreeAndNil(FBandsInfo);
  FreeAndNil(FColumns);
  inherited;
end;

procedure TViewAnalogGrid3.CreateColumn(AView: TcxGridDBBandedTableView;
    AIDParameter: Integer; const ABandCaption, AColumnCaption, AFieldName:
    String; AVisible: Boolean; const AHint: string; ACategoryParamID, AOrder,
    APosID: Integer);
var
  ABand: TcxGridBand;
  ABandInfo: TBandInfo;
  AColumn: TcxGridDBBandedColumn;
  NeedInitialize: Boolean;
begin
  // Поиск среди ранее созданных бэндов
  ABandInfo := FBandsInfo.Search(AView, AIDParameter);

  // Нужна ли инициализация бэнда
  NeedInitialize := (ABandInfo = nil) or
    (ABandInfo.DefaultCreated and not ABandInfo.Band.VisibleForCustomization);

  // Если не нашли подходящий бэнд
  if ABandInfo = nil then
  begin
    // Создаём новый бэнд
    ABand := AView.Bands.Add;
    // Добавляем его в описание
    ABandInfo := TBandInfo.Create(ABand, AIDParameter);
    FBandsInfo.Add(ABandInfo);
  end;
  Assert(ABandInfo <> nil);
  ABand := ABandInfo.Band;

  // Инициализируем бэнд
  if NeedInitialize then
  begin
    ABandInfo.CategoryParamID := ACategoryParamID;
    ABandInfo.DefaultVisible := AVisible;
    ABand.Visible := AVisible;
    ABand.VisibleForCustomization := True;
    ABand.Caption := DeleteDouble(ABandCaption, ' ');
    ABand.AlternateCaption := AHint;
    if ABandInfo.DefaultCreated then
      ABand.Position.ColIndex := 1000; // Помещаем бэнд в конец
    // Какой порядок имеет параметр в БД
    ABandInfo.Order := AOrder;
    ABandInfo.Pos := APosID;
  end;

  // Если такой бэнд не существовал по "умолчанию"
  if not ABandInfo.DefaultCreated then
  begin
    // Создаём колонку для этого бэнда
    AColumn := AView.CreateColumn;
    AColumn.Position.BandIndex := ABand.Index;
    AColumn.MinWidth := 40;
    AColumn.Caption := DeleteDouble(AColumnCaption, ' ');
    AColumn.AlternateCaption := AHint;
    AColumn.DataBinding.FieldName := AFieldName;
    // В режиме просмотра убираем ограничители
//    AColumn.OnGetDataText := DoOnGetDataText;

//    if AView = MainView then
//    begin
//      AColumn.PropertiesClass := TcxMemoProperties;
//      (AColumn.Properties as TcxMemoProperties).WordWrap := False;
//      (AColumn.Properties as TcxMemoProperties).OnEditValueChanged :=
//        DoOnEditValueChanged;
//      AColumn.OnUserFilteringEx := DoOnUserFilteringEx;
//      AColumn.OnGetFilterValues := DoOnGetFilterValues;
//    end
//    else
//    begin
//      AColumn.PropertiesClass := TcxTextEditProperties;
//    end;
    FColumns.Add(AColumn);
  end
end;

procedure TViewAnalogGrid3.DeleteBands;
begin
  // Бэнды, которые не существуют "по умолчанию" удаляем
  FBandsInfo.FreeNotDefaultBands;

  // Бэнды, которые существуют "по умолчанию" прячем
  FBandsInfo.HideDefaultBands;
end;

procedure TViewAnalogGrid3.DeleteColumns;
var
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
begin
  for AcxGridDBBandedColumn in FColumns do
    AcxGridDBBandedColumn.Free;

  FColumns.Clear;

end;

procedure TViewAnalogGrid3.InitColumns;
var
  ABandCaption: string;
  ABandInfo: TBandInfo;
  ACaption: String;
  ACategoryParamID: Integer;
  AHint: String;
  AColumnCaption: string;
  AFieldName: String;
  AIDBand: Integer;
  AOrder: Integer;
  APosID: Integer;
  qParametersForCategory: TQueryParametersForCategory;
  AVisible: Boolean;
begin
  FreeAndNil(FColumnsBarButtons);

  qParametersForCategory := AnalogGroup.qParametersForCategory;

  cxGrid.BeginUpdate();
  try
    // Сначала удаляем ранее добавленные колонки
    DeleteColumns;
    // Потом удаляем ранее добавленные бэнды
    DeleteBands;

    // qParametersForCategory.Load(ComponentsExGroup.qComponentsEx.ParentValue);
    qParametersForCategory.FDQuery.First;
    while not qParametersForCategory.FDQuery.Eof do
    begin
      // Имя поля получаем из словаря всех имён полей параметров
      AFieldName := AnalogGroup.AllParameterFields
        [qParametersForCategory.ParameterID.AsInteger];
      AVisible := qParametersForCategory.IsAttribute.AsBoolean;
      ACaption := qParametersForCategory.Caption.AsString;
      AHint := qParametersForCategory.Hint.AsString;
      ACategoryParamID := qParametersForCategory.IDCategory.AsInteger;
      Assert(not qParametersForCategory.Ord.IsNull);
      AOrder := qParametersForCategory.Ord.AsInteger;
      APosID := qParametersForCategory.PosID.AsInteger;

      // Если это родительский параметр
      if qParametersForCategory.ParentParameter.IsNull then
      begin
        AIDBand := qParametersForCategory.ParameterID.AsInteger;
        ABandCaption := ACaption;
        AColumnCaption := ' ';
      end
      else
      begin
        AIDBand := qParametersForCategory.ParentParameter.AsInteger;
        ABandCaption := qParametersForCategory.ParentCaption.AsString;
        AColumnCaption := ACaption;
      end;

      // Создаём колонку в главном представлении
      CreateColumn(MainView, AIDBand, ABandCaption, AColumnCaption, AFieldName,
        AVisible, AHint, ACategoryParamID, AOrder, APosID);

      // Создаём колонку в дочернем представлении
//      CreateColumn(GridView(cxGridLevel2), AIDBand, ABandCaption,
//        AColumnCaption, AFieldName, AVisible, AHint, ACategoryParamID,
//        AOrder, APosID);

      qParametersForCategory.FDQuery.Next;
    end;

    // запоминаем в какой позиции находится наш бэнд
    for ABandInfo in FBandsInfo do
      ABandInfo.ColIndex := ABandInfo.Band.Position.ColIndex;

    MainView.ViewData.Collapse(True);
  finally
    cxGrid.EndUpdate;
  end;
//  FColumnsBarButtons := TColumnsBarButtonsEx2.Create(Self, dxbsColumns,
//    MainView, cxGridDBBandedTableView2);

  PostMyApplyBestFitEvent;

end;

procedure TViewAnalogGrid3.SetAnalogGroup(const Value: TAnalogGroup);
begin
  if FAnalogGroup = Value then
    Exit;

  FAnalogGroup := Value;

  if FAnalogGroup = nil then
    Exit;

  DataSet := FAnalogGroup.FDMemTable;

end;

end.
