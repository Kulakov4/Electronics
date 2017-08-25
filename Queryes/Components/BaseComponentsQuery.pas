unit BaseComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, CustomComponentsQuery, ApplyQueryFrame,
  SearchComponentOrFamilyQuery;

type
  TQueryBaseComponents = class(TQueryCustomComponents)
  private
    FClone: TFDMemTable;
    FqSearchComponent: TQuerySearchComponentOrFamily;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetqSearchComponent: TQuerySearchComponentOrFamily;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property qSearchComponent: TQuerySearchComponentOrFamily read
        GetqSearchComponent;
  public
    constructor Create(AOwner: TComponent); override;
    function Exists(AMasterID: Integer): Boolean;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, ParameterValuesUnit;

{ TQueryComponentsBase }

constructor TQueryBaseComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
  FClone := TFDMemTable.Create(Self);
end;

procedure TQueryBaseComponents.ApplyDelete(ASender: TDataSet);
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

procedure TQueryBaseComponents.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
begin
  // Если такого компонента ещё нет
  if qSearchComponent.SearchComponen
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
    ASender.FieldByName(PKFieldName).Value := qSearchComponent.PK.Value;
  end;

  Assert(ASender.FieldByName(PKFieldName).AsInteger > 0);

  inherited;
end;

procedure TQueryBaseComponents.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
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

procedure TQueryBaseComponents.DoAfterClose(Sender: TObject);
begin
  FClone.Close;
end;

procedure TQueryBaseComponents.DoAfterOpen(Sender: TObject);
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

procedure TQueryBaseComponents.DoBeforeOpen(Sender: TObject);
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

function TQueryBaseComponents.Exists(AMasterID: Integer): Boolean;
var
  V: Variant;
begin
  if FClone.Active then
  begin
    V := FClone.LookupEx('ParentProductID', AMasterID, 'ID');
    Result := not VarIsNull(V);
  end
  else
    Result := False;
end;

function TQueryBaseComponents.GetqSearchComponent:
    TQuerySearchComponentOrFamily;
begin
  if FqSearchComponent = nil then
    FqSearchComponent := TQuerySearchComponentOrFamily.Create(Self);
  Result := FqSearchComponent;
end;

end.
