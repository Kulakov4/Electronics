unit BodyTypesBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, BodiesQuery, BodyDataQuery,
  BodyVariationsQuery;

const
  WM_AFTER_CASCADE_DELETE = WM_USER + 574;

type
  TQueryBodyTypesBase = class(TQueryWithDataSource)
    fdqUnusedBodies: TFDQuery;
    fdqUnusedBodyData: TFDQuery;
  private
    FQueryBodies: TQueryBodies;
    FQueryBodyData: TQueryBodyData;
    FQueryBodyVariations: TQueryBodyVariations;
    FMessagePosted: Boolean;
    procedure DoAfterOpen(Sender: TObject);
    function GetBody: TField;
    function GetBodyData: TField;
    function GetIDBody: TField;
    function GetIDBodyData: TField;
    function GetIDBodyKind: TField;
    function GetIDProducer: TField;
    function GetIDS: TField;
    function GetImage: TField;
    function GetJEDEC: TField;
    function GetLandPattern: TField;
    function GetOption: TField;
    function GetOutlineDrawing: TField;
    function GetQueryBodies: TQueryBodies;
    function GetQueryBodyData: TQueryBodyData;
    function GetQueryBodyVariations: TQueryBodyVariations;
    function GetVariations: TField;
    { Private declarations }
  protected
    procedure DropUnusedBodies;
    procedure OnGetFileNameWithoutExtensionGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure ProcessAfterCascadeDeleteMessage(var Message: TMessage);
      message WM_AFTER_CASCADE_DELETE;
    procedure SetMySplitDataValues(AQuery: TFDQuery;
      const AFieldPrefix: String);
    property QueryBodies: TQueryBodies read GetQueryBodies;
    property QueryBodyData: TQueryBodyData read GetQueryBodyData;
    property QueryBodyVariations: TQueryBodyVariations
      read GetQueryBodyVariations;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CascadeDelete(const AIDMaster: Variant;
      const ADetailKeyFieldName: String;
      AFromClientOnly: Boolean = False); override;
    procedure RefreshLinkedData;
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
    property JEDEC: TField read GetJEDEC;
    property LandPattern: TField read GetLandPattern;
    property Option: TField read GetOption;
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

procedure TQueryBodyTypesBase.CascadeDelete(const AIDMaster: Variant;
  const ADetailKeyFieldName: String; AFromClientOnly: Boolean = False);
begin
  inherited;

  if not FMessagePosted then
  begin
    FMessagePosted := True;
    PostMessage(Handle, WM_AFTER_CASCADE_DELETE, 0, 0);
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

  // Подписываемся на событие об изменении значения поля
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

function TQueryBodyTypesBase.GetJEDEC: TField;
begin
  Result := Field('JEDEC');
end;

function TQueryBodyTypesBase.GetLandPattern: TField;
begin
  Result := Field('LandPattern');
end;

function TQueryBodyTypesBase.GetOption: TField;
begin
  Result := Field('Option');
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

procedure TQueryBodyTypesBase.OnGetFileNameWithoutExtensionGetText
  (Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TQueryBodyTypesBase.ProcessAfterCascadeDeleteMessage
  (var Message: TMessage);
begin
  inherited;

  // На сервере из этих таблиц каскадно удалились данные.
  // Обновим содержимое этих таблиц на клиенте

  RefreshLinkedData;
  FMessagePosted := False;
end;

procedure TQueryBodyTypesBase.RefreshLinkedData;
begin
  if FQueryBodies <> nil then
    FQueryBodies.RefreshQuery;

  if FQueryBodyData <> nil then
    FQueryBodyData.RefreshQuery;

  if FQueryBodyVariations <> nil then
    FQueryBodyVariations.RefreshQuery;
end;

procedure TQueryBodyTypesBase.SetMySplitDataValues(AQuery: TFDQuery;
  const AFieldPrefix: String);
var
  F: TField;
  i: Integer;
begin
  Assert(AQuery <> nil);
  Assert(FDQuery.State in [dsEdit, dsInsert]);
  Assert(AQuery.RecordCount > 0);
  Assert(not AFieldPrefix.IsEmpty);

  // Заполняем части наименования
  i := 0;
  F := AQuery.FindField(Format('%s%d', [AFieldPrefix, i]));
  while F <> nil do
  begin
    Field(F.FieldName).Value := F.Value;
    Inc(i);
    F := QueryBodies.FDQuery.FindField(Format('%s%d', [AFieldPrefix, i]));
  end;

end;

end.
