unit BodyVariationsJedecQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  BodyVariationJedecQuery, BaseEventsQuery, DSWrap;

type
  TBodyVariationsJedecW = class(TDSWrap)
  private
    FIDBodyVariation: TParamWrap;
    FIDJEDEC: TFieldWrap;
    FJEDEC: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadJEDEC(const AFileName: String);
    property IDBodyVariation: TParamWrap read FIDBodyVariation;
    property IDJEDEC: TFieldWrap read FIDJEDEC;
    property JEDEC: TFieldWrap read FJEDEC;
  end;

  TQueryBodyVariationsJedec = class(TQueryBaseEvents)
  private
    FIDBodyVariations: TArray<Integer>;
    FqBodyVariationJedec: TQueryBodyVariationJedec;
    FW: TBodyVariationsJedecW;
    function GetqBodyVariationJedec: TQueryBodyVariationJedec;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure DoAfterOpen(Sender: TObject);
    property qBodyVariationJedec: TQueryBodyVariationJedec
      read GetqBodyVariationJedec;
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByIDBodyVariations(AIDBodyVariations: string): Integer;
    property W: TBodyVariationsJedecW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections, System.IOUtils, NotifyEvents;

{$R *.dfm}

constructor TQueryBodyVariationsJedec.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBodyVariationsJedecW;

  // На сервер ничего сохранять не будем!
  FDQuery.OnUpdateRecord := W.FDQueryUpdateRecordOnClient;

  // Будем накапливать изменения, чтобы понять, есть-ли изменения
  FDQuery.CachedUpdates := True;
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
end;

procedure TQueryBodyVariationsJedec.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIDBodyVariation: Integer;
begin
  for AIDBodyVariation in FIDBodyVariations do
  begin
    qBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation,
      W.IDJEDEC.F.AsInteger, 1);
    qBodyVariationJedec.FDQuery.Delete;
  end;
end;

procedure TQueryBodyVariationsJedec.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIDBodyVariation: Integer;
begin
  Assert(ASender = FDQuery);

  for AIDBodyVariation in FIDBodyVariations do
  begin
    if not qBodyVariationJedec.FDQuery.Active then
      qBodyVariationJedec.SearchByIDBodyVariation(AIDBodyVariation);

    qBodyVariationJedec.W.TryAppend;
    qBodyVariationJedec.W.IDBodyVariation.F.Value := AIDBodyVariation;
    qBodyVariationJedec.W.IDJEDEC.F.Value := W.IDJEDEC.F.Value;
    qBodyVariationJedec.W.TryPost;
  end;
  FetchFields([W.IDJEDEC.FieldName], [W.IDJEDEC.F.Value], ARequest, AAction,
    AOptions);
end;

procedure TQueryBodyVariationsJedec.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIDBodyVariation: Integer;
begin
  Assert(ASender = FDQuery);

  for AIDBodyVariation in FIDBodyVariations do
  begin
    qBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation,
      W.IDJEDEC.F.OldValue, 1);
    qBodyVariationJedec.W.TryEdit;
    qBodyVariationJedec.W.IDJEDEC.F.Value := W.IDJEDEC.F.Value;
    qBodyVariationJedec.W.TryPost;
  end;
end;

function TQueryBodyVariationsJedec.CreateDSWrap: TDSWrap;
begin
  Result := TBodyVariationsJedecW.Create(FDQuery);
end;

procedure TQueryBodyVariationsJedec.DoAfterOpen(Sender: TObject);
begin
  W.SetFieldsReadOnly(False);
end;

function TQueryBodyVariationsJedec.GetqBodyVariationJedec
  : TQueryBodyVariationJedec;
begin
  if FqBodyVariationJedec = nil then
  begin
    FqBodyVariationJedec := TQueryBodyVariationJedec.Create(Self);
  end;

  Result := FqBodyVariationJedec;
end;

function TQueryBodyVariationsJedec.SearchByIDBodyVariations(AIDBodyVariations
  : string): Integer;
var
  AStipulation: string;
  I: Integer;
  L: TList<Integer>;
  m: TArray<String>;
begin
  Assert(not AIDBodyVariations.IsEmpty);

  m := AIDBodyVariations.Split([',']);
  L := TList<Integer>.Create;
  try
    for I := Low(m) to High(m) do
    begin
      L.Add(m[I].Trim.ToInteger);
    end;
    FIDBodyVariations := L.ToArray;
  finally
    FreeAndNil(L);
  end;

  AStipulation := Format('%s in (%s)', [W.IDBodyVariation.FieldName,
    AIDBodyVariations]);

  // Меняем в запросе условие
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  // Ищем
  W.RefreshQuery;

  Result := FDQuery.RecordCount;
end;

constructor TBodyVariationsJedecW.Create(AOwner: TComponent);
begin
  inherited;
  FIDJEDEC := TFieldWrap.Create(Self, 'IDJEDEC', '', True);
  FJEDEC := TFieldWrap.Create(Self, 'JEDEC');

  // Параметры SQL запроса
  FIDBodyVariation := TParamWrap.Create(Self, 'bvj.IDBodyVariation');
end;

procedure TBodyVariationsJedecW.LoadJEDEC(const AFileName: String);
var
  S: string;
begin
  Assert(not AFileName.IsEmpty);
  Assert(DataSet.RecordCount > 0);

  // В БД храним имя файла без расширения и всё
  S := TPath.GetFileNameWithoutExtension(AFileName);

  TryEdit;
  JEDEC.F.AsString := S;
  TryPost;
end;

end.
