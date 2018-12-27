unit ExtraChargeQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, ExtraChargeSimpleQuery,
  System.Generics.Collections;

type
  TQueryExtraCharge2 = class(TQueryWithDataSource)
  private
    FqExtraChargeSimple: TQueryExtraChargeSimple;
    procedure DoAfterOpen(Sender: TObject);
    function GetIDExtraChargeType: TField;
    function GetqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetRange: TField;
    function GetWholeSale: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure DoBeforeOpen(Sender: TObject);
    property qExtraChargeSimple: TQueryExtraChargeSimple
      read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FilterByType(AIDExtraRangeType: Integer);
    function GetWholeSaleList: TArray<String>;
    function LocateByRange(AIDExtraRangeType: Integer; ARange: string): Boolean;
    function LookupByRange(AIDExtraRangeType: Integer;
      const ARange: string): Variant;
    property IDExtraChargeType: TField read GetIDExtraChargeType;
    property Range: TField read GetRange;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  ExceptionHelper;

{$R *.dfm}

constructor TQueryExtraCharge2.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryExtraCharge2.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Ищем удаляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  // Удаляем эту запись
  qExtraChargeSimple.FDQuery.Delete;
end;

procedure TQueryExtraCharge2.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(PK.AsInteger,
    IDExtraChargeType.Value, Range.AsString, ALow, AHight);

  if not MyExceptionMessage.IsEmpty then
  begin
    // Потом будет создана исключительная ситуация
    AAction := eaFail;
    raise Exception.Create(MyExceptionMessage);
    // Exit;
  end;

  if not qExtraChargeSimple.FDQuery.Active then
    qExtraChargeSimple.SearchByID(0);

  // Добавляем запись
  qExtraChargeSimple.TryAppend;
  qExtraChargeSimple.L.AsInteger := ALow;
  qExtraChargeSimple.H.AsInteger := AHight;
  qExtraChargeSimple.WholeSale.Value := WholeSale.Value;
  qExtraChargeSimple.IDExtraChargeType.Value := IDExtraChargeType.Value;
  qExtraChargeSimple.TryPost;

  Assert(qExtraChargeSimple.PK.AsInteger > 0);

  FetchFields([PKFieldName], [qExtraChargeSimple.PK.Value], ARequest, AAction,
    AOptions);
end;

procedure TQueryExtraCharge2.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  Assert(ASender = FDQuery);
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(PK.AsInteger,
    IDExtraChargeType.AsInteger, Range.AsString, ALow, AHight);

  if not MyExceptionMessage.IsEmpty then
  begin
    AAction := eaFail;
    // Потом будет создана исключительная ситуация
    raise Exception.Create(MyExceptionMessage);

    // Exit;
  end;

  // Ищем обновляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  qExtraChargeSimple.TryEdit;
  qExtraChargeSimple.L.Value := ALow;
  qExtraChargeSimple.H.Value := AHight;
  qExtraChargeSimple.WholeSale.Value := WholeSale.Value;
  qExtraChargeSimple.IDExtraChargeType.Value := IDExtraChargeType.Value;
  qExtraChargeSimple.TryPost;
end;

procedure TQueryExtraCharge2.DoAfterOpen(Sender: TObject);
begin
  PK.Visible := False;
  IDExtraChargeType.Visible := False;
  Range.DisplayLabel := 'Количество (шт.)';
  WholeSale.DisplayLabel := 'Оптовая наценка (%)';
end;

procedure TQueryExtraCharge2.DoBeforeOpen(Sender: TObject);
begin
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;

  FDQuery.FieldDefs.Update;
  FDQuery.FieldDefs.Find('Range').Size := 30;
  CreateDefaultFields(False);
end;

procedure TQueryExtraCharge2.FilterByType(AIDExtraRangeType: Integer);
begin
  FDQuery.Filter := Format('%s = %d', [IDExtraChargeType.FieldName,
    AIDExtraRangeType]);
  FDQuery.Filtered := True;
end;

function TQueryExtraCharge2.GetIDExtraChargeType: TField;
begin
  Result := Field('IDExtraChargeType');
end;

function TQueryExtraCharge2.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

function TQueryExtraCharge2.GetRange: TField;
begin
  Result := Field('Range');
end;

function TQueryExtraCharge2.GetWholeSale: TField;
begin
  Result := Field('WholeSale');
end;

function TQueryExtraCharge2.GetWholeSaleList: TArray<String>;
var
  L: TList<String>;
begin
  L := TList<String>.Create();
  try
    FDQuery.DisableControls;
    try
      FDQuery.First;
      while not FDQuery.Eof do
      begin
        L.Add(WholeSale.AsString);
        FDQuery.Next;
      end;
    finally
      FDQuery.EnableControls;
    end;
    FDQuery.First;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

function TQueryExtraCharge2.LocateByRange(AIDExtraRangeType: Integer;
  ARange: string): Boolean;
var
  AFieldNames: string;
begin
  AFieldNames := Format('%s;%s', [IDExtraChargeType.FieldName,
    Range.FieldName]);
  Result := FDQuery.LocateEx(AFieldNames,
    VarArrayOf([AIDExtraRangeType, ARange]), []);
end;

function TQueryExtraCharge2.LookupByRange(AIDExtraRangeType: Integer;
  const ARange: string): Variant;
var
  AFieldNames: string;
begin
  AFieldNames := Format('%s;%s', [IDExtraChargeType.FieldName,
    Range.FieldName]);
  Result := FDQuery.LookupEx(AFieldNames, VarArrayOf([AIDExtraRangeType, ARange]
    ), [lxoCaseInsensitive]);
end;

end.
