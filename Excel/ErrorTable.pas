unit ErrorTable;

interface

uses
  CustomErrorTable, System.Classes, ErrorType, RecordCheck, DSWrap;

type
  TErrorTableW = class(TCustomErrorTableW)
  private
    FCol: TFieldWrap;
    FDescription: TFieldWrap;
    FErrorValue: TFieldWrap;
    FRow: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Col: TFieldWrap read FCol;
    property Description: TFieldWrap read FDescription;
    property ErrorValue: TFieldWrap read FErrorValue;
    property Row: TFieldWrap read FRow;
  end;

  TErrorTable = class(TCustomErrorTable)
  private
    FW: TErrorTableW;
  protected
    function CreateWrap: TCustomErrorTableW; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(ARecordCheck: TRecordCheck);
    property W: TErrorTableW read FW;
  end;

implementation

uses Data.DB;

constructor TErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FW := Wrap as TErrorTableW;

  FieldDefs.Add(W.Row.FieldName, ftInteger);
  FieldDefs.Add(W.Col.FieldName, ftInteger);
  FieldDefs.Add(W.Error.FieldName, ftWideString, 20);
  FieldDefs.Add(W.ErrorValue.FieldName, ftWideString, 30);
  FieldDefs.Add(W.Description.FieldName, ftWideString, 100);
  CreateDataSet;

  Open;
end;

procedure TErrorTable.Add(ARecordCheck: TRecordCheck);
var
  S: string;
begin
  case ARecordCheck.ErrorType of
    etNone:
      Exit;
    etWarring:
      S := Wrap.WarringMessage;
    etError:
      S := Wrap.ErrorMessage;
  end;
  AppendRecord([ARecordCheck.Row, ARecordCheck.Col, S,
    ARecordCheck.ErrorMessage, ARecordCheck.Description]);
end;

function TErrorTable.CreateWrap: TCustomErrorTableW;
begin
  Result := TErrorTableW.Create(Self);
end;

constructor TErrorTableW.Create(AOwner: TComponent);
begin
  inherited;
  FRow := TFieldWrap.Create(Self, 'Row', 'Строка');
  FCol := TFieldWrap.Create(Self, 'Col', 'Столбец');
  FErrorValue := TFieldWrap.Create(Self, 'ErrorValue', 'Ошибка');
  FDescription := TFieldWrap.Create(Self, 'Description', 'Описание');
end;

end.
