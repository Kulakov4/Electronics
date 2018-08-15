unit ProducersExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  CustomExcelTable, ProducerInterface;

{$WARN SYMBOL_PLATFORM OFF}

type
  TProducersExcelTable = class(TCustomExcelTable)
  private
    FProducerInt: IProducer;
    function GetName: TField;
    function GetProducerType: TField;
  protected
    function CheckProducer: Boolean;
    procedure SetFieldsInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckRecord: Boolean; override;
    property Name: TField read GetName;
    property ProducerInt: IProducer read FProducerInt write FProducerInt;
    property ProducerType: TField read GetProducerType;
  end;

  TProducersExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TProducersExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TProducersExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses System.Variants, System.Math, FieldInfoUnit, ProgressInfo, ErrorType,
  RecordCheck;

constructor TProducersExcelTable.Create(AOwner: TComponent);
begin
  inherited;
end;

function TProducersExcelTable.CheckProducer: Boolean;
var
  ARecordCheck: TRecordCheck;
begin
  Assert(ProducerInt <> nil);

  // »щем производител€ с таким-же именем без учЄта регистра
  Result := not ProducerInt.Exist(Name.Value);

  // ≈сли нашли такого-же производител€
  if not Result then
  begin
    ARecordCheck.ErrorType := etWarring;
    ARecordCheck.Row := ExcelRow.AsInteger;
    ARecordCheck.Col := Name.Index + 1;
    ARecordCheck.ErrorMessage := Name.AsString;
    ARecordCheck.Description := '“акой производитель уже существует.';
    ProcessErrors(ARecordCheck);
  end;
end;

function TProducersExcelTable.CheckRecord: Boolean;
begin
  Result := inherited;
  if Result then
  begin
    // ѕровер€ем что такой производитель существует
    Result := CheckProducer;
  end;
end;

function TProducersExcelTable.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TProducersExcelTable.GetProducerType: TField;
begin
  Result := FieldByName('ProducerType');
end;

procedure TProducersExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('Name', True,
    'Ќазвание производител€ не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Products'));
  FieldsInfo.Add(TFieldInfo.Create('ProducerType', True,
    '“ип производител€ не может быть пустым'));
end;

function TProducersExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TProducersExcelTable.Create(Self);
end;

function TProducersExcelDM.GetExcelTable: TProducersExcelTable;
begin
  Result := CustomExcelTable as TProducersExcelTable;
end;

end.
