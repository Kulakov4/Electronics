unit GridSort;

interface

uses
  cxGridDBBandedTableView, System.Generics.Collections, System.SysUtils,
  System.StrUtils, cxGridTableView;

type
  TSortVariant = class(TObject)
  private
    FKeyFieldName: string;
    FSortedFieldNames: TList<String>;
  public
    constructor Create(AColumn: TcxGridDBBandedColumn;
      ASortedColumns: array of TcxGridDBBandedColumn);
    destructor Destroy; override;
    property KeyFieldName: string read FKeyFieldName;
    property SortedFieldNames: TList<String> read FSortedFieldNames;
  end;

  TGridSotr = class(TObject)
  private
    FSortDictionary: TDictionary<String, TSortVariant>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ASortVariant: TSortVariant);
    function ContainsColumn(AColumn: TcxGridColumn): Boolean;
    function GetSortVariant(AColumn: TcxGridColumn): TSortVariant;
  end;

implementation

constructor TSortVariant.Create(AColumn: TcxGridDBBandedColumn;
  ASortedColumns: array of TcxGridDBBandedColumn);
var
  i: Integer;
begin
  Assert(AColumn <> nil);
  Assert(not AColumn.DataBinding.FieldName.IsEmpty);
  Assert(Length(ASortedColumns) > 0);

  FKeyFieldName := AColumn.DataBinding.FieldName;
  FSortedFieldNames := TList<String>.Create;

  for i := Low(ASortedColumns) to High(ASortedColumns) do
    FSortedFieldNames.Add(ASortedColumns[i].DataBinding.FieldName);
end;

destructor TSortVariant.Destroy;
begin
  FreeAndNil(FSortedFieldNames);
  inherited;
end;

constructor TGridSotr.Create;
begin
  FSortDictionary := TDictionary<String, TSortVariant>.Create;
end;

destructor TGridSotr.Destroy;
var
  AKeyFieldName: string;
begin
  // Освобождаем все варианты сортировок
  For AKeyFieldName in FSortDictionary.Keys do
  begin
    FSortDictionary[AKeyFieldName].Free;
    FSortDictionary[AKeyFieldName] := nil;
  end;

  FreeAndNil(FSortDictionary);
  inherited;
end;

procedure TGridSotr.Add(ASortVariant: TSortVariant);
begin
  Assert(FSortDictionary <> nil);
  Assert(ASortVariant <> nil);

  FSortDictionary.Add(ASortVariant.KeyFieldName, ASortVariant);
end;

function TGridSotr.ContainsColumn(AColumn: TcxGridColumn): Boolean;
begin
  Assert(AColumn <> nil);
  Result := FSortDictionary.ContainsKey((AColumn as TcxGridDBBandedColumn)
    .DataBinding.FieldName);
end;

function TGridSotr.GetSortVariant(AColumn: TcxGridColumn): TSortVariant;
begin
  Result := nil;
  if ContainsColumn(AColumn) then
    Result := FSortDictionary[(AColumn as TcxGridDBBandedColumn)
      .DataBinding.FieldName]
end;

end.
