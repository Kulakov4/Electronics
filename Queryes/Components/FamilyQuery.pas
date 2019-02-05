unit FamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, {Sequence,} RepositoryDataModule,
  System.Generics.Collections, ExcelDataModule, SearchComponentCategoryQuery,
  CustomComponentsQuery, ApplyQueryFrame, BaseFamilyQuery, DSWrap;

type
  TFamilyW = class(TCustomComponentsW)
  protected
    procedure AddNewValue(const AValue, AProducer: string);
  public
    function LocateOrAppend(const AValue, AProducer: string): Boolean;
    function LocateValue(const AValue: string): Boolean;
  end;

  TQueryFamily = class(TQueryBaseFamily)
  private
    procedure DoAfterInsert(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetFamilyW: TFamilyW;
    { Private declarations }
  protected
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CheckRecord: String;
    function CreateDSWrap: TDSWrap; override;
    procedure DoAfterOpen(Sender: TObject);
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property FamilyW: TFamilyW read GetFamilyW;
    { Public declarations }
  end;

implementation

uses NotifyEvents, System.IOUtils, SettingsController, DBRecordHolder,
  ParameterValuesUnit;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryFamily.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vProductCategoryId';
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, W.EventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
end;

procedure TQueryFamily.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
begin
  inherited;
  Assert(ASender = FDQuery);

  // Если такого семейства ещё нет
  if PK.AsInteger <= 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // Запоминаем сгенерированный первичный ключ
    FetchFields([PK.FieldName], [qProducts.PKValue], ARequest, AAction,
      AOptions);

  end;

  Assert(PK.AsInteger > 0);

  // Обрабатываем значения параметров
  W.UpdateParamValue(PKFieldName);

  Assert(PK.AsInteger > 0);

  // Обновляем категории нашего компонента
  UpdateCategory(PK.AsInteger, W.SubGroup.F.AsString);

  inherited;
end;

function TQueryFamily.CheckRecord: String;
begin
  Result := '';

  if W.Value.F.AsString.Trim.IsEmpty then
  begin
    Result := 'Необходимо задать наименование';
    Exit;
  end;

  if W.Producer.F.IsNull then
  begin
    Result := 'Необходимо выбрать производителя';
    Exit;
  end;

  if W.SubGroup.F.AsString.Trim.IsEmpty then
  begin
    Result := 'Необходимо задать идентификатор категории';
    Exit;
  end;
end;

function TQueryFamily.CreateDSWrap: TDSWrap;
begin
  Result := TFamilyW.Create(FDQuery);
end;

procedure TQueryFamily.DoAfterInsert(Sender: TObject);
begin
  // Заполняем SubGroup внешним идентификатором текущей категории компонентов
  W.SubGroup.F.AsString := CategoryExternalID;
end;

procedure TQueryFamily.DoAfterOpen(Sender: TObject);
begin
  W.Datasheet.F.OnGetText := OnDatasheetGetText;
  W.Diagram.F.OnGetText := OnDatasheetGetText;
  W.Drawing.F.OnGetText := OnDatasheetGetText;
  W.Image.F.OnGetText := OnDatasheetGetText;
end;

procedure TQueryFamily.DoBeforePost(Sender: TObject);
var
  AErrorMessage: string;
begin
  // Если не происходит вставка новой записи
  if not(FDQuery.State in [dsInsert]) then
    Exit;

  // Проверяем запись на наличие ошибок
  AErrorMessage := CheckRecord;
  if not AErrorMessage.IsEmpty then
    raise Exception.Create(AErrorMessage);

  // Если такое семейство уже есть
  if qSearchFamily.SearchByValueAndProducer(W.Value.F.AsString,
    W.Producer.F.AsString) > 0 then
  begin
    // Запоминаем найденный первичный ключ
    PK.Value := qSearchFamily.PK.Value;

    // Заполняем поля из найденного семейства
    UpdateFields([W.IDProducer.F, W.IDDatasheet.F, W.Datasheet.F, W.IDDiagram.F,
      W.Diagram.F, W.IDDrawing.F, W.Drawing.F, W.IDImage.F, W.Image.F,
      W.DescriptionID.F, W.DescriptionComponentName.F, W.Description.F],
      [qSearchFamily.W.IDProducer.F.Value, qSearchFamily.W.IDDatasheet.F.Value,
      qSearchFamily.W.Datasheet.F.Value, qSearchFamily.W.IDDiagram.F.Value,
      qSearchFamily.W.Diagram.F.Value, qSearchFamily.W.IDDrawing.F.Value,
      qSearchFamily.W.Drawing.F.Value, qSearchFamily.W.IDImage.F.Value,
      qSearchFamily.W.Image.F.Value, qSearchFamily.W.DescriptionID.F.Value,
      qSearchFamily.W.DescriptionComponentName.F.Value,
      qSearchFamily.W.Description.F.Value], False);

    // Если семейство было найдено в другой категории
    if W.SubGroup.F.AsString <> qSearchFamily.W.SubGroup.F.AsString then
      W.SubGroup.F.AsString := CombineSubgroup(W.SubGroup.F.AsString,
        qSearchFamily.W.SubGroup.F.AsString);
  end;
end;

function TQueryFamily.GetFamilyW: TFamilyW;
begin
  Result := W as TFamilyW;
end;

procedure TQueryFamily.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

procedure TFamilyW.AddNewValue(const AValue, AProducer: string);
begin
  Assert(not AValue.Trim.IsEmpty);
  Assert(not AProducer.Trim.IsEmpty);
  TryAppend;
  Value.F.AsString := AValue;
  Producer.F.AsString := AProducer;
  TryPost;
end;

function TFamilyW.LocateOrAppend(const AValue, AProducer: string): Boolean;
begin
  // Ищем компонент по имени без учёта регистра
  Result := FDDataSet.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue, AProducer);

end;

function TFamilyW.LocateValue(const AValue: string): Boolean;
begin
  // Ищем компонент по имени без учёта регистра
  Result := FDDataSet.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
end;

end.
