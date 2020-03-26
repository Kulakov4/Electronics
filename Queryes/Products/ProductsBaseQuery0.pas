unit ProductsBaseQuery0;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseEventsQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, DescriptionsQueryWrap, DSWrap,
  DocFieldInfo;

type
  TBaseProductsW = class(TDescriptionW)
  private
    FAmount: TFieldWrap;
    FDatasheet: TFieldWrap;
    FDiagram: TFieldWrap;
    FDrawing: TFieldWrap;
    FID: TFieldWrap;
    FImage: TFieldWrap;
    FIsGroup: TFieldWrap;
    FPriceD: TFieldWrap;
    FPriceD1: TFieldWrap;
    FPriceD2: TFieldWrap;
    FPriceE: TFieldWrap;
    FPriceE1: TFieldWrap;
    FPriceE2: TFieldWrap;
    FPriceR: TFieldWrap;
    FPriceR1: TFieldWrap;
    FPriceR2: TFieldWrap;
    procedure DoAfterOpen(Sender: TObject);
  protected
    procedure InitFields; virtual;
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    procedure SetDisplayFormat(const AFields: Array of TField);
    property Amount: TFieldWrap read FAmount;
    property Datasheet: TFieldWrap read FDatasheet;
    property Diagram: TFieldWrap read FDiagram;
    property Drawing: TFieldWrap read FDrawing;
    property ID: TFieldWrap read FID;
    property Image: TFieldWrap read FImage;
    property IsGroup: TFieldWrap read FIsGroup;
    property PriceD: TFieldWrap read FPriceD;
    property PriceD1: TFieldWrap read FPriceD1;
    property PriceD2: TFieldWrap read FPriceD2;
    property PriceE: TFieldWrap read FPriceE;
    property PriceE1: TFieldWrap read FPriceE1;
    property PriceE2: TFieldWrap read FPriceE2;
    property PriceR: TFieldWrap read FPriceR;
    property PriceR1: TFieldWrap read FPriceR1;
    property PriceR2: TFieldWrap read FPriceR2;
  end;

  TQryProductsBase0 = class(TQueryBaseEvents)
  private
  class var
    FDollarCource: Double;
    FEuroCource: Double;
    FOnDollarCourceChange: TNotifyEventsEx;
    FOnEuroCourceChange: TNotifyEventsEx;
  var
    FBPW: TBaseProductsW;
    class procedure SetDollarCource(const Value: Double); static;
    class procedure SetEuroCource(const Value: Double); static;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    property BPW: TBaseProductsW read FBPW;
    class property DollarCource: Double read FDollarCource write SetDollarCource;
    class property EuroCource: Double read FEuroCource write SetEuroCource;
    class property OnDollarCourceChange: TNotifyEventsEx read FOnDollarCourceChange;
    class property OnEuroCourceChange: TNotifyEventsEx read FOnEuroCourceChange;
    { Public declarations }
  end;

implementation

uses
  StrHelper, System.IOUtils;

{$R *.dfm}

constructor TQryProductsBase0.Create(AOwner: TComponent);
begin
  inherited;
  FBPW := Wrap as TBaseProductsW;

  if FOnDollarCourceChange = nil then
  begin
    FOnDollarCourceChange := TNotifyEventsEx.Create(Self);
    FOnEuroCourceChange := TNotifyEventsEx.Create(Self);
  end;

end;

function TQryProductsBase0.CreateDSWrap: TDSWrap;
begin
  Result := TBaseProductsW.Create(FDQuery);
end;

procedure TQryProductsBase0.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  OK: Boolean;
  S: String;
begin
  if AFileName.IsEmpty then
    Exit;

  // В БД храним путь до файла относительно папки с документацией
  S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
  OK := BPW.TryEdit;
  FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
  if OK then
    BPW.TryPost;
end;

class procedure TQryProductsBase0.SetDollarCource(const Value: Double);
begin
  if FDollarCource = Value then
    Exit;

  FDollarCource := Value;
  // Извещаем представления
  FOnDollarCourceChange.CallEventHandlers(nil);
end;

class procedure TQryProductsBase0.SetEuroCource(const Value: Double);
begin
  if FEuroCource = Value then
    Exit;

  FEuroCource := Value;
  // Извещаем представления
  FOnEuroCourceChange.CallEventHandlers(nil);
end;

constructor TBaseProductsW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIsGroup := TFieldWrap.Create(Self, 'IsGroup');
  FDatasheet := TFieldWrap.Create(Self, 'Datasheet');
  FDiagram := TFieldWrap.Create(Self, 'Diagram');
  FImage := TFieldWrap.Create(Self, 'Image');
  FDrawing := TFieldWrap.Create(Self, 'Drawing');
  FAmount := TFieldWrap.Create(Self, 'Amount');

  FPriceD := TFieldWrap.Create(Self, 'PriceD');
  FPriceD1 := TFieldWrap.Create(Self, 'PriceD1');
  FPriceD2 := TFieldWrap.Create(Self, 'PriceD2');
  FPriceE := TFieldWrap.Create(Self, 'PriceE');
  FPriceE1 := TFieldWrap.Create(Self, 'PriceE1');
  FPriceE2 := TFieldWrap.Create(Self, 'PriceE2');
  FPriceR := TFieldWrap.Create(Self, 'PriceR');
  FPriceR1 := TFieldWrap.Create(Self, 'PriceR1');
  FPriceR2 := TFieldWrap.Create(Self, 'PriceR2');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);
end;

procedure TBaseProductsW.AfterConstruction;
begin
  inherited;
  if DataSet.Active then
    InitFields;
end;

procedure TBaseProductsW.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  SetFieldsReadOnly(False);

  InitFields;
end;

procedure TBaseProductsW.InitFields;
begin
  Datasheet.F.OnGetText := OnDatasheetGetText;
  Diagram.F.OnGetText := OnDatasheetGetText;
  Drawing.F.OnGetText := OnDatasheetGetText;
  Image.F.OnGetText := OnDatasheetGetText;

  SetDisplayFormat([PriceR.F, PriceD.F, PriceE.F, PriceD1.F, PriceR1.F,
    PriceE1.F, PriceD2.F, PriceR2.F, PriceE2.F]);
end;

procedure TBaseProductsW.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TBaseProductsW.SetDisplayFormat(const AFields: Array of TField);
var
  I: Integer;
begin
  Assert(Length(AFields) > 0);

  for I := Low(AFields) to High(AFields) do
  begin
    // Если поле не TNumericField - значит запрос вернул 0 записей и не удалось определить тип поля
    if (AFields[I] is TNumericField) then
      (AFields[I] as TNumericField).DisplayFormat := '###,##0.00';
  end;
end;

end.
