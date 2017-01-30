unit CustomComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, NotifyEvents, SearchComponentCategoryQuery,
  SearchComponentCategoryQuery2, SearchCategoryQuery, SearchQuery,
  SearchProductParameterValuesQuery, System.Generics.Collections;

type
  TQueryCustomComponents = class(TfrmDataModule)
    qProducts: TfrmApplyQuery;
  private
    FParameterFields: TDictionary<Integer,String>;
    FQuerySearchProductParameterValues: TQuerySearchProductParameterValues;
    procedure DoAfterOpen(Sender: TObject);
    function GetDatasheet: TField;
    function GetPackagePins: TField;
    function GetParentProductID: TField;
    function GetProducer: TField;
    function GetDiagram: TField;
    function GetImage: TField;
    function GetDrawing: TField;
    function GetIDDatasheet: TField;
    function GetIDDiagram: TField;
    function GetIDDrawing: TField;
    function GetIDImage: TField;
    function GetIDPackagePins: TField;
    function GetIDProducer: TField;
    function GetQuerySearchProductParameterValues:
        TQuerySearchProductParameterValues;
    function GetSubGroup: TField;
    function GetValue: TField;
    procedure ProcessParamValue(AIDComponent: Integer; AIDProductUnionParameters:
        TField; const AValue: String; AIDParameter: Integer);
    { Private declarations }
  protected
    procedure UpdateParamValue(const AProductIDFieldName: string; ASender:
        TDataSet);
    property QuerySearchProductParameterValues: TQuerySearchProductParameterValues
        read GetQuerySearchProductParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CombineSubgroup(const ASubGroup1, ASubGroup2: String): String;
    procedure SetProducer(AIDComponent: Integer; const AProducer: String);
    procedure SetPackagePins(AIDComponent: Integer; APackagePins: string);
    property Datasheet: TField read GetDatasheet;
    property PackagePins: TField read GetPackagePins;
    property ParentProductID: TField read GetParentProductID;
    property Producer: TField read GetProducer;
    property Diagram: TField read GetDiagram;
    property Image: TField read GetImage;
    property Drawing: TField read GetDrawing;
    property IDDatasheet: TField read GetIDDatasheet;
    property IDDiagram: TField read GetIDDiagram;
    property IDDrawing: TField read GetIDDrawing;
    property IDImage: TField read GetIDImage;
    property IDPackagePins: TField read GetIDPackagePins;
    property IDProducer: TField read GetIDProducer;
    property ParameterFields: TDictionary<Integer,String> read FParameterFields;
    property SubGroup: TField read GetSubGroup;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, SearchMainParameterQuery, ProjectConst,
  ParameterValuesUnit;

constructor TQueryCustomComponents.Create(AOwner: TComponent);
begin
  inherited;

  // Список полей, которые являются параметрами
  FParameterFields := TDictionary<Integer,String>.Create;

  // Поле Producer (производитель)
  FParameterFields.Add(TParameterValues.ProducerParameterID, 'Producer');

  // Поле Package/Pins (Корпус/Кол-во выводов)
  FParameterFields.Add(TParameterValues.PackagePinsParameterID, 'PackagePins');

  // Поле Datasheet (техническая спецификация)
  FParameterFields.Add(TParameterValues.DatasheetParameterID, 'Datasheet');

  // Поле Diagram (структурная схема)
  FParameterFields.Add(TParameterValues.DiagramParameterID, 'Diagram');

  // Поле Drawing (чертёж)
  FParameterFields.Add(TParameterValues.DrawingParameterID, 'Drawing');

  // Поле Image (изображение)
  FParameterFields.Add(TParameterValues.ImageParameterID, 'Image');

  // Поле Description (описание)
  FParameterFields.Add(TParameterValues.DescriptionParameterID, 'Description');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // Будем сами управлять транзакцией
  AutoTransaction := false;

  // Будем сами обновлять запись
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
end;

destructor TQueryCustomComponents.Destroy;
begin
  inherited;
  FParameterFields.Free;
end;

function TQueryCustomComponents.CombineSubgroup(const ASubGroup1, ASubGroup2:
    String): String;
var
  m: TArray<String>;
  S: string;
  SS: string;
begin
  if ASubGroup2.IsEmpty then
  begin
    Result := ASubGroup1;
    Exit;
  end;

  if ASubGroup1.IsEmpty then
  begin
    Result := ASubGroup2;
    Exit;
  end;

  Result := String.Format(',%s,', [ASubGroup1.Trim([','])]);
  m := ASubGroup2.Split([',']);

  for S in m do
  begin
    SS := String.Format(',%s,', [S]);

    // Если в первой группе нет элемента из второй группы
    if Result.IndexOf(SS) = -1 then
      Result := Result + SS.TrimLeft([',']);
  end;
  Result := Result.Trim([',']);
end;

procedure TQueryCustomComponents.DoAfterOpen(Sender: TObject);
var
  AFieldName: string;
  F: TField;
begin
  // Проверяем что все поля, которые являются параметрами существуют
  for AFieldName in FParameterFields.Values do
  begin
    F := Field(AFieldName);
    Assert( F <> nil );
  end;
end;

function TQueryCustomComponents.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQueryCustomComponents.GetPackagePins: TField;
begin
  Result := Field('PackagePins');
end;

function TQueryCustomComponents.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQueryCustomComponents.GetProducer: TField;
begin
  Result := Field('Producer');
end;

function TQueryCustomComponents.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQueryCustomComponents.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryCustomComponents.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQueryCustomComponents.GetIDDatasheet: TField;
begin
  Result := Field('IDDatasheet');
end;

function TQueryCustomComponents.GetIDDiagram: TField;
begin
  Result := Field('IDDiagram');
end;

function TQueryCustomComponents.GetIDDrawing: TField;
begin
  Result := Field('IDDrawing');
end;

function TQueryCustomComponents.GetIDImage: TField;
begin
  Result := Field('IDImage');
end;

function TQueryCustomComponents.GetIDPackagePins: TField;
begin
  Result := Field('IDPackagePins');
end;

function TQueryCustomComponents.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryCustomComponents.GetQuerySearchProductParameterValues:
    TQuerySearchProductParameterValues;
begin
  if FQuerySearchProductParameterValues = nil then
  begin
    FQuerySearchProductParameterValues :=
      TQuerySearchProductParameterValues.Create(Self);
  end;
  Result := FQuerySearchProductParameterValues;
end;

function TQueryCustomComponents.GetSubGroup: TField;
begin
  Result := Field('SubGroup');
end;

function TQueryCustomComponents.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryCustomComponents.ProcessParamValue(AIDComponent: Integer;
    AIDProductUnionParameters: TField; const AValue: String; AIDParameter:
    Integer);
var
  rc: Integer;
begin
  Assert(AIDParameter > 0);

  // Ищем значение производителя для нашего компонента
  rc := QuerySearchProductParameterValues.Search(AIDParameter, AIDComponent);

  // Если новое значение производителя пустое
  if AValue.IsEmpty then
  begin
    // Удаляем все значения выбранного параметра связанные с нашим компонентом
    while not QuerySearchProductParameterValues.FDQuery.Eof do
      QuerySearchProductParameterValues.FDQuery.Delete;

    AIDProductUnionParameters.Value := NULL;
  end
  else
  begin

    // Старого значение не существует
    if rc = 0 then
    begin
      // Добавляем новое значение
      QuerySearchProductParameterValues.AppendValue(AValue);
    end
    else
    begin
      // Если старое значение не равно новому
      QuerySearchProductParameterValues.EditValue(AValue);

      // Удаляем "лишние" записи
      while QuerySearchProductParameterValues.FDQuery.RecordCount > 1 do
      begin
        QuerySearchProductParameterValues.FDQuery.Last;
        QuerySearchProductParameterValues.FDQuery.Delete;
      end;

    end;

    Assert(QuerySearchProductParameterValues.FDQuery.RecordCount = 1);
    Assert(QuerySearchProductParameterValues.ID.AsInteger > 0);

    AIDProductUnionParameters.Value :=
      QuerySearchProductParameterValues.ID.Value;
  end;
end;

procedure TQueryCustomComponents.SetProducer(AIDComponent: Integer; const
    AProducer: String);
var
  OK: Boolean;
begin
  Assert(AIDComponent > 0);

  // Ищем нужный компонент
  OK := LocateByPK(AIDComponent);
  Assert(OK);

  // Редактируем его
  TryEdit;
  Producer.AsString := AProducer;
  TryPost;
end;

procedure TQueryCustomComponents.SetPackagePins(AIDComponent: Integer;
    APackagePins: string);
var
  OK: Boolean;
begin
  Assert(AIDComponent > 0);

  // Ищем нужный компонент
  OK := LocateByPK(AIDComponent);
  Assert(OK);

  // Редактируем его
  TryEdit;
  PackagePins.AsString := APackagePins;
  TryPost;
end;

procedure TQueryCustomComponents.UpdateParamValue(const AProductIDFieldName:
    string; ASender: TDataSet);
var
  ADatasheet: TField;
  ADiagram: TField;
  ADrawing: TField;
  AIDDatasheet: TField;
  AIDDiagram: TField;
  AIDDrawing: TField;
  AIDImage: TField;
  AIDPackagePins: TField;
  AIDProducer: TField;
  AImage: TField;
  APackagePins: TField;
  AIDComponent: TField;
  AProducer: TField;
begin
  Assert(not AProductIDFieldName.IsEmpty);
  Assert(ASender <> nil);
  AIDComponent := ASender.FieldByName(AProductIDFieldName);
  AIDProducer := ASender.FieldByName(IDProducer.FieldName);
  AIDPackagePins := ASender.FieldByName(IDPackagePins.FieldName);
  AProducer := ASender.FieldByName(Producer.FieldName);
  APackagePins := ASender.FieldByName(PackagePins.FieldName);
  AIDDatasheet := ASender.FieldByName(IDDatasheet.FieldName);
  ADatasheet := ASender.FieldByName(Datasheet.FieldName);
  AIDDiagram := ASender.FieldByName(IDDiagram.FieldName);
  ADiagram := ASender.FieldByName(Diagram.FieldName);
  AIDDrawing := ASender.FieldByName(IDDrawing.FieldName);
  ADrawing := ASender.FieldByName(Drawing.FieldName);
  AIDImage := ASender.FieldByName(IDImage.FieldName);
  AImage := ASender.FieldByName(Image.FieldName);

  // Обрабатываем производителя
  ProcessParamValue(AIDComponent.AsInteger, AIDProducer, AProducer.AsString,
    TParameterValues.ProducerParameterID);

  // Обрабатываем корпус
  ProcessParamValue(AIDComponent.AsInteger, AIDPackagePins, APackagePins.AsString,
    TParameterValues.PackagePinsParameterID);

  // Обрабатываем спецификацию
  ProcessParamValue(AIDComponent.AsInteger, AIDDatasheet, ADatasheet.AsString,
    TParameterValues.DatasheetParameterID);

  // Обрабатываем структурную схему
  ProcessParamValue(AIDComponent.AsInteger, AIDDiagram, ADiagram.AsString,
    TParameterValues.DiagramParameterID);

  // Обрабатываем чертёж
  ProcessParamValue(AIDComponent.AsInteger, AIDDrawing, ADrawing.AsString,
    TParameterValues.DrawingParameterID);

  // Обрабатываем изображение
  ProcessParamValue(AIDComponent.AsInteger, AIDImage, AImage.AsString,
    TParameterValues.ImageParameterID);

end;

end.
