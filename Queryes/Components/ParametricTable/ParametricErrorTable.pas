unit ParametricErrorTable;

interface

uses
  CustomErrorTable, Data.DB, System.Classes, System.SysUtils, ExcelDataModule,
  DSWrap, FireDAC.Comp.Client, NotifyEvents;

type
  TParametricErrorType = (petParamNotFound, petParamDuplicate,
    petSubParamNotFound, petSubParamDuplicate, petNotUnique);

  TParametricErrorTableW = class(TCustomErrorTableW)
  private
    FOnFixError: TNotifyEventsEx;
    FDescription: TFieldWrap;
    FFixed: TFieldWrap;
    FErrorType: TFieldWrap;
    FParameterID: TFieldWrap;
    FParameterName: TFieldWrap;
    FStringTreeNodeID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddErrorMessage(const AParameterName, AMessage: string;
      const AErrorType: TParametricErrorType; AStringTreeNodeID: Integer);
    procedure FilterFixed;
    procedure Fix(AParameterID: Integer);
    function LocateByID(AStringTreeNodeID: Integer): Boolean;
    property OnFixError: TNotifyEventsEx read FOnFixError;
    property Description: TFieldWrap read FDescription;
    property Fixed: TFieldWrap read FFixed;
    property ErrorType: TFieldWrap read FErrorType;
    property ParameterID: TFieldWrap read FParameterID;
    property ParameterName: TFieldWrap read FParameterName;
    property StringTreeNodeID: TFieldWrap read FStringTreeNodeID;
  end;

  TParametricErrorTable = class(TCustomErrorTable)
  private
    FParamDuplicateClone: TFDMemTable;
    FW: TParametricErrorTableW;
    function GetParamDuplicateClone: TFDMemTable;
  protected
    function CreateWrap: TCustomErrorTableW; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ParamDuplicateClone: TFDMemTable read GetParamDuplicateClone;
    property W: TParametricErrorTableW read FW;
  end;

implementation

constructor TParametricErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FW := Wrap as TParametricErrorTableW;

  FieldDefs.Add(W.ParameterName.FieldName, ftWideString, 100);
  FieldDefs.Add(W.Error.FieldName, ftWideString, 50);
  FieldDefs.Add(W.Description.FieldName, ftWideString, 150);
  FieldDefs.Add(W.StringTreeNodeID.FieldName, ftInteger, 0);
  FieldDefs.Add(W.ErrorType.FieldName, ftInteger, 0);
  FieldDefs.Add(W.ParameterID.FieldName, ftInteger, 0);
  FieldDefs.Add(W.Fixed.FieldName, ftBoolean);
  CreateDataSet;

  Open;
end;

function TParametricErrorTable.CreateWrap: TCustomErrorTableW;
begin
  Result := TParametricErrorTableW.Create(Self);
end;

function TParametricErrorTable.GetParamDuplicateClone: TFDMemTable;
begin
  if FParamDuplicateClone = nil then
  begin
    // Есть ошибки сязанные с дублированием параметра и они не исправлены
    FParamDuplicateClone :=
      W.AddClone(Format('(%s=%d) and (%s=false)',
      [W.ErrorType.FieldName, Integer(petParamDuplicate), W.Fixed.FieldName]));
  end;

  Result := FParamDuplicateClone;
end;

constructor TParametricErrorTableW.Create(AOwner: TComponent);
begin
  inherited;
  FFixed := TFieldWrap.Create(Self, 'Fixed');
  FDescription := TFieldWrap.Create(Self, 'Description', 'Описание');
  FErrorType := TFieldWrap.Create(Self, 'ErrorType');
  FParameterID := TFieldWrap.Create(Self, 'ParameterID');
  FParameterName := TFieldWrap.Create(Self, 'ParameterName', 'Параметр');
  FStringTreeNodeID := TFieldWrap.Create(Self, 'StringTreeNodeID');

  FOnFixError := TNotifyEventsEx.Create(Self);
end;

destructor TParametricErrorTableW.Destroy;
begin
  inherited;
  FreeAndNil(FOnFixError);
end;

procedure TParametricErrorTableW.AddErrorMessage(const AParameterName,
  AMessage: string; const AErrorType: TParametricErrorType;
  AStringTreeNodeID: Integer);
begin
  Assert(Active);
  Assert(AStringTreeNodeID > 0);

  TryAppend;

  ParameterName.F.AsString := AParameterName;
  Error.F.AsString := ErrorMessage;
  Description.F.AsString := AMessage;
  StringTreeNodeID.F.AsInteger := AStringTreeNodeID;
  ErrorType.F.AsInteger := Integer(AErrorType);
  Fixed.F.AsBoolean := False;
  TryPost;
end;

procedure TParametricErrorTableW.FilterFixed;
begin
  DataSet.Filter := Format('%s = false', [Fixed.FieldName]);
  DataSet.Filtered := True;
end;

procedure TParametricErrorTableW.Fix(AParameterID: Integer);
begin
  Assert(AParameterID > 0);

  TryEdit;
  ParameterID.F.AsInteger := AParameterID;
  Fixed.F.AsBoolean := True;
  TryPost;

  FOnFixError.CallEventHandlers(Self);
end;

function TParametricErrorTableW.LocateByID(AStringTreeNodeID: Integer): Boolean;
begin
  Result := FDDataSet.LocateEx(StringTreeNodeID.FieldName,
    AStringTreeNodeID, []);
end;

end.
