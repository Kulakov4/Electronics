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
  DBRecordHolder, ApplyQueryFrame, ProductsExcelDataModule, NotifyEvents;

type
  TQueryProducts = class(TQueryProductsBase)
  private
    FNeedUpdateCount: Boolean;
    FQueryStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    // TODO: DoBeforeOpen
    // procedure DoBeforeOpen(Sender: TObject);
    function GetQueryStoreHouseProductsCount: TQueryStoreHouseProductsCount;
    function GetStoreHouseName: string;
    function GetTotalCount: Integer;
    { Private declarations }
  protected
    function GetExportFileName: string; override;
    property QueryStoreHouseProductsCount: TQueryStoreHouseProductsCount
      read GetQueryStoreHouseProductsCount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendList(AExcelTable: TProductsExcelTable);
    procedure AppendRows(AValues: TList<String>;
      const AProducers: TList<String>); overload;
    property StoreHouseName: string read GetStoreHouseName;
    // TODO: AddStringList
    // function AddStringList(ARows: TArray<String>): TStringList;
    // TODO: InsertRecordList
    /// / TODO: ConvertRowsToRecords
    /// /  function ConvertRowsToRecords(ARows: TStringList): TList<TProductRecord>;
    // // TODO: FindAndDeleteDuplicates
    // // function FindAndDeleteDuplicates(AMainDataSet: TDataSet):
    // // TList<TComponentRecord>;
    // procedure InsertRecordList(AList: TList<TProductRecord>);
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses System.Generics.Defaults, System.Types, System.StrUtils, System.Math,
  ParameterValuesUnit, StoreHouseListQuery;

{$R *.dfm}
{ TfrmQueryStoreHouseComponents }

constructor TQueryProducts.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vStoreHouseID';
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryProducts.AppendList(AExcelTable: TProductsExcelTable);
var
  AExcelField: TField;
  AField: TField;
begin
  AExcelTable.First;
  AExcelTable.CallOnProcessEvent;
  while not AExcelTable.Eof do
  begin
    // 1) ���� ������ ������������� � ����������� ��������������
    QueryProducers.LocateOrAppend(AExcelTable.Producer.AsString);

    // ��������� ����� �� �����
    FDQuery.Append;
    // ��������� ��� ���� ������ � ������ �� ������ ���������� �� Excel �������
    for AExcelField in AExcelTable.Fields do
    begin
      AField := FDQuery.FindField(AExcelField.FieldName);
      if AField <> nil then
        AField.Value := AExcelField.Value;
    end;
    // ������������� ���������
    IDProducer.AsInteger := QueryProducers.PKValue;
    FDQuery.Post;

    AExcelTable.Next;
    AExcelTable.CallOnProcessEvent;
  end;
end;

procedure TQueryProducts.AppendRows(AValues: TList<String>;
  const AProducers: TList<String>);
var
  I: Integer;
begin
  Assert(AValues <> nil);
  Assert(AProducers <> nil);
  Assert(AValues.Count = AProducers.Count);
  Assert(AValues.Count > 0);

  for I := 0 to AValues.Count - 1 do
  begin
    // ���� ������ �������������
    if not QueryProducers.Locate(AProducers[I]) then
      raise Exception.CreateFmt('������������� "%s" �� ������ � �����������',
        [AProducers[I]]);

    TryAppend;
    Value.AsString := AValues[i];
    IDProducer.AsInteger := QueryProducers.PKValue;
    TryPost;
  end;
end;

procedure TQueryProducts.DoAfterInsert(Sender: TObject);
begin
  // ��������� ��� ������
  StorehouseId.AsInteger := ParentValue;
end;

procedure TQueryProducts.DoAfterOpen(Sender: TObject);
begin
  // FDQuery.FieldByName('Amount').OnGetText := HideNullGetText;
  // FDQuery.FieldByName('Price').OnGetText := HideNullGetTex
end;

function TQueryProducts.GetExportFileName: string;
var
  AQueryStoreHouseList: TQueryStoreHouseList;
begin
  Assert(Master <> nil);
  AQueryStoreHouseList := Master as TQueryStoreHouseList;
  Assert(AQueryStoreHouseList.FDQuery.RecordCount > 0);
  Result := Format('%s %s.xls', [AQueryStoreHouseList.Abbreviation.AsString,
    FormatDateTime('dd.mm.yyyy', Date)]);
  Assert(not Result.IsEmpty);
end;

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

function TQueryProducts.GetStoreHouseName: string;
var
  AQueryStoreHouseList: TQueryStoreHouseList;
begin
  Assert(Master <> nil);
  AQueryStoreHouseList := Master as TQueryStoreHouseList;
  Result := AQueryStoreHouseList.Title.AsString;
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
// procedure TQueryProducts.InsertRecordList(AList: TList<TProductRecord>);
// var
// ARecord: TProductRecord;
/// / AComparison: TComparison<TProductRecord>;
// begin
/// / AComparison := function(const Left, Right: TProductRecord): Integer
/// / begin
/// / Result := CompareValue(Left.ExcelRowNumber, Right.ExcelRowNumber);
/// / end;
//
// FDQuery.DisableControls;
// try
// for ARecord in AList do
// begin
// FDQuery.Append;
// FDQuery.FieldByName('Value').AsString := ARecord.Value;
// FDQuery.FieldByName('ManufacturerStr').AsString := ARecord.Manufacturer;
// FDQuery.FieldByName('ComponentGroupStr').AsString :=
// ARecord.ComponentGroup;
// FDQuery.FieldByName('DescriptionStr').AsString := ARecord.Description;
// FDQuery.FieldByName('Specification').AsString := ARecord.Specification;
// FDQuery.FieldByName('Image').AsString := ARecord.Image;
// FDQuery.FieldByName('BodyStr').AsString := ARecord.Body;
//
// FDQuery.FieldByName('Amount').AsString := ARecord.Amount;
// FDQuery.FieldByName('ReleaseDate').AsString := ARecord.ManufacturerDate;
// FDQuery.FieldByName('Price').AsString := ARecord.Price;
//
// FDQuery.FieldByName('ExcelRowNum').AsInteger := ARecord.ExcelRowNumber;
// FDQuery.Post;
// end;
// finally
// FDQuery.EnableControls;
// end;
// end;

end.
