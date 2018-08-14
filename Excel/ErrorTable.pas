unit ErrorTable;

interface

uses
  CustomErrorTable, System.Classes, ErrorType, RecordCheck;

type
  TErrorTable = class(TCustomErrorTable)
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(ARecordCheck: TRecordCheck);
    procedure AddError(ARow, ACol: Integer; AError, ADescription: String);
    procedure AddWarring(ARow, ACol: Integer; AWarring, ADescription: string);
  end;

implementation

uses Data.DB;

constructor TErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('Row', ftInteger);
  FieldDefs.Add('Col', ftInteger);
  FieldDefs.Add('Error', ftWideString, 20);
  FieldDefs.Add('ErrorValue', ftWideString, 30);
  FieldDefs.Add('Description', ftWideString, 100);
  CreateDataSet;

  Open;

  FieldByName('Row').DisplayLabel := 'Строка';
  FieldByName('Col').DisplayLabel := 'Столбец';
  FieldByName('Error').DisplayLabel := 'Вид ошибки';
  FieldByName('ErrorValue').DisplayLabel := 'Ошибка';
  FieldByName('Description').DisplayLabel := 'Описание';
end;

procedure TErrorTable.Add(ARecordCheck: TRecordCheck);
var
  S: string;
begin
  case ARecordCheck.ErrorType of
    etNone:
      Exit;
    etWarring:
      S := WarringMessage;
    etError:
      S := ErrorMessage;
  end;
  AppendRecord([ARecordCheck.Row, ARecordCheck.Col, S,
    ARecordCheck.ErrorMessage, ARecordCheck.Description]);
end;

procedure TErrorTable.AddError(ARow, ACol: Integer;
  AError, ADescription: String);
begin
  AppendRecord([ARow, ACol, ErrorMessage, AError, ADescription]);
end;

procedure TErrorTable.AddWarring(ARow, ACol: Integer;
  AWarring, ADescription: string);
begin
  AppendRecord([ARow, ACol, WarringMessage, AWarring, ADescription]);
end;

end.
