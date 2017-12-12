unit ProductsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, System.Generics.Collections, FieldInfoUnit, Data.DB;

type
  TProductsExcelTable = class(TCustomExcelTable)
  private
    function GetComponentGroup: TField;
    function GetPriceR: TField;
    function GetPriceD: TField;
    function GetProducer: TField;
    function GetValue: TField;
  protected
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
      reintroduce;
    function CheckRecord: Boolean; override;
    property ComponentGroup: TField read GetComponentGroup;
    property PriceR: TField read GetPriceR;
    property PriceD: TField read GetPriceD;
    property Producer: TField read GetProducer;
    property Value: TField read GetValue;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TProductsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
      reintroduce; overload;
    property ExcelTable: TProductsExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

constructor TProductsExcelDM.Create(AOwner: TComponent;
  AFieldsInfo: TList<TFieldInfo>);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;

  Create(AOwner);
end;

function TProductsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TProductsExcelTable.Create(Self, FFieldsInfo)
end;

function TProductsExcelDM.GetExcelTable: TProductsExcelTable;
begin
  Result := CustomExcelTable as TProductsExcelTable;
end;

constructor TProductsExcelTable.Create(AOwner: TComponent;
  AFieldsInfo: TList<TFieldInfo>);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);

  if AFieldsInfo = nil then
    Exit;

  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);
end;

function TProductsExcelTable.CheckRecord: Boolean;
var
  S: string;
begin
  Result := inherited;

  if not Result then
    Exit;

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

  if PriceR.IsNull and PriceD.IsNull then
  begin
    // Сигнализируем что цена не задана
    MarkAsError(etError);
    Errors.AddError(ExcelRow.AsInteger, PriceR.Index + 1, 'Денежное значение',
      'Цена не указана');
  end;
end;

function TProductsExcelTable.GetComponentGroup: TField;
begin
  Result := FieldByName('ComponentGroup');
end;

function TProductsExcelTable.GetPriceR: TField;
begin
  Result := FieldByName('PriceR');
end;

function TProductsExcelTable.GetPriceD: TField;
begin
  Result := FieldByName('PriceD');
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
  FieldsInfo.Add(TFieldInfo.Create('YYYY'));
  FieldsInfo.Add(TFieldInfo.Create('MM'));
  FieldsInfo.Add(TFieldInfo.Create('WW'));
  FieldsInfo.Add(TFieldInfo.Create('Amount'));
  FieldsInfo.Add(TFieldInfo.Create('Packaging'));
  FieldsInfo.Add(TFieldInfo.Create('PriceR'));
  FieldsInfo.Add(TFieldInfo.Create('PriceD'));
  FieldsInfo.Add(TFieldInfo.Create('OriginCountryCode'));
  FieldsInfo.Add(TFieldInfo.Create('OriginCountry'));
  FieldsInfo.Add(TFieldInfo.Create('BatchNumber'));
  FieldsInfo.Add(TFieldInfo.Create('CustomsDeclarationNumber'));
  FieldsInfo.Add(TFieldInfo.Create('Storage'));
  FieldsInfo.Add(TFieldInfo.Create('StoragePlace'));
  FieldsInfo.Add(TFieldInfo.Create('Seller'));
  FieldsInfo.Add(TFieldInfo.Create('DocumentNumber'));
  FieldsInfo.Add(TFieldInfo.Create('Barcode'));
end;

end.
