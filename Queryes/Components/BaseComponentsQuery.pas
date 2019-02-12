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
    function Exists(AParentProductID: Integer): Boolean;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DBRecordHolder, DefaultParameters;

{ TQueryComponentsBase }

constructor TQueryBaseComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
end;

procedure TQueryBaseComponents.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  if W.ID.F.AsInteger > 0 then
  begin
    // Удаляем сам дочерний компонент
    qProducts.DeleteRecord(W.ID.F.AsInteger);
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
  if qSearchComponent.SearchComponent(W.ParentProductID.F.AsInteger,
    W.Value.F.AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // Запоминаем сгенерированный первичный ключ
    FetchFields([W.PKFieldName], [qProducts.PKValue], ARequest, AAction,
      AOptions);
  end
  else
  begin
    // Если такой компонент уже есть
    // Запоминаем найденный первичный ключ
    FetchFields([W.PKFieldName], [qSearchComponent.W.PK.Value], ARequest,
      AAction, AOptions);
  end;

  Assert(W.PK.AsInteger > 0);

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

function TQueryBaseComponents.GetqSearchComponent
  : TQuerySearchComponentOrFamily;
begin
  if FqSearchComponent = nil then
    FqSearchComponent := TQuerySearchComponentOrFamily.Create(Self);
  Result := FqSearchComponent;
end;

function TQueryBaseComponents.Exists(AParentProductID: Integer): Boolean;
begin
  Result := (FDQuery.RecordCount > 0) and
    ((W.ParentProductID.F.AsInteger = AParentProductID) or
    not VarIsNull(FDQuery.LookupEx(W.ParentProductID.FieldName, AParentProductID,
    W.PKFieldName)));
end;

end.
