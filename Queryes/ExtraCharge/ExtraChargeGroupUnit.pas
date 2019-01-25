unit ExtraChargeGroupUnit;

interface

uses
  QueryGroupUnit2, System.Classes, ExtraChargeQuery2, ExtraChargeTypeQuery,
  NotifyEvents, ExtraChargeExcelDataModule, ExtraChargeInterface;

type
  TExtraChargeGroup = class(TQueryGroup2, IExtraCharge)
  strict private
  function HaveDuplicate(const AExtraChargeTypeName, ARange: String): Boolean;
      stdcall;
  private
    FqExtraCharge2: TQueryExtraCharge2;
    FqExtraChargeType: TQueryExtraChargeType;
    procedure DoAfterDelete(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDataFromExcelTable(AExcelTable: TExtraChargeExcelTable);
    property qExtraCharge2: TQueryExtraCharge2 read FqExtraCharge2;
    property qExtraChargeType: TQueryExtraChargeType read FqExtraChargeType;
  end;

implementation

uses
  System.SysUtils, System.Variants;

constructor TExtraChargeGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqExtraCharge2 := TQueryExtraCharge2.Create(Self);
  FqExtraChargeType := TQueryExtraChargeType.Create(Self);

  QList.Add(FqExtraCharge2);
  QList.Add(qExtraChargeType);

  // Для каскадного удаления
  TNotifyEventWrap.Create(FqExtraChargeType.AfterDelete, DoAfterDelete,
    EventList);
end;

procedure TExtraChargeGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(FqExtraChargeType.OldPKValue > 0);
  // На сервере оптовые наценки уже каскадно удалились
  // Каскадно удаляем оптовые наценки с клиента
  FqExtraCharge2.CascadeDelete(FqExtraChargeType.OldPKValue,
    FqExtraCharge2.W.IDExtraChargeType.FieldName, True);
end;

function TExtraChargeGroup.HaveDuplicate(const AExtraChargeTypeName, ARange:
    String): Boolean;
var
  V: Variant;
begin
  Result := False;

  // Сначала ищем такой тип оптовой наценки
  V := qExtraChargeType.W.Lookup(AExtraChargeTypeName);
  if VarIsNull(V) then Exit;


  V := qExtraCharge2.W.LookupByRange(V, ARange);
  Result := not VarIsNull(V);
end;

procedure TExtraChargeGroup.LoadDataFromExcelTable(AExcelTable:
    TExtraChargeExcelTable);
begin
  AExcelTable.First;
  while not AExcelTable.Eof do
  begin
    // Ищем или добавляем тип оптовой наценки
    qExtraChargeType.W.LocateOrAppend(AExcelTable.ExtraChargeType.AsString);

    // Если такой диапазон уже есть
    if qExtraCharge2.W.LocateByRange(qExtraChargeType.PK.AsInteger, AExcelTable.Range.Value) then
      qExtraCharge2.W.TryEdit
    else
    begin
      qExtraCharge2.W.TryAppend;
    end;

    qExtraCharge2.W.IDExtraChargeType.F.AsInteger := qExtraChargeType.PK.AsInteger;
    qExtraCharge2.W.Range.F.Value := AExcelTable.Range.Value;
    qExtraCharge2.W.WholeSale.F.Value := AExcelTable.WholeSale.Value;
    qExtraCharge2.W.TryPost;

    AExcelTable.Next;
  end;

end;

end.
