unit BillContentQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseQuery0, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap,
  BillContentQuerySimple, SearchStorehouseProduct, BillInterface,
  NotifyEvents, StoreHouseListQuery, BillContentInterface;

type
  TBillContW = class(TBaseProductsW)
  private
    FAmount: TFieldWrap;
    FBillContentID: TFieldWrap;
    FBillID: TFieldWrap;
    FSaleCount: TFieldWrap;
    FSaleD: TFieldWrap;
    FSaleE: TFieldWrap;
    FSaleR: TFieldWrap;
  protected
    procedure InitFields; override;
  public const
    VirtualIDOffset = -100000;
    constructor Create(AOwner: TComponent); override;
    function GetStorehouseProductID(AVirtualID: Integer): Integer;
    property Amount: TFieldWrap read FAmount;
    property BillContentID: TFieldWrap read FBillContentID;
    property BillID: TFieldWrap read FBillID;
    property SaleCount: TFieldWrap read FSaleCount;
    property SaleD: TFieldWrap read FSaleD;
    property SaleE: TFieldWrap read FSaleE;
    property SaleR: TFieldWrap read FSaleR;
  end;

  TQueryBillContent = class(TQryProductsBase0, IBillContent)
  private
    FAfterLoad: TNotifyEventsEx;
    FqBillContentSimple: TQueryBillContentSimple;
    FqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    FW: TBillContW;
    function GetqBillContentSimple: TQueryBillContentSimple;
    function GetqSearchStorehouseProduct: TQuerySearchStorehouseProduct;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    property qBillContentSimple: TQueryBillContentSimple
      read GetqBillContentSimple;
    property qSearchStorehouseProduct: TQuerySearchStorehouseProduct
      read GetqSearchStorehouseProduct;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure CalcelAllShip;
    procedure CancelShip;
    procedure LoadContent(ABillID: Integer);
    procedure Ship;
    procedure ShipAll;
    property AfterLoad: TNotifyEventsEx read FAfterLoad;
    property W: TBillContW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, ProjectConst;

{$R *.dfm}

constructor TQueryBillContent.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillContW;

  DetailParameterName := W.BillID.FieldName;
  FAfterLoad := TNotifyEventsEx.Create(Self);
end;

destructor TQueryBillContent.Destroy;
begin
  inherited;
  FreeAndNil(FAfterLoad);
end;

procedure TQueryBillContent.AfterConstruction;
begin
  // Сохраняем первоначальный SQL
  inherited;

  // Добавляем в SQL запрос параметр - идентификатор счёта
  FDQuery.SQL.Text := ReplaceInSQL(SQL, Format('%s = :%s', [W.BillID.FullName,
    W.BillID.FieldName]), 0);
  SetParamType(W.BillID.FieldName);
end;

procedure TQueryBillContent.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);
  // Удаление позиции заказа - это отмена позиции заказа, но не удаление товара со склада

  // Ищем и удаляем сам контент из счёта
  if qBillContentSimple.SearchByID(W.BillContentID.F.AsInteger) = 1 then
    qBillContentSimple.FDQuery.Delete;
end;

procedure TQueryBillContent.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  Assert(W.PK.Value < 0);
  (*
    // Если изменилось кол-во продаж
    if W.SaleCount.F.OldValue <> W.SaleCount.F.Value then
    begin
    // Ищем содержимое счёта
    if qBillContentSimple.SearchByID(W.FBillContentID.F.AsInteger) = 0 then
    begin
    AAction := eaFail;
    Exit;
    end;
    // Обновляем информацию о количестве товаров в контенте счёта
    qBillContentSimple.W.TryEdit;
    qBillContentSimple.W.SaleCount.F.Value := W.SaleCount.F.AsFloat;
    qBillContentSimple.W.TryPost;
    end;
  *)
  // Если изменилось кол-во товара на складе (отгрузили товар)
  if W.Amount.F.OldValue <> W.Amount.F.Value then
  begin
    // Ищем по идентификатору связки склад-продукт
    if qSearchStorehouseProduct.SearchByID
      (W.GetStorehouseProductID(W.PK.Value)) = 0 then
    begin
      AAction := eaFail;
      Exit;
    end;

    // Обновляем информацию о количестве товара на складе
    qSearchStorehouseProduct.W.TryEdit;
    qSearchStorehouseProduct.W.Amount.F.AsFloat := W.Amount.F.AsFloat;
    qSearchStorehouseProduct.W.TryPost;
  end;
end;

procedure TQueryBillContent.CalcelAllShip;
begin
  FDQuery.DisableControls;
  try
    try
      W.SaveBookmark;
      FDQuery.First;
      while not FDQuery.Eof do
      begin
        CancelShip;
        FDQuery.Next;
      end;
      W.RestoreBookmark;
      ApplyUpdates;
    except
      CancelUpdates;
      raise;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryBillContent.CancelShip;
begin
  if qSearchStorehouseProduct.SearchByID(W.GetStorehouseProductID(W.PK.Value)) = 0
  then
    raise Exception.Create('Ошибка при поиске товара на складе');

  // Увеличиваем кол-во товара на складе в нашем наборе данных
  W.TryEdit;
  W.Amount.F.AsFloat := qSearchStorehouseProduct.W.Amount.F.AsFloat +
    W.SaleCount.F.AsFloat;
  W.TryPost;
end;

function TQueryBillContent.CreateDSWrap: TDSWrap;
begin
  Result := TBillContW.Create(FDQuery);
end;

function TQueryBillContent.GetqBillContentSimple: TQueryBillContentSimple;
begin
  if FqBillContentSimple = nil then
  begin
    FqBillContentSimple := TQueryBillContentSimple.Create(Self);
  end;

  Result := FqBillContentSimple;
end;

function TQueryBillContent.GetqSearchStorehouseProduct
  : TQuerySearchStorehouseProduct;
begin
  if FqSearchStorehouseProduct = nil then
    FqSearchStorehouseProduct := TQuerySearchStorehouseProduct.Create(Self);
  Result := FqSearchStorehouseProduct;
end;

procedure TQueryBillContent.LoadContent(ABillID: Integer);
begin
  if ABillID > 0 then
  begin
    TryLoad2(ABillID);
    FAfterLoad.CallEventHandlers(Self);
  end
  else
    FDQuery.Close;
end;

procedure TQueryBillContent.Ship;
begin
  if qSearchStorehouseProduct.SearchByID(W.GetStorehouseProductID(W.PK.Value)) = 0
  then
    raise Exception.Create('Ошибка при поиске товара на складе');

  if qSearchStorehouseProduct.W.Amount.F.AsFloat < W.SaleCount.F.AsFloat then
    raise Exception.Create(sIsNotEnoughProductAmount);

  // Уменьшаем кол-во товара на складе в нашем наборе данных
  W.TryEdit;
  W.Amount.F.AsFloat := qSearchStorehouseProduct.W.Amount.F.AsFloat -
    W.SaleCount.F.AsFloat;
  W.TryPost;
end;

procedure TQueryBillContent.ShipAll;
begin
  FDQuery.DisableControls;
  try
    try
      W.SaveBookmark;
      FDQuery.First;
      while not FDQuery.Eof do
      begin
        Ship;
        FDQuery.Next;
      end;
      W.RestoreBookmark;
      ApplyUpdates;
    except
      CancelUpdates;
      raise;
    end;
  finally
    FDQuery.EnableControls;
  end;
end;

constructor TBillContW.Create(AOwner: TComponent);
begin
  inherited;
  FBillID := TFieldWrap.Create(Self, 'bc.BillID');
  FBillContentID := TFieldWrap.Create(Self, 'BillContentID');
  FAmount := TFieldWrap.Create(Self, 'sp.Amount');
  FSaleCount := TFieldWrap.Create(Self, 'bc.SaleCount');
  FSaleR := TFieldWrap.Create(Self, 'SaleR');
  FSaleD := TFieldWrap.Create(Self, 'SaleD');
  FSaleE := TFieldWrap.Create(Self, 'SaleE');
end;

function TBillContW.GetStorehouseProductID(AVirtualID: Integer): Integer;
begin
  Assert(AVirtualID < VirtualIDOffset);
  Result := (AVirtualID * -1) + VirtualIDOffset;
end;

procedure TBillContW.InitFields;
begin
  inherited;

  SetDisplayFormat([SaleR.F, SaleD.F, SaleE.F]);
end;

end.
