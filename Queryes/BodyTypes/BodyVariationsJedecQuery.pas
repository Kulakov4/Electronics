unit BodyVariationsJedecQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  BodyVariationJedecQuery, BaseEventsQuery;

type
  TQueryBodyVariationsJedec = class(TQueryBaseEvents)
  private
    FIDBodyVariations: TArray<Integer>;
    FqBodyVariationJedec: TQueryBodyVariationJedec;
    function GetIDJEDEC: TField;
    function GetqBodyVariationJedec: TQueryBodyVariationJedec;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property qBodyVariationJedec: TQueryBodyVariationJedec
      read GetqBodyVariationJedec;
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByIDBodyVariations(AIDBodyVariations: string): Integer;
    property IDJEDEC: TField read GetIDJEDEC;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.Generics.Collections;

{$R *.dfm}

constructor TQueryBodyVariationsJedec.Create(AOwner: TComponent);
begin
  inherited;
  // На сервер ничего сохранять не будем!
  FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;

  FPKFieldName := 'IDJEDEC';

end;

procedure TQueryBodyVariationsJedec.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AIDBodyVariation: Integer;
begin
  for AIDBodyVariation in FIDBodyVariations do
  begin
    qBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation, IDJEDEC.AsInteger, 1);
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

    qBodyVariationJedec.TryAppend;
    qBodyVariationJedec.IDBodyVariation.Value := AIDBodyVariation;
    qBodyVariationJedec.IDJEDEC.Value := IDJEDEC.Value;
    qBodyVariationJedec.TryPost;
  end;
  FetchFields(['IDJEDEC'], [IDJEDEC.Value], ARequest, AAction, AOptions);
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
    qBodyVariationJedec.SearchByIDJEDEC(AIDBodyVariation, IDJEDEC.OldValue, 1);
    qBodyVariationJedec.TryEdit;
    qBodyVariationJedec.IDJEDEC.Value := IDJEDEC.Value;
    qBodyVariationJedec.TryPost;
  end;
end;

function TQueryBodyVariationsJedec.GetIDJEDEC: TField;
begin
  Result := Field('IDJEDEC');
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

  // Меняем в запросе условие
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('where IDBodyVariation in (%s)', [AIDBodyVariations]), 'where');

  // Ищем
  RefreshQuery;
end;

end.
