unit OrderQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper, System.Generics.Collections;

type
  TQueryOrder = class(TQueryWithDataSource)
  private
    FRecOrderList: TList<TRecOrder>;
    { Private declarations }
  protected
    procedure DoOnUpdateOrder(ARecOrder: TRecOrder);
    function GetOrd: TField; virtual;
    procedure UpdateOrder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MoveDSRecord(AStartDrag: TStartDrag; ADropDrag: TDropDrag);
    property Ord: TField read GetOrd;
    { Public declarations }
  end;

var
  QueryOrder: TQueryOrder;

implementation

{$R *.dfm}

uses System.Math, System.Generics.Defaults;

constructor TQueryOrder.Create(AOwner: TComponent);
begin
  inherited;
  FRecOrderList := TList<TRecOrder>.Create;
end;

destructor TQueryOrder.Destroy;
begin
  FreeAndNil(FRecOrderList);
  inherited;
end;

procedure TQueryOrder.DoOnUpdateOrder(ARecOrder: TRecOrder);
begin
  Ord.Value := ARecOrder.Order;
end;

function TQueryOrder.GetOrd: TField;
begin
  Result := Field('Ord');
end;

procedure TQueryOrder.MoveDSRecord(AStartDrag: TStartDrag;
  ADropDrag: TDropDrag);
var
  AClone: TFDMemTable;
  AClone2: TFDMemTable;
  AKeyField: TField;
  ANewOrderValue: Integer;
  ANewRecNo: Integer;
  AOrderField: TField;
  AOrderField2: TField;
  I: Integer;
  IsDown: Boolean;
  IsUp: Boolean;
  k: Integer;
  OK: Boolean;
  Sign: Integer;
begin
  for I := 0 to FRecOrderList.Count - 1 do
      FRecOrderList[I].Free;
  FRecOrderList.Clear;


  // ��������� �������� ������� ����������
  AClone := TFDMemTable.Create(Self);
  AClone2 := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.First;

    AClone2.CloneCursor(FDQuery);
    AClone2.First;

    // ���� ��� ������� �����
    IsUp := (ADropDrag.OrderValue < AStartDrag.MinOrderValue);
    // ���� ��� ������� ����
    IsDown := not IsUp;

    AOrderField := AClone.FieldByName(Ord.FieldName);
    AOrderField2 := AClone2.FieldByName(Ord.FieldName);
    AKeyField := AClone.FieldByName(PKFieldName);

    while not AClone.Eof do
    begin
      Sign := 0;

      // ���� ������������� �����
      if IsUp and (AOrderField.AsInteger >= ADropDrag.OrderValue) and
        (AOrderField.AsInteger < AStartDrag.MinOrderValue) then
        Sign := 1;

      // ���� ������������� ����
      if IsDown and (AOrderField.AsInteger <= ADropDrag.OrderValue) and
        (AOrderField.AsInteger > AStartDrag.MaxOrderValue) then
        Sign := -1;

      // ���� ������� ������ ����� ��������
      if Sign <> 0 then
      begin

        OK := AClone2.LocateEx(PKFieldName, AKeyField.Value, []);
        Assert(OK);
        // ������� ��������
        ANewRecNo := AClone2.RecNo + Sign * Length(AStartDrag.Keys);
        Assert((ANewRecNo >= 1) and (ANewRecNo <= AClone2.RecordCount));
        AClone2.RecNo := ANewRecNo;
        // ���� ������ � ������������� �������
        FRecOrderList.Add(TRecOrder.Create(AKeyField.AsInteger,
          -AOrderField2.AsInteger));
        // ����������, ��� ����� ��������
        // FRecOrderList.Add(TRecOrder.Create(AKeyField.AsInteger, AOrderField.AsInteger + Sign *
        // Length(AStartDrag.Keys)));
      end;

      AClone.Next;
    end;

    // ANewOrderValue := ADropDrag.OrderValue;
    // if IsDown then
    // ANewOrderValue := ADropDrag.OrderValue - Length(AStartDrag.Keys) + 1;

    AClone2.LocateEx(PKFieldName, ADropDrag.Key, []);
    Assert(OK);

    if IsUp then
      TArray.Sort<Integer>(AStartDrag.Keys)
    else
      TArray.Sort<Integer>(AStartDrag.Keys, TComparer<Integer>.Construct(
        function(const Left, Right: Integer): Integer
        begin
          Result := Right - Left;
        end));

    for I := Low(AStartDrag.Keys) to High(AStartDrag.Keys) do
    begin
      // ����������, ��� ����� ��������
      FRecOrderList.Add(TRecOrder.Create(AStartDrag.Keys[I],
        AOrderField2.AsInteger));
      ANewRecNo := IfThen(IsUp, AClone2.RecNo + 1, AClone2.RecNo - 1);
      Assert((ANewRecNo >= 1) and (ANewRecNo <= AClone2.RecordCount));
      AClone2.RecNo := ANewRecNo;
    end;
  finally
    FreeAndNil(AClone);
    FreeAndNil(AClone2)
  end;

  // ������ ������������� �������� �� �������������
  k := FRecOrderList.Count - 1;
  for I := 0 to k do
  begin
    if FRecOrderList[I].Order < 0 then
      FRecOrderList.Add(TRecOrder.Create(FRecOrderList[I].Key,
        -FRecOrderList[I].Order));
  end;

  // ��������� ��� ���������
  UpdateOrder;
end;

procedure TQueryOrder.UpdateOrder;
var
  APKValue: Integer;
  I: Integer;
  OK: Boolean;
begin
  if FRecOrderList.Count = 0 then
  begin
    Exit;
  end;

  FDQuery.DisableControls;
  try
    APKValue := PKValue;
    try
      // ������ �������� �������
      for I := 0 to FRecOrderList.Count - 1 do
      begin
        OK := FDQuery.Locate(PKFieldName, FRecOrderList[I].Key, []);
        Assert(OK);

        FDQuery.Edit;
        DoOnUpdateOrder(FRecOrderList[I]);
        FDQuery.Post;
      end;

      for I := 0 to FRecOrderList.Count - 1 do
        FRecOrderList[I].Free;
      FRecOrderList.Clear;
    finally
      FDQuery.Locate(PKFieldName, APKValue, []);
    end;
  finally
    FDQuery.EnableControls;
  end;

end;

end.