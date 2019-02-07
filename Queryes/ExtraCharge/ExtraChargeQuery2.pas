unit ExtraChargeQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, ExtraChargeSimpleQuery,
  System.Generics.Collections, DSWrap, BaseEventsQuery;

type
  TExtraChargeW = class(TDSWrap)
  private
    FIDExtraChargeType: TFieldWrap;
    FID: TFieldWrap;
    FRange: TFieldWrap;
    FWholeSale: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FilterByType(AIDExtraRangeType: Integer);
    function GetWholeSaleList: TArray<String>;
    function LocateByRange(AIDExtraRangeType: Integer; ARange: string): Boolean;
    function LookupByRange(AIDExtraRangeType: Integer;
      const ARange: string): Variant;
    property IDExtraChargeType: TFieldWrap read FIDExtraChargeType;
    property ID: TFieldWrap read FID;
    property Range: TFieldWrap read FRange;
    property WholeSale: TFieldWrap read FWholeSale;
  end;

  TQueryExtraCharge2 = class(TQueryBaseEvents)
  private
    FqExtraChargeSimple: TQueryExtraChargeSimple;
    FW: TExtraChargeW;
    function GetqExtraChargeSimple: TQueryExtraChargeSimple;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoBeforeOpen(Sender: TObject);
    property qExtraChargeSimple: TQueryExtraChargeSimple
      read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TExtraChargeW read FW;
    { Public declarations }
  end;

implementation

uses
  ExceptionHelper;

{$R *.dfm}

constructor TQueryExtraCharge2.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TExtraChargeW;
  AutoTransaction := False;
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
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
    W.IDExtraChargeType.F.Value, W.Range.F.AsString, ALow, AHight);

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
  qExtraChargeSimple.W.TryAppend;
  qExtraChargeSimple.W.L.F.AsInteger := ALow;
  qExtraChargeSimple.W.H.F.AsInteger := AHight;
  qExtraChargeSimple.W.WholeSale.F.Value := W.WholeSale.F.Value;
  qExtraChargeSimple.W.IDExtraChargeType.F.Value := W.IDExtraChargeType.F.Value;
  qExtraChargeSimple.W.TryPost;

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
    W.IDExtraChargeType.F.AsInteger, W.Range.F.AsString, ALow, AHight);

  if not MyExceptionMessage.IsEmpty then
  begin
    AAction := eaFail;
    // Потом будет создана исключительная ситуация
    raise Exception.Create(MyExceptionMessage);

    // Exit;
  end;

  // Ищем обновляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  qExtraChargeSimple.W.TryEdit;
  qExtraChargeSimple.W.L.F.Value := ALow;
  qExtraChargeSimple.W.H.F.Value := AHight;
  qExtraChargeSimple.W.WholeSale.F.Value := W.WholeSale.F.Value;
  qExtraChargeSimple.W.IDExtraChargeType.F.Value := W.IDExtraChargeType.F.Value;
  qExtraChargeSimple.W.TryPost;
end;

function TQueryExtraCharge2.CreateDSWrap: TDSWrap;
begin
  Result := TExtraChargeW.Create(FDQuery);
end;

procedure TQueryExtraCharge2.DoBeforeOpen(Sender: TObject);
begin
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;

  FDQuery.FieldDefs.Update;
  FDQuery.FieldDefs.Find(W.Range.FieldName).Size := 30;
  W.CreateDefaultFields(False);
end;

function TQueryExtraCharge2.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

constructor TExtraChargeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIDExtraChargeType := TFieldWrap.Create(Self, 'IDExtraChargeType');
  FRange := TFieldWrap.Create(Self, 'Range', 'Количество (шт.)');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale', 'Оптовая наценка (%)');
end;

procedure TExtraChargeW.FilterByType(AIDExtraRangeType: Integer);
begin
  DataSet.Filter := Format('%s = %d', [IDExtraChargeType.FieldName,
    AIDExtraRangeType]);
  DataSet.Filtered := True;
end;

function TExtraChargeW.GetWholeSaleList: TArray<String>;
var
  L: TList<String>;
begin
  L := TList<String>.Create();
  try
    DataSet.DisableControls;
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        L.Add(WholeSale.F.AsString);
        DataSet.Next;
      end;
    finally
      DataSet.EnableControls;
    end;
    DataSet.First;
    Result := L.ToArray;
  finally
    FreeAndNil(L);
  end;
end;

function TExtraChargeW.LocateByRange(AIDExtraRangeType: Integer;
  ARange: string): Boolean;
var
  AFieldNames: string;
begin
  AFieldNames := Format('%s;%s', [IDExtraChargeType.FieldName,
    Range.FieldName]);
  Result := FDDataSet.LocateEx(AFieldNames,
    VarArrayOf([AIDExtraRangeType, ARange]), []);
end;

function TExtraChargeW.LookupByRange(AIDExtraRangeType: Integer;
  const ARange: string): Variant;
var
  AFieldNames: string;
begin
  AFieldNames := Format('%s;%s', [IDExtraChargeType.FieldName,
    Range.FieldName]);
  Result := FDDataSet.LookupEx(AFieldNames,
    VarArrayOf([AIDExtraRangeType, ARange]), [lxoCaseInsensitive]);
end;

end.
