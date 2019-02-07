unit BodyTypesBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, BodiesQuery, BodyDataQuery,
  BodyVariationsQuery, BodyOptionsQuery, BodyVariationJedecQuery,
  BodyVariationOptionQuery, JEDECQuery, DSWrap, BaseEventsQuery, NotifyEvents;

const
  WM_AFTER_CASCADE_DELETE = WM_USER + 574;

type
  TBodyTypeBaseW = class(TDSWrap)
  private
    FAfterCascadeDelete: TNotifyEventsEx;
    FBody: TFieldWrap;
    FBodyData: TFieldWrap;
    FIDBody: TFieldWrap;
    FIDBodyData: TFieldWrap;
    FIDBodyKind: TFieldWrap;
    FIDProducer: TFieldWrap;
    FIDS: TFieldWrap;
    FImage: TFieldWrap;
    FJEDEC: TFieldWrap;
    FLandPattern: TFieldWrap;
    FOptions: TFieldWrap;
    FOutlineDrawing: TFieldWrap;
    FVariations: TFieldWrap;
    procedure DoAfterOpen(Sender: TObject);
    procedure ProcessAfterCascadeDeleteMessage;
  protected
    procedure OnGetFileNameWithoutExtensionGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure WndProc(var Msg: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CascadeDelete(const AIDMaster: Variant;
      const ADetailKeyFieldName: String;
      AFromClientOnly: Boolean = False); override;
    property AfterCascadeDelete: TNotifyEventsEx read FAfterCascadeDelete;
    property Body: TFieldWrap read FBody;
    property BodyData: TFieldWrap read FBodyData;
    property IDBody: TFieldWrap read FIDBody;
    property IDBodyData: TFieldWrap read FIDBodyData;
    property IDBodyKind: TFieldWrap read FIDBodyKind;
    property IDProducer: TFieldWrap read FIDProducer;
    property IDS: TFieldWrap read FIDS;
    // TODO: LocateOrAppend
    // procedure LocateOrAppend(AIDParentBodyType: Integer;
    // const ABodyType1, ABodyType2, AOutlineDrawing, ALandPattern, AVariation,
    // AImage: string);
    property Image: TFieldWrap read FImage;
    property JEDEC: TFieldWrap read FJEDEC;
    property LandPattern: TFieldWrap read FLandPattern;
    property Options: TFieldWrap read FOptions;
    property OutlineDrawing: TFieldWrap read FOutlineDrawing;
    property Variations: TFieldWrap read FVariations;
  end;

  TQueryBodyTypesBase = class(TQueryBaseEvents)
    fdqUnusedBodies: TFDQuery;
    fdqUnusedBodyData: TFDQuery;
  private
    FQueryBodies: TQueryBodies;
    FQueryBodyData: TQueryBodyData;
    FQueryBodyVariations: TQueryBodyVariations;
    FqBodyOptions: TQueryBodyOptions;
    FqBodyVariationJedec: TQueryBodyVariationJedec;
    FqBodyVariationOption: TQueryBodyVariationOption;
    FqJedec: TQueryJEDEC;
    FW: TBodyTypeBaseW;
    procedure DoAfterCascadeDelete(Sender: TObject);
    function GetqBodyOptions: TQueryBodyOptions;
    function GetqBodyVariationJedec: TQueryBodyVariationJedec;
    function GetqBodyVariationOption: TQueryBodyVariationOption;
    function GetqJedec: TQueryJEDEC;
    function GetQueryBodies: TQueryBodies;
    function GetQueryBodyData: TQueryBodyData;
    function GetQueryBodyVariations: TQueryBodyVariations;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    procedure DropUnusedBodies;
    procedure SetMySplitDataValues(AQuery: TFDQuery;
      const AFieldPrefix: String);
    procedure UpdateJEDEC;
    procedure UpdateOptions;
    property qBodyOptions: TQueryBodyOptions read GetqBodyOptions;
    property qBodyVariationJedec: TQueryBodyVariationJedec
      read GetqBodyVariationJedec;
    property qBodyVariationOption: TQueryBodyVariationOption
      read GetqBodyVariationOption;
    property QueryBodies: TQueryBodies read GetQueryBodies;
    property QueryBodyData: TQueryBodyData read GetQueryBodyData;
    property QueryBodyVariations: TQueryBodyVariations
      read GetQueryBodyVariations;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshLinkedData;
    property qJedec: TQueryJEDEC read GetqJedec;
    property W: TBodyTypeBaseW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.IOUtils, System.Generics.Collections;

constructor TQueryBodyTypesBase.Create(AOwner: TComponent);
begin
  inherited;
  FPKFieldName := 'IDS';

  FW := FDSWrap as TBodyTypeBaseW;

  TNotifyEventWrap.Create(W.AfterCascadeDelete, DoAfterCascadeDelete, W.EventList);

  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  AutoTransaction := False;
end;

function TQueryBodyTypesBase.CreateDSWrap: TDSWrap;
begin
  Result := TBodyTypeBaseW.Create(FDQuery);
end;

procedure TQueryBodyTypesBase.DoAfterCascadeDelete(Sender: TObject);
begin
  // На сервере из этих таблиц каскадно удалились данные.
  // Обновим содержимое этих таблиц на клиенте

  RefreshLinkedData;
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
      QueryBodyData.W.LocateByPKAndDelete(fdqUnusedBodyData['ID']);
      fdqUnusedBodyData.Next;
    end;

    fdqUnusedBodies.Close;
    fdqUnusedBodies.Open();

    if fdqUnusedBodies.RecordCount = 0 then
      break;

    while not fdqUnusedBodies.Eof do
    begin
      QueryBodies.W.LocateByPKAndDelete(fdqUnusedBodies['ID']);
      fdqUnusedBodies.Next;
    end;

  end;
end;

function TQueryBodyTypesBase.GetqBodyOptions: TQueryBodyOptions;
begin
  if FqBodyOptions = nil then
  begin
    FqBodyOptions := TQueryBodyOptions.Create(Self);
    FqBodyOptions.FDQuery.Open;
  end;

  Result := FqBodyOptions;
end;

function TQueryBodyTypesBase.GetqBodyVariationJedec: TQueryBodyVariationJedec;
begin
  if FqBodyVariationJedec = nil then
  begin
    FqBodyVariationJedec := TQueryBodyVariationJedec.Create(Self);
  end;

  Result := FqBodyVariationJedec;
end;

function TQueryBodyTypesBase.GetqBodyVariationOption: TQueryBodyVariationOption;
begin
  if FqBodyVariationOption = nil then
    FqBodyVariationOption := TQueryBodyVariationOption.Create(Self);

  Result := FqBodyVariationOption;
end;

function TQueryBodyTypesBase.GetqJedec: TQueryJEDEC;
begin
  if FqJedec = nil then
  begin
    FqJedec := TQueryJEDEC.Create(Self);
    FqJedec.FDQuery.Open;
  end;

  Result := FqJedec;
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
    W.Field(F.FieldName).Value := F.Value;
    Inc(i);
    F := QueryBodies.FDQuery.FindField(Format('%s%d', [AFieldPrefix, i]));
  end;

end;

procedure TQueryBodyTypesBase.UpdateJEDEC;
var
  AJEDEC: string;
  i: Integer;
  JEDECArr: TArray<String>;
  JEDECIDList: TList<Integer>;
begin
  // Дополнительно обновляем список JEDEC
  JEDECIDList := TList<Integer>.Create;
  try
    JEDECArr := W.JEDEC.F.AsString.Split([';']);
    for i := Low(JEDECArr) to High(JEDECArr) do
    begin
      AJEDEC := JEDECArr[i].Trim;
      if AJEDEC.IsEmpty then
        Continue;

      qJedec.W.LocateOrAppend(AJEDEC);
      JEDECIDList.Add(qJedec.PK.AsInteger)
    end;

    // Обновляем JEDEC для текущего варианта корпуса
    qBodyVariationJedec.UpdateJEDEC(QueryBodyVariations.PK.AsInteger,
      JEDECIDList.ToArray);
  finally
    FreeAndNil(JEDECIDList);
  end;
end;

procedure TQueryBodyTypesBase.UpdateOptions;
var
  AOption: string;
  i: Integer;
  OptionArr: TArray<String>;
  OptionIDList: TList<Integer>;
begin
  // Дополнительно обновляем список вариантов (options)
  OptionIDList := TList<Integer>.Create;
  try
    OptionArr := W.Options.F.AsString.Split([';']);
    for i := Low(OptionArr) to High(OptionArr) do
    begin
      AOption := OptionArr[i].Trim;
      if AOption.IsEmpty then
        Continue;

      qBodyOptions.W.LocateOrAppend(AOption);
      OptionIDList.Add(qBodyOptions.PK.AsInteger)
    end;

    // Обновляем OPTIONS для текущего варианта корпуса
    qBodyVariationOption.UpdateOption(QueryBodyVariations.PK.AsInteger,
      OptionIDList.ToArray);
  finally
    FreeAndNil(OptionIDList);
  end;
end;

constructor TBodyTypeBaseW.Create(AOwner: TComponent);
begin
  inherited;
  FIDS := TFieldWrap.Create(Self, 'IDS', '', True);
  FBody := TFieldWrap.Create(Self, 'Body');
  FBodyData := TFieldWrap.Create(Self, 'BodyData');
  FIDBody := TFieldWrap.Create(Self, 'IDBody');
  FIDBodyData := TFieldWrap.Create(Self, 'IDBodyData');
  FIDBodyKind := TFieldWrap.Create(Self, 'IDBodyKind');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FImage := TFieldWrap.Create(Self, 'Image');
  FJEDEC := TFieldWrap.Create(Self, 'JEDEC');
  FLandPattern := TFieldWrap.Create(Self, 'LandPattern');
  FOptions := TFieldWrap.Create(Self, 'Options');
  FOutlineDrawing := TFieldWrap.Create(Self, 'OutlineDrawing');
  FVariations := TFieldWrap.Create(Self, 'Variations');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);

  // Создаём ещё одно событие
  FAfterCascadeDelete := TNotifyEventsEx.Create(Self);
  FNEList.Add(FAfterCascadeDelete);
end;

procedure TBodyTypeBaseW.CascadeDelete(const AIDMaster: Variant;
  const ADetailKeyFieldName: String; AFromClientOnly: Boolean = False);
begin
  inherited;

  if FPostedMessage.IndexOf(WM_AFTER_CASCADE_DELETE) < 0 then
  begin
    FPostedMessage.Add(WM_AFTER_CASCADE_DELETE);
    PostMessage(Handle, WM_AFTER_CASCADE_DELETE, 0, 0);
  end;
end;

procedure TBodyTypeBaseW.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  IDProducer.F.Required := True;
  Body.F.Required := True;
  BodyData.F.Required := True;
  OutlineDrawing.F.OnGetText := OnGetFileNameWithoutExtensionGetText;
  LandPattern.F.OnGetText := OnGetFileNameWithoutExtensionGetText;
  Image.F.OnGetText := OnGetFileNameWithoutExtensionGetText;
end;

procedure TBodyTypeBaseW.OnGetFileNameWithoutExtensionGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TBodyTypeBaseW.ProcessAfterCascadeDeleteMessage;
var
  i: Integer;
begin
  i := FPostedMessage.IndexOf(WM_AFTER_CASCADE_DELETE);
  Assert(i >= 0);
  // ещаем всех что каскадное обновление закончено
  FAfterCascadeDelete.CallEventHandlers(Self);
  FPostedMessage.Delete(i);
end;

procedure TBodyTypeBaseW.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_AFTER_CASCADE_DELETE:
      ProcessAfterCascadeDeleteMessage;
  else
    inherited;
  end;
end;

end.
