unit ParametricErrorTable;

interface

uses
  CustomErrorTable, Data.DB, System.Classes, System.SysUtils;

type
  TParametricErrorType = (petDuplicate, petNotFound, petDaughterDuplicate);

  TParametricErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetErrorType: TField;
    function GetFieldName: TField;
    function GetParameterID: TField;
    function GetParameterName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AParameterName, AMessage, AFieldName: string;
        const AErrorType: TParametricErrorType);
    procedure Fix(AParameterID: Integer);
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ErrorType: TField read GetErrorType;
    property FieldName: TField read GetFieldName;
    property ParameterID: TField read GetParameterID;
    property ParameterName: TField read GetParameterName;
  end;

implementation

constructor TParametricErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ParameterName', ftWideString, 100);
  FieldDefs.Add('Error', ftWideString, 50);
  FieldDefs.Add('Description', ftWideString, 150);
  FieldDefs.Add('FieldName', ftWideString, 50);
  FieldDefs.Add('ErrorType', ftInteger, 0);
  FieldDefs.Add('ParameterID', ftInteger, 0);
  CreateDataSet;

  Open;

  ParameterName.DisplayLabel := 'Параметр';
  Description.DisplayLabel := 'Описание';
  Error.DisplayLabel := 'Вид ошибки';
  FieldName.Visible := False;
  ErrorType.Visible := False;
  ParameterID.Visible := False;
end;

function TParametricErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TParametricErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TParametricErrorTable.GetParameterName: TField;
begin
  Result := FieldByName('ParameterName');
end;

procedure TParametricErrorTable.AddErrorMessage(const AParameterName, AMessage,
    AFieldName: string; const AErrorType: TParametricErrorType);
begin
  Assert(Active);
  Assert(not AFieldName.IsEmpty);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ParameterName.AsString := AParameterName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  FieldName.AsString := AFieldName;
  ErrorType.AsInteger := Integer(AErrorType);
  Post;
end;

procedure TParametricErrorTable.Fix(AParameterID: Integer);
begin
  Assert(AParameterID > 0);
  Edit;
  ParameterID.AsInteger := AParameterID;
  Post;
  Filter := Format('%s is null', [ParameterID.FieldName]);
  Filtered := True;
end;

function TParametricErrorTable.GetErrorType: TField;
begin
  Result := FieldByName('ErrorType');
end;

function TParametricErrorTable.GetFieldName: TField;
begin
  Result := FieldByName('FieldName');
end;

function TParametricErrorTable.GetParameterID: TField;
begin
  Result := FieldByName('ParameterID');
end;

end.
