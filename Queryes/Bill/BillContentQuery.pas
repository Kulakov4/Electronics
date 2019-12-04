unit BillContentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseEventsQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap,
  ProductsBaseQuery, BillContentQuerySimple, BillContentInterface,
  BillInterface;

type
  TBillContentW = class(TProductW)
  private
    FBillContentID: TFieldWrap;
    FBillID: TFieldWrap;
    FDollar: TFieldWrap;
    FEuro: TFieldWrap;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property BillContentID: TFieldWrap read FBillContentID;
    property BillID: TFieldWrap read FBillID;
    property Dollar: TFieldWrap read FDollar;
    property Euro: TFieldWrap read FEuro;
  end;

  TQryBillContent = class(TQueryProductsBase, IBillContent)
  private
    FBill: IBill;
    FIsShipment: Boolean;
    FqBillContentSimple: TQueryBillContentSimple;
    FW: TBillContentW;
    function GetqBillContentSimple: TQueryBillContentSimple;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoBeforePost(Sender: TObject); override;
    function GetDollarCource: Double; override;
    function GetEuroCource: Double; override;
    function GetExportFileName: string; override;
    property qBillContentSimple: TQueryBillContentSimple
      read GetqBillContentSimple;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    function AllowEdit: Boolean;
    procedure CancelShip;
    procedure Ship;
    procedure ShipAll;
    procedure CalcelAllShip;
    procedure CloseContent;
    procedure LoadContent(ABillID: Integer; ABill: IBill);
    property W: TBillContentW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections, ProjectConst;

{$R *.dfm}

constructor TQryBillContent.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillContentW;

  DetailParameterName := W.BillID.FieldName;
end;

procedure TQryBillContent.AfterConstruction;
begin
  // Сохраняем первоначальный SQL
  inherited;

  // Добавляем в SQL запрос параметр - идентификатор счёта
  FDQuery.SQL.Text := ReplaceInSQL(SQL, Format('%s = :%s', [W.BillID.FullName,
    W.BillID.FieldName]), 0);
  SetParamType(W.BillID.FieldName);
end;

function TQryBillContent.AllowEdit: Boolean;
begin
  // Разрешаем редактирование только неотгруженного товара
  Result := (FBill <> nil) and (FBill.BillDate >= 0) and
    (FBill.ShipmentDate <= 0);
end;

procedure TQryBillContent.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);
  // Удаление позиции заказа - это отмена позиции заказа, но не удаление товара со склада

  // Ищем и удаляем сам контент из счёта
  if qBillContentSimple.SearchByID(W.BillContentID.F.AsInteger) = 1 then
    qBillContentSimple.FDQuery.Delete;

  (*
    // Если это группа
    if W.IsGroup.F.AsInteger = 1 then
    begin
    Assert(W.PK.Value > 0);
    // Ищем такую группу
    if qSearchComponentGroup.SearchByID(W.PK.Value) = 0 then
    Exit;

    // Группу удалять не надо. Надо удалить с текущего склада все компоненты этой группы
    // Ищем компоненты на текущем складе, которые принадлежат этой группе
    if qSearchStorehouseProduct.SearchByGroupID(W.StorehouseId.F.AsInteger,
    W.PK.Value) = 0 then
    Exit;

    end
    else
    begin
    Assert(W.PK.Value < FVirtualIDOffset);
    if qSearchStorehouseProduct.SearchByID(GetStorehouseProductID(W.PK.Value)) = 0
    then
    Exit;
    end;

    // Отменяем в заказе все найденные компоненты
    qSearchStorehouseProduct.FDQuery.First;
    while not qSearchStorehouseProduct.FDQuery.Eof do
    begin

    // Увеличиваем количество товара на складе
    if W.SaleCount.F.AsFloat > 0 then
    begin
    qSearchStorehouseProduct.W.TryEdit;
    qSearchStorehouseProduct.W.Amount.F.AsFloat :=
    qSearchStorehouseProduct.W.Amount.F.AsFloat + W.SaleCount.F.AsFloat;
    qSearchStorehouseProduct.W.TryPost;
    end;

    // Ищем и удаляем сам контент из счёта
    if qBillContentSimple.SearchByID(W.BillContentID.F.AsInteger) = 1 then
    qBillContentSimple.FDQuery.Delete;

    qSearchStorehouseProduct.FDQuery.Next;
    end;
  *)
end;

procedure TQryBillContent.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Добавление в счёт контента пока не реализовано!
end;

procedure TQryBillContent.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  Assert(W.PK.Value < 0);

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

procedure TQryBillContent.CancelShip;
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

function TQryBillContent.CreateDSWrap: TDSWrap;
begin
  Result := TBillContentW.Create(FDQuery);
end;

function TQryBillContent.GetExportFileName: string;
begin
  Assert(FBill <> nil);
  Assert(FBill.BillNumber > 0);

  Result := Format('Счёт №%s от %s.xls', [FBill.BillNumberStr,
    FormatDateTime('dd.mm.yyyy', FBill.BillDate)]);
  Assert(not Result.IsEmpty);
end;

function TQryBillContent.GetqBillContentSimple: TQueryBillContentSimple;
begin
  if FqBillContentSimple = nil then
  begin
    FqBillContentSimple := TQueryBillContentSimple.Create(Self);
  end;

  Result := FqBillContentSimple;
end;

procedure TQryBillContent.Ship;
begin
  if qSearchStorehouseProduct.SearchByID(W.GetStorehouseProductID(W.PK.Value)) = 0
  then
    raise Exception.Create('Ошибка при поиске товара на складе');

  if qSearchStorehouseProduct.W.Amount.F.AsFloat < W.SaleCount.F.AsFloat then
    raise Exception.Create(sIsNotEnoughProductAmount);

  FIsShipment := True;
  // Уменьшаем кол-во товара на складе в нашем наборе данных
  W.TryEdit;
  W.Amount.F.AsFloat := qSearchStorehouseProduct.W.Amount.F.AsFloat -
    W.SaleCount.F.AsFloat;
  W.TryPost;
  FIsShipment := False;
end;

procedure TQryBillContent.ShipAll;
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

procedure TQryBillContent.CalcelAllShip;
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

procedure TQryBillContent.CloseContent;
begin
  FDQuery.Close;
  FBill := nil;
end;

procedure TQryBillContent.DoBeforePost(Sender: TObject);
begin
  // Во время отгрузки на складе может остаться меньше чем отгрузили!!!
  if (FDQuery.State <> dsEdit) or (not FIsShipment) then
    inherited;
end;

function TQryBillContent.GetDollarCource: Double;
begin
  Result := FBill.DollarCource;
end;

function TQryBillContent.GetEuroCource: Double;
begin
  Result := FBill.EuroCource;
end;

procedure TQryBillContent.LoadContent(ABillID: Integer; ABill: IBill);
begin
  Assert(ABill <> nil);
  FBill := ABill;

  TryLoad2(ABillID);
end;

constructor TBillContentW.Create(AOwner: TComponent);
begin
  inherited;
  FBillID := TFieldWrap.Create(Self, 'BillID');
  FBillContentID := TFieldWrap.Create(Self, 'BillContentID');
end;

end.
