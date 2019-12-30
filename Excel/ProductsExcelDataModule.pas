unit ProductsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, System.Generics.Collections, FieldInfoUnit, Data.DB,
  FireDAC.Comp.DataSet, CheckDuplicateInterface, CurrencyInterface;

type
  TProductsExcelTable = class(TCustomExcelTable)
  private
    FCheckDuplicate: ICheckDuplicate;
    FCurrencyInt: ICurrency;
    FFieldsInfoArr: TArray<TFieldInfoEx>;
    function GetComponentGroup: TField;
    function GetDollar: TField;
    function GetEuro: TField;
    function GetLoadDate: TField;
    function GetPriceR: TField;
    function GetPriceD: TField;
    function GetPriceE: TField;
    function GetProducer: TField;
    function GetAmount: TField;
    function GetPrice: TField;
    function GetValue: TField;
  protected
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent;
      AFieldsInfoArr: TArray<TFieldInfoEx>); reintroduce;
    destructor Destroy; override;
    function CheckRecord: Boolean; override;
    property CheckDuplicate: ICheckDuplicate read FCheckDuplicate
      write FCheckDuplicate;
    property ComponentGroup: TField read GetComponentGroup;
    property Dollar: TField read GetDollar;
    property Euro: TField read GetEuro;
    property LoadDate: TField read GetLoadDate;
    property PriceR: TField read GetPriceR;
    property PriceD: TField read GetPriceD;
    property PriceE: TField read GetPriceE;
    property Producer: TField read GetProducer;
    property Amount: TField read GetAmount;
    property CurrencyInt: ICurrency read FCurrencyInt write FCurrencyInt;
    property Price: TField read GetPrice;
    property Value: TField read GetValue;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    FFieldsInfoArr: TArray<TFieldInfoEx>;
    function GetExcelTable: TProductsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    destructor Destroy; override;
    procedure Init(AFieldsInfoArr: TArray<TFieldInfoEx>);
    property ExcelTable: TProductsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses
  ErrorType, RecordCheck;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

destructor TProductsExcelDM.Destroy;
begin;
  inherited;
end;

function TProductsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  if (FFieldsInfoArr <> nil) and (Length(FFieldsInfoArr) > 0) then
    Result := TProductsExcelTable.Create(Self, FFieldsInfoArr)
  else
    Result := nil;
end;

function TProductsExcelDM.GetExcelTable: TProductsExcelTable;
begin
  Result := CustomExcelTable as TProductsExcelTable;
end;

procedure TProductsExcelDM.Init(AFieldsInfoArr: TArray<TFieldInfoEx>);
begin
  FFieldsInfoArr := AFieldsInfoArr;
  TryCreateExcelTable;
end;

constructor TProductsExcelTable.Create(AOwner: TComponent;
  AFieldsInfoArr: TArray<TFieldInfoEx>);
begin
  inherited Create(AOwner);
  FFieldsInfoArr := AFieldsInfoArr;
end;

destructor TProductsExcelTable.Destroy;
begin;
  inherited;
end;

function TProductsExcelTable.CheckRecord: Boolean;
var
  ADollar: Double;
  AEuro: Double;
  ALoadDate: TDateTime;
  ARecordCheck: TRecordCheck;
  FS: TFormatSettings;
  k: Integer;
  S: string;
  x: Integer;
begin
  Result := inherited;

  if not Result then
    Exit;

  ARecordCheck.ErrorType := etError;
  ARecordCheck.Row := ExcelRow.AsInteger;

  // Проверяем цену в рублях
  if (not PriceR.IsNull) then
  begin
    S := PriceR.AsString.Replace('.', FormatSettings.DecimalSeparator);
    Result := StrToFloatDef(S, -1) <> -1;
    if not Result then
    begin
      // Сигнализируем о неверном значении цены
      ARecordCheck.Col := PriceR.Index + 1;
      ARecordCheck.ErrorMessage := 'Денежное значение';
      ARecordCheck.Description := 'Цена в рублях указана в неверном формате';
      ProcessErrors(ARecordCheck);
      Exit;
    end
    else
    begin
      if S <> PriceR.AsString then
      begin
        Edit;
        PriceR.AsString := S;
        Post;
      end;
    end;
  end;

  // Проверяем цену в долларах
  if (not PriceD.IsNull) then
  begin
    S := PriceD.AsString.Replace('.', FormatSettings.DecimalSeparator);
    Result := StrToFloatDef(S, -1) <> -1;
    if not Result then
    begin
      // Сигнализируем о неверном значении цены
      ARecordCheck.Col := PriceD.Index + 1;
      ARecordCheck.ErrorMessage := 'Денежное значение';
      ARecordCheck.Description := 'Цена в долларах указана в неверном формате';
      ProcessErrors(ARecordCheck);
      Exit;
    end
    else
    begin
      if S <> PriceD.AsString then
      begin
        Edit;
        PriceD.AsString := S;
        Post;
      end;
    end;
  end;

  // Проверяем цену в евро
  if (not PriceE.IsNull) then
  begin
    S := PriceE.AsString.Replace('.', FormatSettings.DecimalSeparator);
    Result := StrToFloatDef(S, -1) <> -1;
    if not Result then
    begin
      // Сигнализируем о неверном значении цены
      ARecordCheck.Col := PriceE.Index + 1;
      ARecordCheck.ErrorMessage := 'Денежное значение';
      ARecordCheck.Description := 'Цена в евро указана в неверном формате';
      ProcessErrors(ARecordCheck);
      Exit;
    end
    else
    begin
      if S <> PriceE.AsString then
      begin
        Edit;
        PriceE.AsString := S;
        Post;
      end;
    end;
  end;

  k := 0;
  if not PriceR.IsNull then
    Inc(k);

  if not PriceD.IsNull then
    Inc(k);

  if not PriceE.IsNull then
    Inc(k);

  // Только одна закупочная цена должна быть указана
  Result := k = 1;

  // если закупочная цена вообще не указана
  if k = 0 then
  begin
    // Сигнализируем что цена не задана
    ARecordCheck.Col := PriceR.Index + 1;
    ARecordCheck.ErrorMessage := 'Денежное значение';
    ARecordCheck.Description := 'Закупочная цена не указана';
    ProcessErrors(ARecordCheck);
    Exit;
  end;

  // если указана больше чем одна цена
  if k > 1 then
  begin
    ARecordCheck.Col := PriceR.Index + 1;
    ARecordCheck.ErrorMessage := 'Денежное значение';
    ARecordCheck.Description := 'Указана больше чем одна закупочная цена';
    ProcessErrors(ARecordCheck);
    Exit;
  end;

  // Если задана дата загрузки
  if not LoadDate.AsString.Trim.IsEmpty then
  begin
    // Если в Excel считали дату как целое число
    if TryStrToInt(LoadDate.AsString.Trim, x) then
    begin
      try
        ALoadDate := TDate(x);
        TryEdit;
        // Переводим дату в строку
        LoadDate.AsString := FormatDateTime('dd.mm.yyyy', ALoadDate);
        TryPost;
      except
        Result := False;
      end;
    end
    else
    begin
      // Пытаемся преобразовать строку в дату
      FS.ShortDateFormat := 'dd.mm.yyyy';
      FS.DateSeparator := '.';
      Result := TryStrToDate(LoadDate.AsString, ALoadDate, FS);
    end;

    // Если дата не в том формате
    if not Result then
    begin
      ARecordCheck.Col := LoadDate.Index + 1;
      ARecordCheck.ErrorMessage := 'Дата';
      ARecordCheck.Description := 'Поле дата имеет неверный формат';
      ProcessErrors(ARecordCheck);
      Exit;
    end;
  end
  else
  begin
    // Если дата не заполнена
    ALoadDate := Date;
    TryEdit;
    LoadDate.AsString := FormatDateTime('dd.mm.yyyy', Date);
    TryPost;
  end;

  Assert(CurrencyInt <> nil);

  // Должен быть указан курс доллара или известен курс на нужную нам дату
  if Dollar.IsNull then
  begin
    ADollar := 0;
    try
      // Пытаемся получить курс доллара
      ADollar := CurrencyInt.GetCourses(2, ALoadDate);
    except
      Result := False;
    end;

    // Если курс доллара получить не удалось
    if (not Result) or (ADollar = 0) then
    begin
      ARecordCheck.Col := Dollar.Index + 1;
      ARecordCheck.ErrorMessage := 'Курс доллара неизвестен';
      ARecordCheck.Description := 'Не удалось получить курс доллара';
      ProcessErrors(ARecordCheck);
      Exit;
    end;

    TryEdit;
    Dollar.AsFloat := ADollar;
    TryPost;
  end;

  // Должен быть указан курс евро или известен курс на нужную нам дату
  if Euro.IsNull then
  begin
    AEuro := 0;
    try
      // Пытаемся получить курс евро
      AEuro := CurrencyInt.GetCourses(3, ALoadDate);
    except
      Result := False;
    end;

    // Если курс Евро получить не удалось
    if (not Result) or (AEuro = 0) then
    begin
      ARecordCheck.Col := Euro.Index + 1;
      ARecordCheck.ErrorMessage := 'Курс евро неизвестен';
      ARecordCheck.Description := 'Не удалось получить курс евро';
      ProcessErrors(ARecordCheck);
      Exit;
    end;

    TryEdit;
    Euro.AsFloat := AEuro;
    TryPost;
  end;

  // Проверяем, что количество - целое число
  Result := StrToFloatDef(Amount.AsString, -1) <> -1;
  if not Result then
  begin
    // Сигнализируем о неверном значении количества
    ARecordCheck.Col := Amount.Index + 1;
    ARecordCheck.ErrorMessage := 'Неверный формат';
    ARecordCheck.Description := 'Количество должно быть числом';
    ProcessErrors(ARecordCheck);
    Exit;
  end;

  // Проверяем запись на дубликат
  Assert(Assigned(CheckDuplicate));
  Result := not CheckDuplicate.HaveDuplicate(Self);
  if not Result then
  begin
    ARecordCheck.Col := Value.Index + 1;
    ARecordCheck.ErrorMessage := 'Дубликат';
    ARecordCheck.Description :=
      'Этот компонент уже был загружен на склад ранее';
    ProcessErrors(ARecordCheck);
    Exit;
  end;
end;

function TProductsExcelTable.GetComponentGroup: TField;
begin
  Result := FieldByName('ComponentGroup');
end;

function TProductsExcelTable.GetDollar: TField;
begin
  Result := FieldByName('Dollar');
end;

function TProductsExcelTable.GetEuro: TField;
begin
  Result := FieldByName('Euro');
end;

function TProductsExcelTable.GetLoadDate: TField;
begin
  Result := FieldByName('LoadDate');
end;

function TProductsExcelTable.GetPriceR: TField;
begin
  Result := FieldByName('PriceR');
end;

function TProductsExcelTable.GetPriceD: TField;
begin
  Result := FieldByName('PriceD');
end;

function TProductsExcelTable.GetPriceE: TField;
begin
  Result := FieldByName('PriceE');
end;

function TProductsExcelTable.GetProducer: TField;
begin
  Result := FieldByName('Producer');
end;

function TProductsExcelTable.GetAmount: TField;
begin
  Result := FieldByName('Amount');
end;

function TProductsExcelTable.GetPrice: TField;
begin
  Result := nil;

  if not PriceR.IsNull then
  begin
    Assert(PriceD.IsNull and PriceE.IsNull);
    Result := PriceR;
    Exit;
  end;

  if not PriceD.IsNull then
  begin
    Assert(PriceR.IsNull and PriceE.IsNull);
    Result := PriceD;
    Exit;
  end;

  if not PriceE.IsNull then
  begin
    Assert(PriceR.IsNull and PriceD.IsNull);
    Result := PriceE;
    Exit;
  end;
end;

function TProductsExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

procedure TProductsExcelTable.SetFieldsInfo;
var
  AFI: TFieldInfoEx;
begin
  if FieldsInfo.Count > 0 then
    Exit;

  for AFI in FFieldsInfoArr do
  begin
    if AFI.Exist then
      FieldsInfo.Add(TFieldInfo.Create(AFI.FieldName, AFI.Required,
        AFI.ErrorMessage, AFI.IsCellUnion, AFI.Size));
  end;
(*
  FieldsInfo.Add(TFieldInfo.Create('ComponentGroup', True,
    'Группа компонентов не задана', True));
  FieldsInfo.Add(TFieldInfo.Create('Value', True, 'Наименование не задано'));
  FieldsInfo.Add(TFieldInfo.Create('Producer', True, 'Производитель не задан'));
  FieldsInfo.Add(TFieldInfo.Create('PackagePins'));
  FieldsInfo.Add(TFieldInfo.Create('ReleaseDate'));
  FieldsInfo.Add(TFieldInfo.Create('Amount', True, 'Количество не задано'));
  FieldsInfo.Add(TFieldInfo.Create('Packaging'));
  FieldsInfo.Add(TFieldInfo.Create('PriceR'));
  FieldsInfo.Add(TFieldInfo.Create('PriceD'));
  FieldsInfo.Add(TFieldInfo.Create('PriceE'));
  FieldsInfo.Add(TFieldInfo.Create('OriginCountryCode'));
  FieldsInfo.Add(TFieldInfo.Create('OriginCountry'));
  FieldsInfo.Add(TFieldInfo.Create('BatchNumber'));
  FieldsInfo.Add(TFieldInfo.Create('CustomsDeclarationNumber'));
  FieldsInfo.Add(TFieldInfo.Create('Storage'));
  FieldsInfo.Add(TFieldInfo.Create('StoragePlace'));
  FieldsInfo.Add(TFieldInfo.Create('Seller'));
  FieldsInfo.Add(TFieldInfo.Create('DocumentNumber'));
  FieldsInfo.Add(TFieldInfo.Create('Barcode'));
  FieldsInfo.Add(TFieldInfo.Create('LoadDate'));
  FieldsInfo.Add(TFieldInfo.Create('Dollar'));
  FieldsInfo.Add(TFieldInfo.Create('Euro'));
*)
end;

end.
