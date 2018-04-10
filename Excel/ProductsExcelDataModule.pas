unit ProductsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, System.Generics.Collections, FieldInfoUnit, Data.DB;

type
  TProductsExcelTable = class(TCustomExcelTable)
  private
    function GetComponentGroup: TField;
    function GetLoadDate: TField;
    function GetPriceR: TField;
    function GetPriceD: TField;
    function GetPriceE: TField;
    function GetProducer: TField;
    function GetValue: TField;
  protected
    procedure CreateFieldDefs; override;
    procedure SetFieldsInfo; override;
  public
    function CheckRecord: Boolean; override;
    property ComponentGroup: TField read GetComponentGroup;
    property LoadDate: TField read GetLoadDate;
    property PriceR: TField read GetPriceR;
    property PriceD: TField read GetPriceD;
    property PriceE: TField read GetPriceE;
    property Producer: TField read GetProducer;
    property Value: TField read GetValue;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TProductsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TProductsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

function TProductsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TProductsExcelTable.Create(Self)
end;

function TProductsExcelDM.GetExcelTable: TProductsExcelTable;
begin
  Result := CustomExcelTable as TProductsExcelTable;
end;

function TProductsExcelTable.CheckRecord: Boolean;
var
  k: Integer;
  S: string;
begin
  Result := inherited;

  if not Result then
    Exit;

  // Проверяем цену в рублях
  if (not PriceR.IsNull) then
  begin
    S := PriceR.AsString.Replace('.', FormatSettings.DecimalSeparator);
    if StrToFloatDef(S, -1) = -1 then
    begin
      // Сигнализируем о неверном значении цены
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
        'Цена в рублях указана в неверном формате');
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
    if StrToFloatDef(S, -1) = -1 then
    begin
      // Сигнализируем о неверном значении цены
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceD.Index + 1, 'Денежное значение',
        'Цена в долларах указана в неверном формате');
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
    if StrToFloatDef(S, -1) = -1 then
    begin
      // Сигнализируем о неверном значении цены
      MarkAsError(etError);
      Errors.AddError(ExcelRow.AsInteger, PriceE.Index + 1, 'Денежное значение',
        'Цена в евро указана в неверном формате');
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

  // если закупочная цена вообще не указана
  if k = 0 then
  begin
    // Сигнализируем что цена не задана
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
      'Закупочная цена не указана');
  end;

  // если указана больше чем одна цена
  if k > 1 then
  begin
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
      'Указана больше чем одна закупочная цена');
  end;

end;

procedure TProductsExcelTable.CreateFieldDefs;
begin
  inherited;
  FieldDefs.Add('IDCurrency', ftInteger); // Обяз. для заполнения
end;

function TProductsExcelTable.GetComponentGroup: TField;
begin
  Result := FieldByName('ComponentGroup');
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
  FieldsInfo.Add(TFieldInfo.Create('Amount'));
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
