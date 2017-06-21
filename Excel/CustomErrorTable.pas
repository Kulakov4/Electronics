unit CustomErrorTable;

interface

uses FireDAC.Comp.Client, ProgressInfo, System.Classes, NotifyEvents,
  TableWithProgress;

type
  TCustomErrorTable = class(TTableWithProgress)
  private
    function GetErrorCount(AFilter: string): Integer;
    function GetTotalError: Integer;
    function GetTotalErrorsAndWarrings: Integer;
    function GetTotalWarrings: Integer;
  protected const
    ErrorMessage: String = 'Ошибка';
    WarringMessage: String = 'Предупреждение';
  public
    property TotalError: Integer read GetTotalError;
    property TotalErrorsAndWarrings: Integer read GetTotalErrorsAndWarrings;
    property TotalWarrings: Integer read GetTotalWarrings;
  end;

implementation

uses System.SysUtils;

function TCustomErrorTable.GetErrorCount(AFilter: string): Integer;
var
  AClone: TFDMemTable;
begin
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(Self);
    AClone.Filter := AFilter;
    AClone.Filtered := True;
    Result := AClone.RecordCount;
  finally
    FreeAndNil(AClone);
  end;
end;

function TCustomErrorTable.GetTotalError: Integer;
begin
  Result := GetErrorCount(Format('Error=''%s''', [ErrorMessage]));
end;

function TCustomErrorTable.GetTotalErrorsAndWarrings: Integer;
begin
  Result := TotalError + TotalWarrings;
end;

function TCustomErrorTable.GetTotalWarrings: Integer;
begin
  Result := GetErrorCount(Format('Error=''%s''', [WarringMessage]));
end;

end.
