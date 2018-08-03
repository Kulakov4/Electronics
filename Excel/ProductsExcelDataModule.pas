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
    function GetComponentGroup: TField;
    function GetDollar: TField;
    function GetEuro: TField;
    function GetLoadDate: TField;
    function GetPackagePins: TField;
    function GetReleaseDate: TField;
    function GetPriceR: TField;
    function GetPriceD: TField;
    function GetPriceE: TField;
    function GetProducer: TField;
    function GetAmount: TField;
    function GetPackaging: TField;
    function GetOriginCountryCode: TField;
    function GetOriginCountry: TField;
    function GetBatchNumber: TField;
    function GetCustomsDeclarationNumber: TField;
    function GetStorage: TField;
    function GetStoragePlace: TField;
    function GetSeller: TField;
    function GetDocumentNumber: TField;
    function GetBarcode: TField;
    function GetPrice: TField;
    function GetValue: TField;
  protected
    procedure SetFieldsInfo; override;
  public
    destructor Destroy; override;
    function CheckRecord: Boolean; override;
    property CheckDuplicate: ICheckDuplicate read FCheckDuplicate
      write FCheckDuplicate;
    property ComponentGroup: TField read GetComponentGroup;
    property Dollar: TField read GetDollar;
    property Euro: TField read GetEuro;
    property LoadDate: TField read GetLoadDate;
    property PackagePins: TField read GetPackagePins;
    property ReleaseDate: TField read GetReleaseDate;
    property PriceR: TField read GetPriceR;
    property PriceD: TField read GetPriceD;
    property PriceE: TField read GetPriceE;
    property Producer: TField read GetProducer;
    property Amount: TField read GetAmount;
    property Packaging: TField read GetPackaging;
    property OriginCountryCode: TField read GetOriginCountryCode;
    property OriginCountry: TField read GetOriginCountry;
    property BatchNumber: TField read GetBatchNumber;
    property CustomsDeclarationNumber: TField read GetCustomsDeclarationNumber;
    property Storage: TField read GetStorage;
    property StoragePlace: TField read GetStoragePlace;
    property Seller: TField read GetSeller;
    property DocumentNumber: TField read GetDocumentNumber;
    property Barcode: TField read GetBarcode;
    property CurrencyInt: ICurrency read FCurrencyInt write FCurrencyInt;
    property Price: TField read GetPrice;
    property Value: TField read GetValue;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TProductsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    destructor Destroy; override;
    property ExcelTable: TProductsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

destructor TProductsExcelDM.Destroy;
begin
;
  inherited;
end;

function TProductsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TProductsExcelTable.Create(Self)
end;

function TProductsExcelDM.GetExcelTable: TProductsExcelTable;
begin
  Result := CustomExcelTable as TProductsExcelTable;
end;

destructor TProductsExcelTable.Destroy;
begin
;
  inherited;
end;

function TProductsExcelTable.CheckRecord: Boolean;
var
  ADollar: Double;
  AEuro: Double;
  ALoadDate: TDateTime;
  FS: TFormatSettings;
  k: Integer;
  S: string;
  x: Integer;
begin
  Result := inherited;

  if not Result then
    Exit;

  // Проверяем цену в рублях
  if (not PriceR.IsNull) then
  begin
    S := PriceR.AsString.Replace('.', FormatSettings.DecimalSeparator);
    Result := StrToFloatDef(S, -1) <> -1;
    if not Result then
    begin
      // Сигнализируем о неверном значении цены
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
        'Цена в рублях указана в неверном формате');
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
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceD.Index + 1, 'Денежное значение',
        'Цена в долларах указана в неверном формате');
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
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceE.Index + 1, 'Денежное значение',
        'Цена в евро указана в неверном формате');
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
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
      'Закупочная цена не указана');
    Exit;
  end;

  // если указана больше чем одна цена
  if k > 1 then
  begin
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
      'Указана больше чем одна закупочная цена');
    Exit;
  end;

  // Если задана дата загрузки
  if not LoadDate.AsString.Trim.IsEmpty then
  begin
    // Если в Excel считали дату как целое число
    if TryStrToInt(LoadDate.AsString.Trim, x) then
    begin
      try
        ALoadDate := TDate(LoadDate.AsInteger);
        TryEdit;
        // Переводим дату в строку
        LoadDate.AsString := FormatDateTime('dd.mm.yyyy', Date);
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
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, LoadDate.Index + 1, 'Дата',
        'Поле дата имеет неверный формат');
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
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, Dollar.Index + 1,
        'Курс доллара неизвестен', 'Не удалось получить курс доллара');
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
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, Euro.Index + 1,
        'Курс евро неизвестен', 'Не удалось получить курс евро');
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
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, Amount.Index + 1, 'Неверный формат',
      'Количество должно быть числом');
    Exit;
  end;

  // Проверяем запись на дубликат
  Assert(Assigned(CheckDuplicate));
  Result := not CheckDuplicate.HaveDuplicate(Self);
  if not Result then
  begin
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, Value.Index + 1, 'Дубликат',
      'Этот компонент уже был загружен на склад ранее');
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

function TProductsExcelTable.GetPackagePins: TField;
begin
  Result := FieldByName('PackagePins');
end;

function TProductsExcelTable.GetReleaseDate: TField;
begin
  Result := FieldByName('ReleaseDate');
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

function TProductsExcelTable.GetPackaging: TField;
begin
  Result := FieldByName('Packaging');
end;

function TProductsExcelTable.GetOriginCountryCode: TField;
begin
  Result := FieldByName('OriginCountryCode');
end;

function TProductsExcelTable.GetOriginCountry: TField;
begin
  Result := FieldByName('OriginCountry');
end;

function TProductsExcelTable.GetBatchNumber: TField;
begin
  Result := FieldByName('BatchNumber');
end;

function TProductsExcelTable.GetCustomsDeclarationNumber: TField;
begin
  Result := FieldByName('CustomsDeclarationNumber');
end;

function TProductsExcelTable.GetStorage: TField;
begin
  Result := FieldByName('Storage');
end;

function TProductsExcelTable.GetStoragePlace: TField;
begin
  Result := FieldByName('StoragePlace');
end;

function TProductsExcelTable.GetSeller: TField;
begin
  Result := FieldByName('Seller');
end;

function TProductsExcelTable.GetDocumentNumber: TField;
begin
  Result := FieldByName('DocumentNumber');
end;

function TProductsExcelTable.GetBarcode: TField;
begin
  Result := FieldByName('Barcode');
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
begin
  if FieldsInfo.Count > 0 then
    Exit;

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
end;

end.
