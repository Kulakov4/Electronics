unit BillContentView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView0, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, cxCalendar,
  cxCurrencyEdit, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar,
  cxBarEditItem, cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData,
  BillContentQry, ProductsBaseQuery0, BillContentViewModel;

type
  TViewBillContent2 = class(TViewProductsBase0)
    procedure cxDBTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
  private
    procedure DoAfterLoad(Sender: TObject);
    function GetBillContentModel: TBillContentViewModel;
    procedure SetBillContentModel(const Value: TBillContentViewModel);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase0; override;
    function GetW: TBaseProductsW; override;
    procedure InitializeColumns; override;
  public
    property BillContentModel: TBillContentViewModel read GetBillContentModel
      write SetBillContentModel;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

{$R *.dfm}

function TViewBillContent2.CreateProductView: TViewProductsBase0;
begin
  Result := TViewBillContent2.Create(nil);
end;

procedure TViewBillContent2.cxDBTreeListEditing(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  inherited;
  Allow := False;
end;

procedure TViewBillContent2.DoAfterLoad(Sender: TObject);
begin
  MyApplyBestFit;
end;

function TViewBillContent2.GetBillContentModel: TBillContentViewModel;
begin
  Result := M as TBillContentViewModel;
end;

function TViewBillContent2.GetW: TBaseProductsW;
begin
  Result := BillContentModel.qBillContent.W;
end;

procedure TViewBillContent2.InitializeColumns;
begin
  inherited;

  Assert(M <> nil);

  InitializeLookupColumn(clStorehouseId,
    BillContentModel.qStoreHouseList.W.DataSource, lsEditFixedList,
    BillContentModel.qStoreHouseList.W.Abbreviation.FieldName);
end;

procedure TViewBillContent2.SetBillContentModel(const Value
  : TBillContentViewModel);
begin
  M := Value;

  if Value <> nil then
    TNotifyEventWrap.Create(Value.qBillContent.AfterLoad, DoAfterLoad,
      FEventList);
end;

end.
