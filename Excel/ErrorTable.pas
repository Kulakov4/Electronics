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

end.
