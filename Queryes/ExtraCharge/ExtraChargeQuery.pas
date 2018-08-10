unit ExtraChargeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ExtraChargeSimpleQuery,
  ExtraChargeExcelDataModule, ExtraChargeInterface;

type
  TQueryExtraCharge = class(TQueryWithDataSource, IExtraCharge)
  strict private
    function HaveDuplicate(const ARange: string): Boolean; stdcall;
  private
    FqExtraChargeSimple: TQueryExtraChargeSimple;
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
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    property qExtraChargeSimple: TQueryExtraChargeSimple
      read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteAll;
    procedure LoadDataFromExcelTable(AExcelTable: TExtraChargeExcelTable);
    function LocateByRange(ARange: string): Boolean;
    property Range: TField read GetRange;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  ProjectConst, NotifyEvents, ExceptionHelper;

{$R *.dfm}

constructor TQueryExtraCharge.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryExtraCharge.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Ищем удаляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  // Удаляем эту запись
  qExtraChargeSimple.FDQuery.Delete;
end;

procedure TQueryExtraCharge.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(0, Range.AsString,
    ALow, AHight);
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
  qExtraChargeSimple.TryPost;

  Assert(qExtraChargeSimple.PK.AsInteger > 0);

  FetchFields([PKFieldName], [qExtraChargeSimple.PK.Value], ARequest, AAction,
    AOptions);
end;

procedure TQueryExtraCharge.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  Assert(ASender = FDQuery);
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(PK.AsInteger,
    Range.AsString, ALow, AHight);
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
  qExtraChargeSimple.TryPost;
end;

procedure TQueryExtraCharge.DeleteAll;
begin
  FDQuery.DisableControls;
  try
    while not FDQuery.Eof do
      FDQuery.Delete;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryExtraCharge.DoAfterOpen(Sender: TObject);
begin
  Range.ReadOnly := False;
end;

procedure TQueryExtraCharge.DoBeforeOpen(Sender: TObject);
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

function TQueryExtraCharge.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

function TQueryExtraCharge.GetRange: TField;
begin
  Result := Field('Range');
end;

function TQueryExtraCharge.GetWholeSale: TField;
begin
  Result := Field('WholeSale');
end;

function TQueryExtraCharge.HaveDuplicate(const ARange: string): Boolean;
var
  V: Variant;
begin
  V := FDQuery.LookupEx(Range.FieldName, ARange, PKFieldName, [lxoCaseInsensitive]);
  Result := not VarIsNull(V);
end;

procedure TQueryExtraCharge.LoadDataFromExcelTable
  (AExcelTable: TExtraChargeExcelTable);
begin
  // FDQuery.DisableControls;
  try
    AExcelTable.First;
    while not AExcelTable.Eof do
    begin
      // Если такой диапазон уже есть
      if LocateByRange(AExcelTable.Range.Value) then
        TryEdit
      else
        TryAppend;

      Range.Value := AExcelTable.Range.Value;
      WholeSale.Value := AExcelTable.WholeSale.Value;
      TryPost;

      AExcelTable.Next;
    end;
  finally
    // FDQuery.EnableControls;
  end;
end;

function TQueryExtraCharge.LocateByRange(ARange: string): Boolean;
begin
  Result := FDQuery.LocateEx(Range.FieldName, ARange, []);
end;

end.
