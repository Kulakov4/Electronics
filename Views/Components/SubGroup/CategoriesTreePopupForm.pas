unit CategoriesTreePopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PopupForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL, TreeListQuery,
  cxClasses, dxBar, cxTextEdit, cxBarEditItem, NotifyEvents,
  cxMaskEdit, cxMemo, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxBarPainter,
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
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxDataControllerConditionalFormattingRulesManagerDialog;

const
  WM_AFTER_FORM_SHOW = WM_USER + 1;

type
  TfrmCategoriesTreePopup = class(TfrmPopupForm)
    cxdbtlCaterories: TcxDBTreeList;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    cxBarEditItem: TcxBarEditItem;
    cxdbtlCateroriesId: TcxDBTreeListColumn;
    cxdbtlCateroriesValue: TcxDBTreeListColumn;
    cxdbtlCateroriesParentId: TcxDBTreeListColumn;
    cxdbtlCateroriesExternalId: TcxDBTreeListColumn;
    procedure FormShow(Sender: TObject);
    procedure cxBarEditItemPropertiesChange(Sender: TObject);
    procedure cxBarEditItemPropertiesEditValueChanged(Sender: TObject);
    procedure cxdbtlCateroriesDblClick(Sender: TObject);
  private
    FOnClosePopup: TNotifyEventsEx;
    FQueryTreeList: TQueryTreeList;
    procedure ClearFilter;
    procedure SetQueryTreeList(const Value: TQueryTreeList);
    { Private declarations }
  protected
    procedure DoAfterFormShow(var Message: TMessage);
      message WM_AFTER_FORM_SHOW;
  public
    constructor Create(AOwner: TComponent); override;
    property OnClosePopup: TNotifyEventsEx read FOnClosePopup;
    property QueryTreeList: TQueryTreeList read FQueryTreeList
      write SetQueryTreeList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmCategoriesTreePopup.Create(AOwner: TComponent);
begin
  inherited;
  // Создаём событие
  FOnClosePopup := TNotifyEventsEx.Create(Self);
end;

procedure TfrmCategoriesTreePopup.ClearFilter;
begin
  cxBarEditItem.SetFocus();
  cxBarEditItem.EditValue := '';
  QueryTreeList.W.FilterByExternalID('');
end;

procedure TfrmCategoriesTreePopup.cxBarEditItemPropertiesChange
  (Sender: TObject);
var
  S: string;
begin
  S := VarToStrDef(cxBarEditItem.CurEditValue, '');
  QueryTreeList.W.FilterByExternalID(S);
end;

procedure TfrmCategoriesTreePopup.cxBarEditItemPropertiesEditValueChanged
  (Sender: TObject);
begin
  inherited;
  FOnClosePopup.CallEventHandlers(Self);
  // PopupWindow.CloseUp;
end;

procedure TfrmCategoriesTreePopup.cxdbtlCateroriesDblClick(Sender: TObject);
begin
  FOnClosePopup.CallEventHandlers(Self);
end;

procedure TfrmCategoriesTreePopup.DoAfterFormShow(var Message: TMessage);
begin
  inherited;
  ClearFilter;
end;

procedure TfrmCategoriesTreePopup.FormShow(Sender: TObject);
begin
  PostMessage(Handle, WM_AFTER_FORM_SHOW, 0, 0);
end;

procedure TfrmCategoriesTreePopup.SetQueryTreeList(const Value: TQueryTreeList);
begin
  if FQueryTreeList <> Value then
  begin
    FQueryTreeList := Value;

    if FQueryTreeList <> nil then
    begin
      // Привязываем вью к данным
      cxdbtlCaterories.DataController.DataSource := FQueryTreeList.DataSource;
    end;
  end;
end;

end.
