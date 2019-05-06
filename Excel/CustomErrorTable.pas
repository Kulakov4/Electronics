unit CustomErrorTable;

interface

uses FireDAC.Comp.Client, ProgressInfo, System.Classes, NotifyEvents,
  TableWithProgress, DSWrap;

type
  TCustomErrorTableW = class(TDSWrap)
  private
    FError: TFieldWrap;
  protected const
  public
  const
    ErrorMessage: String = 'Ошибка';
    WarringMessage: String = 'Предупреждение';
    constructor Create(AOwner: TComponent); override;
    property Error: TFieldWrap read FError;
  end;

  TCustomErrorTable = class(TTableWithProgress)
  private
    FClone: TFDMemTable;
    FWrap: TCustomErrorTableW;
    function GetClone: TFDMemTable;
    function GetErrorCount(AFilter: string): Integer;
    function GetTotalError: Integer;
    function GetTotalErrorsAndWarrings: Integer;
    function GetTotalWarrings: Integer;
  protected
    function CreateWrap: TCustomErrorTableW; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Clone: TFDMemTable read GetClone;
    property TotalError: Integer read GetTotalError;
    property TotalErrorsAndWarrings: Integer read GetTotalErrorsAndWarrings;
    property TotalWarrings: Integer read GetTotalWarrings;
    property Wrap: TCustomErrorTableW read FWrap;
  end;

implementation

uses System.SysUtils;

constructor TCustomErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FWrap := CreateWrap;
end;

function TCustomErrorTable.CreateWrap: TCustomErrorTableW;
begin
  Result := TCustomErrorTableW.Create(Self);
end;

function TCustomErrorTable.GetClone: TFDMemTable;
begin
  if FClone = nil then
    FClone := Wrap.AddClone('');

  Result := FClone;
end;

function TCustomErrorTable.GetErrorCount(AFilter: string): Integer;
begin
  Clone.Filter := AFilter;
  Clone.Filtered := True;
  Result := Clone.RecordCount;
end;

function TCustomErrorTable.GetTotalError: Integer;
begin
  Result := GetErrorCount(Format('%s=%s', [Wrap.Error.FieldName,
    QuotedStr(Wrap.ErrorMessage)]));
end;

function TCustomErrorTable.GetTotalErrorsAndWarrings: Integer;
begin
  Result := TotalError + TotalWarrings;
end;

function TCustomErrorTable.GetTotalWarrings: Integer;
begin
  Result := GetErrorCount(Format('%s=%s', [Wrap.Error.FieldName,
    QuotedStr( Wrap.WarringMessage )]));
end;

constructor TCustomErrorTableW.Create(AOwner: TComponent);
begin
  inherited;
  FError := TFieldWrap.Create(Self, 'Error', 'Вид ошибки');
end;

end.
