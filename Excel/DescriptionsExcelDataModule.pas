unit DescriptionsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, CustomExcelTable,
  ProducerInterface, DescriptionsInterface;

{$WARN SYMBOL_PLATFORM OFF}

type
  TDescriptionsExcelTable = class(TCustomExcelTable)
  private
    FClone: TFDMemTable;
    FDescriptionsInt: IDescriptions;
    FProducerInt: IProducer;
    procedure Do_AfterOpen(Sender: TDataSet);
    function GetComponentName: TField;
    function GetComponentType: TField;
    function GetDescription: TField;
    function GetIDProducer: TField;
    function GetProducer: TField;
  protected
    function CheckDescription: Boolean;
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckRecord: Boolean; override;
    property ComponentName: TField read GetComponentName;
    property ComponentType: TField read GetComponentType;
    property Description: TField read GetDescription;
    property DescriptionsInt: IDescriptions read FDescriptionsInt
      write FDescriptionsInt;
    property IDProducer: TField read GetIDProducer;
    property Producer: TField read GetProducer;
    property ProducerInt: IProducer read FProducerInt write FProducerInt;
  end;

  TDescriptionsExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TDescriptionsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TDescriptionsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

uses System.Math, System.Variants, FieldInfoUnit, ProgressInfo, ErrorType,
  RecordCheck;

{$R *.dfm}

constructor TDescriptionsExcelTable.Create(AOwner: TComponent);
begin
  inherited;
  AfterOpen := Do_AfterOpen;
end;

destructor TDescriptionsExcelTable.Destroy;
begin
  FreeAndNil(FClone);
  inherited;
end;

function TDescriptionsExcelTable.CheckDescription: Boolean;
var
  AProducerID: Integer;
  ARecordCheck: TRecordCheck;
  OK: Boolean;
  rc: TRecordCheck;
begin
  Assert(ProducerInt <> nil);
  Assert(DescriptionsInt <> nil);

  ARecordCheck.ErrorType := etError;
  ARecordCheck.Row := ExcelRow.AsInteger;

  // Ищем производителя
  AProducerID := ProducerInt.GetProducerID(Producer.Value);
  Result := AProducerID > 0;

  // Если не нашли
  if not Result then
  begin
    ARecordCheck.Col := Producer.Index + 1;
    ARecordCheck.ErrorMessage := Producer.AsString;
    ARecordCheck.Description :=
      'Производитель с таким наименованием не найден в справочнике производителей';
    ProcessErrors(ARecordCheck);
    Exit;
  end;

  // Запоминаем код производителя
  Edit;
  IDProducer.Value := AProducerID;
  Post;

  // А может быть в Excel файле это уже встречалось ранее?
  OK := FClone.LocateEx(ComponentName.FieldName, ComponentName.Value,
    [lxoCaseInsensitive]);
  Assert(OK); // Хотя бы один раз встречаться должно
  Result := FClone.RecNo = RecNo;
  // Если в Excel файле это встречается один раз

  if not Result then
  begin
    // Если в Excel файле это встречается несколько раз
    if FClone.FieldByName(Description.FieldName).AsString = Description.AsString
    then
    begin
      ARecordCheck.Description :=
        'Такое описание уже есть в загружаемых данных';
    end
    else
    begin
      ARecordCheck.ErrorType := etWarring;
      ARecordCheck.Description :=
        'Компонент с таким наименованием уже встречался в загружаемых данных';
    end;
    ARecordCheck.Col := ComponentName.Index + 1;
    ARecordCheck.ErrorMessage := ComponentName.AsString;
    ProcessErrors(ARecordCheck);
    Exit;
  end;

  // Продолжаем проверку

  rc := DescriptionsInt.Check(ComponentName.Value, Description.Value,
    IDProducer.Value);

  if rc.ErrorType = etNone then
    Exit;

  rc.Row := ExcelRow.AsInteger;
  rc.Col := ComponentName.Index + 1;
  ProcessErrors(rc);
end;

function TDescriptionsExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    Result := CheckDescription;
  end;
end;

procedure TDescriptionsExcelTable.CreateFieldDefs;
begin
  inherited;
  // при проверке будем заполнять код производителя
  FieldDefs.Add('IDProducer', ftInteger);
end;

procedure TDescriptionsExcelTable.Do_AfterOpen(Sender: TDataSet);
begin
  Assert(FClone = nil);
  FClone := TFDMemTable.Create(Self);
  FClone.CloneCursor(Self);
end;

function TDescriptionsExcelTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TDescriptionsExcelTable.GetComponentType: TField;
begin
  Result := FieldByName('ComponentType');
end;

function TDescriptionsExcelTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TDescriptionsExcelTable.GetIDProducer: TField;
begin
  Result := FieldByName('IDProducer');
end;

function TDescriptionsExcelTable.GetProducer: TField;
begin
  Result := FieldByName('Producer');
end;

procedure TDescriptionsExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ComponentName', True,
    'Наименование компонента не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Producer', True,
    'Наименование производителя не должно быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Description', True,
    'Описание компонента не должно быть пустым', '', False, 3000));
  FieldsInfo.Add(TFieldInfo.Create('ComponentType', True,
    'Тип компонента не должен быть пустым'));
end;

function TDescriptionsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TDescriptionsExcelTable.Create(Self);
end;

function TDescriptionsExcelDM.GetExcelTable: TDescriptionsExcelTable;
begin
  Result := CustomExcelTable as TDescriptionsExcelTable;
end;

end.
