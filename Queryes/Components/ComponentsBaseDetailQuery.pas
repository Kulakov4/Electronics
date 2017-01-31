unit ComponentsBaseDetailQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, CustomComponentsQuery, ApplyQueryFrame,
  SearchDetailComponentQuery;

type
  TQueryComponentsBaseDetail = class(TQueryCustomComponents)
  private
    FClone: TFDMemTable;
    FQuerySearchDetailComponent: TQuerySearchDetailComponent;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetQuerySearchDetailComponent: TQuerySearchDetailComponent;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QuerySearchDetailComponent: TQuerySearchDetailComponent read
        GetQuerySearchDetailComponent;
  public
    constructor Create(AOwner: TComponent); override;
    function Exists(AMasterID: Integer): Boolean;
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, ParameterValuesUnit;

{ TQueryComponentsBase }

constructor TQueryComponentsBaseDetail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
  FClone := TFDMemTable.Create(Self);
end;

procedure TQueryComponentsBaseDetail.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
begin
  AID := ASender.FieldByName(PKFieldName).AsInteger;
  if AID > 0 then
  begin
    // Удаляем сам дочерний компонент
    qProducts.DeleteRecord(AID);
  end;

  inherited;
end;

procedure TQueryComponentsBaseDetail.ApplyInsert(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin

  // Если такого компонента ещё нет
  if QuerySearchDetailComponent.Search
    (ASender.FieldByName(ParentProductID.FieldName).AsInteger,
    ASender.FieldByName(Value.FieldName).AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // Запоминаем сгенерированный первичный ключ
    ASender.FieldByName(PKFieldName).AsInteger := qProducts.PKValue;
  end
  else
  begin
    // Если такой компонент уже есть
    // Запоминаем найденный первичный ключ
    ASender.FieldByName(PKFieldName).AsInteger :=
      QuerySearchDetailComponent.ID.AsInteger;
  end;

  Assert(ASender.FieldByName(PKFieldName).AsInteger > 0);

  inherited;
end;

procedure TQueryComponentsBaseDetail.ApplyUpdate(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin
  ARH := TRecordHolder.Create(ASender);
  try
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryComponentsBaseDetail.DoAfterClose(Sender: TObject);
begin
  FClone.Close;
end;

procedure TQueryComponentsBaseDetail.DoAfterOpen(Sender: TObject);
var
  AFDIndex: TFDIndex;
begin
  FClone.CloneCursor(FDQuery);
  // Создаём индекс
  AFDIndex := FClone.Indexes.Add;
  AFDIndex.Fields := 'ParentProductID';
  AFDIndex.Name := 'idxParentProductID';
  AFDIndex.Active := True;
  FClone.IndexName := AFDIndex.Name;
end;

procedure TQueryComponentsBaseDetail.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
{
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;
}
  FDQuery.ParamByName('PackagePinsParameterID').AsInteger :=
    TParameterValues.PackagePinsParameterID;
{
  FDQuery.ParamByName('DatasheetParameterID').AsInteger :=
    TParameterValues.DatasheetParameterID;

  FDQuery.ParamByName('DiagramParameterID').AsInteger :=
    TParameterValues.DiagramParameterID;

  FDQuery.ParamByName('DrawingParameterID').AsInteger :=
    TParameterValues.DrawingParameterID;

  FDQuery.ParamByName('ImageParameterID').AsInteger :=
    TParameterValues.ImageParameterID;
}
end;

function TQueryComponentsBaseDetail.Exists(AMasterID: Integer): Boolean;
var
  V: Variant;
begin
  if FClone.Active then
  begin
    V := FClone.LookupEx('ParentProductID', AMasterID, 'ID');
    Result := not VarIsNull( V );
  end
  else
    Result := False;
end;

function TQueryComponentsBaseDetail.GetQuerySearchDetailComponent:
    TQuerySearchDetailComponent;
begin
  if FQuerySearchDetailComponent = nil then
    FQuerySearchDetailComponent := TQuerySearchDetailComponent.Create(Self);
  Result := FQuerySearchDetailComponent;
end;

end.
