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
    procedure DoBeforeOpen(Sender: TObject);
    function GetqSearchComponent: TQuerySearchComponentOrFamily;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property qSearchComponent: TQuerySearchComponentOrFamily
      read GetqSearchComponent;
  public
    constructor Create(AOwner: TComponent); override;
    function Exists(AMasterID: Integer): Boolean;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, DefaultParameters;

{ TQueryComponentsBase }

constructor TQueryBaseComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryBaseComponents.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
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
  Assert(ASender = FDQuery);
  // Если такого компонента ещё нет
  if qSearchComponent.SearchComponent(ParentProductID.AsInteger,
    Value.AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // Запоминаем сгенерированный первичный ключ
    FetchFields([PK.FieldName], [qProducts.PKValue], ARequest, AAction,
      AOptions);
    // ASender.FieldByName(PKFieldName).AsInteger := qProducts.PKValue;
  end
  else
  begin
    // Если такой компонент уже есть
    // Запоминаем найденный первичный ключ
    FetchFields([PK.FieldName], [qSearchComponent.PK.Value], ARequest, AAction,
      AOptions);
    // ASender.FieldByName(PKFieldName).Value := qSearchComponent.PK.Value;
  end;

  Assert(PK.AsInteger > 0);

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

procedure TQueryBaseComponents.DoBeforeOpen(Sender: TObject);
begin
  FDQuery.ParamByName('PackagePinsParamSubParamID').AsInteger :=
    TDefaultParameters.PackagePinsParamSubParamID;
end;

function TQueryBaseComponents.Exists(AMasterID: Integer): Boolean;
var
  V: Variant;
  AFDIndex: TFDIndex;
begin
  Result := False;

  if (not FDQuery.Active) or (FDQuery.RecordCount = 0) then
    Exit;

  if FClone = nil then
  begin
    FClone := AddClone('');
    // Создаём индекс
    AFDIndex := FClone.Indexes.Add;
    AFDIndex.Fields := 'ParentProductID';
    AFDIndex.Name := 'idxParentProductID';
    AFDIndex.Active := True;
    FClone.IndexName := AFDIndex.Name;
  end;

  if not FClone.Active then
    Exit;

//  Assert(FClone.Active);
  V := FClone.LookupEx(ParentProductID.FieldName, AMasterID, PKFieldName );
  Result := not VarIsNull(V);
end;

function TQueryBaseComponents.GetqSearchComponent
  : TQuerySearchComponentOrFamily;
begin
  if FqSearchComponent = nil then
    FqSearchComponent := TQuerySearchComponentOrFamily.Create(Self);
  Result := FqSearchComponent;
end;

end.
