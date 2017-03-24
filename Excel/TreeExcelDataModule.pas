unit TreeExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, Data.DB;

type
  TTreeExcelTable = class(TCustomExcelTable)
  private
    function GetExternalID: TField;
    function GetParentExternalID: TField;
    function GetValue: TField;
  protected
    procedure SetFieldsInfo; override;
  public
    property ExternalID: TField read GetExternalID;
    property ParentExternalID: TField read GetParentExternalID;
    property Value: TField read GetValue;
  end;

  TTreeExcelDM = class(TExcelDM)
  private
    function GetExcelTable: TTreeExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    property ExcelTable: TTreeExcelTable read GetExcelTable;
    { Public declarations }
  end;

implementation

uses FieldInfoUnit;

function TTreeExcelTable.GetExternalID: TField;
begin
  Result := FieldByName('ExternalID');
end;

function TTreeExcelTable.GetParentExternalID: TField;
begin
  Result := FieldByName('ParentExternalID');
end;

function TTreeExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

procedure TTreeExcelTable.SetFieldsInfo;
begin
  FieldsInfo.Add(TFieldInfo.Create('ExternalID', True,
    'Идентификатор категории не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('Value', True,
    'Название категории не может быть пустым'));
  FieldsInfo.Add(TFieldInfo.Create('ParentExternalID'));
end;

function TTreeExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Result := TTreeExcelTable.Create(Self);
end;

function TTreeExcelDM.GetExcelTable: TTreeExcelTable;
begin
  Result := CustomExcelTable as TTreeExcelTable;
end;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

end.
