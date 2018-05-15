unit ParametricErrorTable;

interface

uses
  CustomErrorTable, Data.DB, System.Classes, System.SysUtils, ExcelDataModule;

type
  TParametricErrorType = (petParamNotFound, petParamDuplicate,
    petSubParamNotFound, petSubParamDuplicate, petNotUnique);

  TParametricErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetErrorType: TField;
    function GetFixed: TField;
    function GetStringTreeNodeID: TField;
    function GetParameterID: TField;
    function GetParameterName: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AParameterName, AMessage: string; const
        AErrorType: TParametricErrorType; AStringTreeNodeID: Integer);
    procedure FilterFixed;
    procedure Fix(AParameterID: Integer);
    function LocateByID(AStringTreeNodeID: Integer): Boolean;
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ErrorType: TField read GetErrorType;
    property Fixed: TField read GetFixed;
    property StringTreeNodeID: TField read GetStringTreeNodeID;
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
  FieldDefs.Add('StringTreeNodeID', ftInteger, 0);
  FieldDefs.Add('ErrorType', ftInteger, 0);
  FieldDefs.Add('ParameterID', ftInteger, 0);
  FieldDefs.Add('Fixed', ftBoolean);
  CreateDataSet;

  Open;

  ParameterName.DisplayLabel := '��������';
  Description.DisplayLabel := '��������';
  Error.DisplayLabel := '��� ������';
  StringTreeNodeID.Visible := False;
  ErrorType.Visible := False;
  ParameterID.Visible := False;
  Fixed.Visible := False;
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

procedure TParametricErrorTable.AddErrorMessage(const AParameterName, AMessage:
    string; const AErrorType: TParametricErrorType; AStringTreeNodeID: Integer);
begin
  Assert(Active);
  Assert(AStringTreeNodeID > 0);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ParameterName.AsString := AParameterName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  StringTreeNodeID.AsInteger := AStringTreeNodeID;
  ErrorType.AsInteger := Integer(AErrorType);
  Fixed.AsBoolean := False;
  Post;
end;

procedure TParametricErrorTable.FilterFixed;
begin
  Filter := Format('%s = false', [Fixed.FieldName]);
  Filtered := True;
end;

procedure TParametricErrorTable.Fix(AParameterID: Integer);
begin
  Assert(AParameterID > 0);
  Edit;
  ParameterID.AsInteger := AParameterID;
  Fixed.AsBoolean := True;
  Post;
end;

function TParametricErrorTable.GetErrorType: TField;
begin
  Result := FieldByName('ErrorType');
end;

function TParametricErrorTable.GetFixed: TField;
begin
  Result := FieldByName('Fixed');
end;

function TParametricErrorTable.GetStringTreeNodeID: TField;
begin
  Result := FieldByName('StringTreeNodeID');
end;

function TParametricErrorTable.GetParameterID: TField;
begin
  Result := FieldByName('ParameterID');
end;

function TParametricErrorTable.LocateByID(AStringTreeNodeID: Integer): Boolean;
begin
  Result := LocateEx(StringTreeNodeID.FieldName, AStringTreeNodeID, []);
end;

end.
