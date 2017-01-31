unit ProductsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections, ProductsBaseQuery,
  StoreHouseProductsCountQuery, RepositoryDataModule, cxGridDBBandedTableView,
  DBRecordHolder, ApplyQueryFrame, {ExcelController, }SearchMainComponent2;

type
  TQueryProducts = class(TQueryProductsBase)
  private
    FNeedUpdateCount: Boolean;
    FQueryStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
// TODO: DoBeforeOpen
//  procedure DoBeforeOpen(Sender: TObject);
    function GetQueryStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    function GetTotalCount: Integer;
    { Private declarations }
  protected
    property QueryStoreHouseProductsCount: TQueryStoreHouseProductsCount
      read GetQueryStoreHouseProductsCount;
  public
    constructor Create(AOwner: TComponent); override;
// TODO: AddStringList
//  function AddStringList(ARows: TArray<String>): TStringList;
// TODO: InsertRecordList
//// TODO: ConvertRowsToRecords
////  function ConvertRowsToRecords(ARows: TStringList): TList<TProductRecord>;
//  // TODO: FindAndDeleteDuplicates
//  // function FindAndDeleteDuplicates(AMainDataSet: TDataSet):
//  // TList<TComponentRecord>;
//  procedure InsertRecordList(AList: TList<TProductRecord>);
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses NotifyEvents, System.Generics.Defaults, System.Types,
  System.StrUtils, System.Math, ParameterValuesUnit;

{$R *.dfm}
{ TfrmQueryStoreHouseComponents }

constructor TQueryProducts.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vStoreHouseID';
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

// TODO: AddStringList
//function TQueryProducts.AddStringList(ARows: TArray<String>): TStringList;
//var
//AValue: string;
//AParts: TStringDynArray;
//ACategories: string;
//AComponentGroup: string;
//begin
//TryPost;
//
//Result := TStringList.Create;
//AComponentGroup := '';
//for AValue in ARows do
//begin
//  TryPost;
//  if AValue = '' then // если текущее значение пустое - пропустить его
//    Continue;
//
//  ACategories := '';
//  AParts := SplitString(AValue, #9); // разделить строку по табул€ции
//  // проверить, идЄт в начале группа компонентов или нет
//  if Length(AParts) > 4 then // хот€ бы 4 столбца должно быть в буфере
//  begin
//    if (AParts[1] = '') and (AParts[2] = '') and (AParts[3] = '') and
//      (AParts[0] <> '') then
//    begin
//      AComponentGroup := AParts[0];
//      Continue; // и перейти к следующей записи
//    end;
//  end;
//
//  if Length(AParts) > 0 then
//  begin
//    FDQuery.Append;
//    FDQuery.FieldByName('Value').AsVariant := AParts[0];
//    if (Length(AParts) > 1) and (AParts[1] <> '') then
//      FDQuery.FieldByName('ManufacturerStr').AsVariant := AParts[1];
//    if Length(AParts) > 2 then
//    begin
//      if AParts[2] = '' then
//        FDQuery.FieldByName('ComponentGroupStr').AsVariant := AParts[2]
//      else
//        FDQuery.FieldByName('ComponentGroupStr').AsVariant := AComponentGroup;
//    end;
//    if (Length(AParts) > 3) and (AParts[3] <> '') then
//      FDQuery.FieldByName('DescriptionStr').AsVariant := AParts[3];
//    if Length(AParts) > 4 then
//      FDQuery.FieldByName('Specification').AsVariant := AParts[4];
//    if Length(AParts) > 5 then
//      FDQuery.FieldByName('Image').AsVariant := AParts[5];
//    if (Length(AParts) > 6) and (AParts[6] <> '') then
//      FDQuery.FieldByName('BodyStr').AsVariant := AParts[6];
//    if Length(AParts) > 7 then
//      FDQuery.FieldByName('ReleaseDate').AsVariant := AParts[7];
//    if (Length(AParts) > 8) and (AParts[8] <> '') then
//      FDQuery.FieldByName('Amount').AsVariant := AParts[8];
//    if (Length(AParts) > 9) and (AParts[9] <> '') then
//      FDQuery.FieldByName('Price').AsVariant := AParts[9];
//    FDQuery.Post;
//  end;
//  { if Length(AParts) = 2 then          //если после разделени€ строки получилось 2 записи, то считать вторую запись списком категорий
//    begin
//    ACategories := AParts[1];
//    end;
//    ARecord := AParts[0];
//    FDQuery.Append;
//    FDQuery.FieldByName('Value').AsVariant := ARecord;
//    FDQuery.Post; }
//end;
//
//// AView.EndUpdate;
//end;

// TODO: ConvertRowsToRecords
//function TQueryProducts.ConvertRowsToRecords(ARows: TStringList)
//: TList<TProductRecord>;
//var
//AValue, ACategories: string;
//AParts: TStringDynArray;
//AComponentGroup: string;
//ARecord: TProductRecord;
//begin
//Result := TList<TProductRecord>.Create();
//AComponentGroup := '';
//for AValue in ARows do
//begin
//  if AValue = '' then // если текущее значение пустое - пропустить его
//    Continue;
//
//  ACategories := '';
//  AParts := SplitString(AValue, #9); // разделить строку по табул€ции
//  // проверить, идЄт в начале группа компонентов или нет
//  if Length(AParts) > 4 then // хот€ бы 4 столбца должно быть в буфере
//  begin
//    if (AParts[1] = '') and (AParts[2] = '') and (AParts[3] = '') and
//      (AParts[0] <> '') then
//    begin
//      AComponentGroup := AParts[0];
//      Continue; // и перейти к следующей записи
//    end;
//  end;
//
//  if Length(AParts) > 0 then
//  begin
//    ARecord := TProductRecord.Create;
//    ARecord.Value := AParts[0];
//    if (Length(AParts) > 1) and (AParts[1] <> '') then
//      ARecord.Manufacturer := AParts[1];
//    if Length(AParts) > 2 then
//    begin
//      if AParts[2] = '' then
//        ARecord.ComponentGroup := AParts[2]
//      else
//        ARecord.ComponentGroup := AComponentGroup;
//    end;
//    if (Length(AParts) > 3) and (AParts[3] <> '') then
//      ARecord.Description := AParts[3];
//    if Length(AParts) > 4 then
//      ARecord.Specification := AParts[4];
//    if Length(AParts) > 5 then
//      ARecord.Image := AParts[5];
//    if (Length(AParts) > 6) and (AParts[6] <> '') then
//      ARecord.Body := AParts[6];
//    if Length(AParts) > 7 then
//      ARecord.ManufacturerDate := AParts[7];
//    if (Length(AParts) > 8) and (AParts[8] <> '') then
//      ARecord.Amount := AParts[8];
//    if (Length(AParts) > 9) and (AParts[9] <> '') then
//      ARecord.Price := AParts[9];
//    Result.Add(ARecord);
//  end;
//end;
//end;

procedure TQueryProducts.DoAfterInsert(Sender: TObject);
begin
  // «аполн€ем код склада
  StorehouseId.AsInteger := ParentValue;
end;

procedure TQueryProducts.DoAfterOpen(Sender: TObject);
begin
  FDQuery.FieldByName('Amount').OnGetText := HideNullGetText;
  // FDQuery.FieldByName('Price').OnGetText := HideNullGetTex
end;

// TODO: DoBeforeOpen
//procedure TQueryProducts.DoBeforeOpen(Sender: TObject);
//begin
//(*
//// если пол€ уже создали
//if FDQuery.Fields.Count > 0 then
//  Exit;
//
//FDQuery.FieldDefs.Update;
//if FDQuery.FieldDefs.IndexOf('ExcelRowNum') < 0 then
//  FDQuery.FieldDefs.Add('ExcelRowNum', ftInteger);
//
//CreateDefaultFields(False);
//
//FDQuery.FieldByName('ExcelRowNum').FieldKind := fkInternalCalc;
//*)
//end;

function TQueryProducts.GetQueryStoreHouseProductsCount
  : TQueryStoreHouseProductsCount;
begin
  if FQueryStoreHouseProductsCount = nil then
  begin
    FQueryStoreHouseProductsCount := TQueryStoreHouseProductsCount.Create(Self);
    FQueryStoreHouseProductsCount.FDQuery.Connection := FDQuery.Connection;
  end;
  Result := FQueryStoreHouseProductsCount;
end;

function TQueryProducts.GetTotalCount: Integer;
begin
  if FNeedUpdateCount or not QueryStoreHouseProductsCount.FDQuery.Active then
  begin
    QueryStoreHouseProductsCount.FDQuery.Close;
    QueryStoreHouseProductsCount.FDQuery.Open;
    FNeedUpdateCount := False;
  end;
  Result := QueryStoreHouseProductsCount.Count + CashedRecordBalance;
end;

// TODO: InsertRecordList
//procedure TQueryProducts.InsertRecordList(AList: TList<TProductRecord>);
//var
//ARecord: TProductRecord;
//// AComparison: TComparison<TProductRecord>;
//begin
//// AComparison := function(const Left, Right: TProductRecord): Integer
//// begin
//// Result := CompareValue(Left.ExcelRowNumber, Right.ExcelRowNumber);
//// end;
//
//FDQuery.DisableControls;
//try
//  for ARecord in AList do
//  begin
//    FDQuery.Append;
//    FDQuery.FieldByName('Value').AsString := ARecord.Value;
//    FDQuery.FieldByName('ManufacturerStr').AsString := ARecord.Manufacturer;
//    FDQuery.FieldByName('ComponentGroupStr').AsString :=
//      ARecord.ComponentGroup;
//    FDQuery.FieldByName('DescriptionStr').AsString := ARecord.Description;
//    FDQuery.FieldByName('Specification').AsString := ARecord.Specification;
//    FDQuery.FieldByName('Image').AsString := ARecord.Image;
//    FDQuery.FieldByName('BodyStr').AsString := ARecord.Body;
//
//    FDQuery.FieldByName('Amount').AsString := ARecord.Amount;
//    FDQuery.FieldByName('ReleaseDate').AsString := ARecord.ManufacturerDate;
//    FDQuery.FieldByName('Price').AsString := ARecord.Price;
//
//    FDQuery.FieldByName('ExcelRowNum').AsInteger := ARecord.ExcelRowNumber;
//    FDQuery.Post;
//  end;
//finally
//  FDQuery.EnableControls;
//end;
//end;

end.
