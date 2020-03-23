unit ProductsBasketView2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView1, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, cxCalendar,
  cxCurrencyEdit, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar,
  cxBarEditItem, cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData,
  ProductsViewModel, ProductsBaseView0;

type
  TViewProductsBasket2 = class(TViewProductsBase1)
    actBasketClear: TAction;
    actBasketDelete: TAction;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    procedure actBasketClearExecute(Sender: TObject);
    procedure actBasketDeleteExecute(Sender: TObject);
    procedure cxDBTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
  private
    function GetBasketViewModel: TProductsViewModel;
    procedure SetBasketViewModel(const Value: TProductsViewModel);
    { Private declarations }
  protected
    function CreateProductView: TViewProductsBase0; override;
    procedure InitializeColumns; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateView; override;
    property BasketViewModel: TProductsViewModel read GetBasketViewModel
      write SetBasketViewModel;
    { Public declarations }
  end;

implementation

uses
  DialogUnit;

{$R *.dfm}

constructor TViewProductsBasket2.Create(AOwner: TComponent);
begin
  inherited;
  Name := 'ViewProductsBasket';
end;

procedure TViewProductsBasket2.actBasketClearExecute(Sender: TObject);
var
  Arr: TArray<Integer>;
begin
  if not TDialog.Create.ClearBasketDialog then
    Exit;

  Arr := W.ID.AsIntArray;

  // Отвязываем полностью cxDBTreeList от данных!!!
  W.DataSource.Enabled := False;
  try
    BasketViewModel.qProducts.DeleteFromBasket(Arr);
  finally
    W.DataSource.Enabled := True;
  end;
end;

procedure TViewProductsBasket2.actBasketDeleteExecute(Sender: TObject);
begin
  inherited;
  BeginUpdate;
  try
    BasketViewModel.qProducts.DeleteFromBasket(GetSelectedID);
  finally
    EndUpdate;
  end;
end;

function TViewProductsBasket2.CreateProductView: TViewProductsBase0;
begin
  Result := TViewProductsBasket2.Create(nil);
end;

procedure TViewProductsBasket2.cxDBTreeListEditing(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn; var Allow: Boolean);
begin
  inherited;
  Allow := AColumn = clSaleCount;
end;

function TViewProductsBasket2.GetBasketViewModel: TProductsViewModel;
begin
  Result := Model as TProductsViewModel;
end;

procedure TViewProductsBasket2.InitializeColumns;
begin
  inherited;

  Assert(M <> nil);

  // clSaleCount.Position.Band.Position.ColIndex := 1;
  // clSaleR.Position.Band.Position.ColIndex := 2;

  InitializeLookupColumn(clStorehouseId,
    BasketViewModel.qStoreHouseList.W.DataSource, lsEditFixedList,
    BasketViewModel.qStoreHouseList.W.Abbreviation.FieldName);
end;

procedure TViewProductsBasket2.SetBasketViewModel
  (const Value: TProductsViewModel);
begin
  if Value = Model then
    Exit;

  Model := Value;

  MyApplyBestFit;
end;

procedure TViewProductsBasket2.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and (M <> nil) and
    (BasketViewModel.qProductsBase.FDQuery.Active);

  actBasketDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.SelectionCount > 0) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actBasketClear.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);
end;

end.
