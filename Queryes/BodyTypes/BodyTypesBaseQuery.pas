unit BodyTypesBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, BodiesQuery, BodyDataQuery,
  BodyVariationsQuery;

type
  TQueryBodyTypesBase = class(TQueryWithDataSource)
    fdqUnusedBodies: TFDQuery;
    fdqUnusedBodyData: TFDQuery;
    procedure FDQueryUpdateRecordOnClient(ASender: TDataSet; ARequest:
        TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
        TFDUpdateRowOptions);
  private
    FQueryBodies: TQueryBodies;
    FQueryBodyData: TQueryBodyData;
    FQueryBodyVariations: TQueryBodyVariations;
    procedure DoAfterOpen(Sender: TObject);
    function GetBody: TField;
    function GetBodyData: TField;
    function GetIDBody: TField;
    function GetIDBodyData: TField;
    function GetIDBodyKind: TField;
    function GetIDProducer: TField;
    function GetIDS: TField;
    function GetImage: TField;
    function GetLandPattern: TField;
    function GetOutlineDrawing: TField;
    function GetQueryBodies: TQueryBodies;
    function GetQueryBodyData: TQueryBodyData;
    function GetQueryBodyVariations: TQueryBodyVariations;
    function GetVariations: TField;
    { Private declarations }
  protected
    procedure DropUnusedBodies;
    procedure OnGetFileNameWithoutExtensionGetText(Sender: TField; var Text:
        String; DisplayText: Boolean);
    property QueryBodies: TQueryBodies read GetQueryBodies;
    property QueryBodyData: TQueryBodyData read GetQueryBodyData;
    property QueryBodyVariations: TQueryBodyVariations read GetQueryBodyVariations;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CascadeDelete(const AIDMaster: Integer; const ADetailKeyFieldName:
        String); overload; override;
    property Body: TField read GetBody;
    property BodyData: TField read GetBodyData;
    property IDBody: TField read GetIDBody;
    property IDBodyData: TField read GetIDBodyData;
    property IDBodyKind: TField read GetIDBodyKind;
    property IDProducer: TField read GetIDProducer;
    property IDS: TField read GetIDS;
    // TODO: LocateOrAppend
    // procedure LocateOrAppend(AIDParentBodyType: Integer;
    // const ABodyType1, ABodyType2, AOutlineDrawing, ALandPattern, AVariation,
    // AImage: string);
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property Variations: TField read GetVariations;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.IOUtils;

constructor TQueryBodyTypesBase.Create(AOwner: TComponent);
begin
  inherited;
  FPKFieldName := 'IDS';
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  AutoTransaction := False;
end;

procedure TQueryBodyTypesBase.CascadeDelete(const AIDMaster: Integer; const
    ADetailKeyFieldName: String);
var
  E: TFDUpdateRecordEvent;
begin
  // каскадное удаление уже реализовано на стороне сервера
  // ѕросто удалим эти записи с клиента ничего не сохран€€ на стороне сервера

  E := FDQuery.OnUpdateRecord;
  try
    FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;
    inherited;
  finally
    FDQuery.OnUpdateRecord := E;
  end;
end;

procedure TQueryBodyTypesBase.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  IDProducer.Required := True;
  Body.Required := True;
  BodyData.Required := True;
  OutlineDrawing.OnGetText := OnGetFileNameWithoutExtensionGetText;
  LandPattern.OnGetText := OnGetFileNameWithoutExtensionGetText;
  Image.OnGetText := OnGetFileNameWithoutExtensionGetText;

  // ѕодписываемс€ на событие об изменении значени€ пол€
  // BodyType1.OnChange := FDQueryBodyType1Change;
  // BodyType2.OnChange := FDQueryBodyType2Change;
end;

procedure TQueryBodyTypesBase.DropUnusedBodies;
begin
  while True do
  begin
    fdqUnusedBodyData.Close;
    fdqUnusedBodyData.Open;

    if fdqUnusedBodyData.RecordCount = 0 then
      break;

    while not fdqUnusedBodyData.Eof do
    begin
      QueryBodyData.LocateByPKAndDelete(fdqUnusedBodyData['ID']);
      fdqUnusedBodyData.Next;
    end;

    fdqUnusedBodies.Close;
    fdqUnusedBodies.Open();

    if fdqUnusedBodies.RecordCount = 0 then
      break;

    while not fdqUnusedBodies.Eof do
    begin
      QueryBodies.LocateByPKAndDelete(fdqUnusedBodies['ID']);
      fdqUnusedBodies.Next;
    end;

  end;
end;

procedure TQueryBodyTypesBase.FDQueryUpdateRecordOnClient(ASender: TDataSet;
    ARequest: TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TQueryBodyTypesBase.GetBody: TField;
begin
  Result := Field('Body');
end;

function TQueryBodyTypesBase.GetBodyData: TField;
begin
  Result := Field('BodyData');
end;

function TQueryBodyTypesBase.GetIDBody: TField;
begin
  Result := Field('IDBody');
end;

function TQueryBodyTypesBase.GetIDBodyData: TField;
begin
  Result := Field('IDBodyData');
end;

function TQueryBodyTypesBase.GetIDBodyKind: TField;
begin
  Result := Field('IDBodyKind');
end;

function TQueryBodyTypesBase.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryBodyTypesBase.GetIDS: TField;
begin
  Result := Field('IDS');
end;

function TQueryBodyTypesBase.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryBodyTypesBase.GetLandPattern: TField;
begin
  Result := Field('LandPattern');
end;

function TQueryBodyTypesBase.GetOutlineDrawing: TField;
begin
  Result := Field('OutlineDrawing');
end;

function TQueryBodyTypesBase.GetQueryBodies: TQueryBodies;
begin
  if FQueryBodies = nil then
  begin
    FQueryBodies := TQueryBodies.Create(Self);
    FQueryBodies.FDQuery.Open();
  end;
  Result := FQueryBodies;
end;

function TQueryBodyTypesBase.GetQueryBodyData: TQueryBodyData;
begin
  if FQueryBodyData = nil then
  begin
    FQueryBodyData := TQueryBodyData.Create(Self);
    FQueryBodyData.FDQuery.Open;
  end;

  Result := FQueryBodyData;
end;

function TQueryBodyTypesBase.GetQueryBodyVariations: TQueryBodyVariations;
begin
  if FQueryBodyVariations = nil then
  begin
    FQueryBodyVariations := TQueryBodyVariations.Create(Self);
    FQueryBodyVariations.FDQuery.Open;
  end;
  Result := FQueryBodyVariations;
end;

function TQueryBodyTypesBase.GetVariations: TField;
begin
  Result := Field('Variations');
end;

procedure TQueryBodyTypesBase.OnGetFileNameWithoutExtensionGetText(Sender:
    TField; var Text: String; DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

end.
