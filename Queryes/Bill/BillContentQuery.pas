unit BillContentQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseEventsQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap,
  ProductsBaseQuery, BillContentQuerySimple;

type
  TBillContentW = class(TProductW)
  private
    FBillContentID: TFieldWrap;
    FBillID: TFieldWrap;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property BillContentID: TFieldWrap read FBillContentID;
    property BillID: TFieldWrap read FBillID;
  end;

  TQryBillContent = class(TQueryProductsBase)
  private
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
    function GetExportFileName: string; override;
    property qBillContentSimple: TQueryBillContentSimple
      read GetqBillContentSimple;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    property W: TBillContentW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections, BillQuery;

{$R *.dfm}

constructor TQryBillContent.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBillContentW;

  DetailParameterName := W.BillID.FieldName;
end;

procedure TQryBillContent.AfterConstruction;
begin
  // ��������� �������������� SQL
  inherited;

  // ��������� � SQL ������ �������� - ������������� �����
  FDQuery.SQL.Text := ReplaceInSQL(SQL, Format('%s = :%s', [W.BillID.FullName,
    W.BillID.FieldName]), 0);
  SetParamType(W.BillID.FieldName);
end;

procedure TQryBillContent.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);
  // �������� ������� ������ - ��� ������ ������� ������, �� �� �������� ������ �� ������

  // ���� ��� ������
  if W.IsGroup.F.AsInteger = 1 then
  begin
    Assert(W.PK.Value > 0);
    // ���� ����� ������
    if qSearchComponentGroup.SearchByID(W.PK.Value) = 0 then
      Exit;

    // ������ ������� �� ����. ���� ������� � �������� ������ ��� ���������� ���� ������
    // ���� ���������� �� ������� ������, ������� ����������� ���� ������
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

  // �������� � ������ ��� ��������� ����������
  qSearchStorehouseProduct.FDQuery.First;
  while not qSearchStorehouseProduct.FDQuery.Eof do
  begin
    // ����������� ���������� ������ �� ������
    if W.SaleCount.F.AsFloat > 0 then
    begin
      qSearchStorehouseProduct.W.TryEdit;
      qSearchStorehouseProduct.W.Amount.F.AsFloat :=
        qSearchStorehouseProduct.W.Amount.F.AsFloat + W.SaleCount.F.AsFloat;
      qSearchStorehouseProduct.W.TryPost;
    end;

    // ���� � ������� ��� ������� �� �����
    if qBillContentSimple.SearchByID(W.BillContentID.F.AsInteger) = 1 then
      qBillContentSimple.FDQuery.Delete;

    qSearchStorehouseProduct.FDQuery.Next;
  end;

  inherited;
end;

procedure TQryBillContent.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // ���������� � ���� �������� ���� �� �����������!

  inherited;
end;

procedure TQryBillContent.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ANewAmount: Double;
  AOldSaleCount: Double;
  ASaleCount: Double;
begin
  Assert(ASender = FDQuery);

  Assert(W.PK.Value < 0);

  AOldSaleCount := W.SaleCount.F.OldValue;

  ASaleCount := W.SaleCount.F.AsFloat;

  // ���� ���-�� ������������������ � ����� ������ �� ����������
  if AOldSaleCount = ASaleCount then
    Exit;

  // ���� ���������� �����
  if qBillContentSimple.SearchByID(W.FBillContentID.F.AsInteger) = 0 then
  begin
    AAction := eaFail;
    Exit;
  end;

  // ������������ ����� ���-�� ������ �� ������
  ANewAmount := qSearchStorehouseProduct.W.Amount.F.AsFloat + AOldSaleCount -
    ASaleCount;

  if ANewAmount < 0 then
  begin
    AAction := eaFail;
    Exit;
  end;

  // ���� �� �������������� ������ �����-�������
  qSearchStorehouseProduct.SearchByID(GetStorehouseProductID(W.PK.Value));

  // ��������� ���������� � ���������� ������ �� ������
  qSearchStorehouseProduct.W.TryEdit;
  qSearchStorehouseProduct.W.Amount.F.AsFloat := ANewAmount;
  qSearchStorehouseProduct.W.TryPost;

  // ��������� ���������� � ���������� ������� � �������� �����
  qBillContentSimple.W.TryEdit;
  qBillContentSimple.W.SaleCount.F.Value := ASaleCount;
  qBillContentSimple.W.TryPost;
  inherited;
end;

function TQryBillContent.CreateDSWrap: TDSWrap;
begin
  Result := TBillContentW.Create(FDQuery);
end;

function TQryBillContent.GetExportFileName: string;
var
  AQryBill: TQryBill;
begin
  Assert(Master <> nil);
  AQryBill := Master as TQryBill;
  Assert(AQryBill.FDQuery.RecordCount > 0);
  Result := Format('���� �%s �� %s.xls', [AQryBill.W.Number.F.AsString,
    FormatDateTime('dd.mm.yyyy', AQryBill.W.BillDate.F.AsDateTime)]);
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

constructor TBillContentW.Create(AOwner: TComponent);
begin
  inherited;
  FBillID := TFieldWrap.Create(Self, 'BillID');
  FBillContentID := TFieldWrap.Create(Self, 'BillContentID');
end;

end.
