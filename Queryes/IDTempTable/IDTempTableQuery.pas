unit IDTempTableQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, SequenceQuery;

type
  TQueryIDTempTable = class(TQueryBase)
  private
    function CreateTempTable: string;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

const temp_table_prefix = 'temp_table';

{$R *.dfm}

constructor TQueryIDTempTable.Create(AOwner: TComponent);
var
  ASQL: string;
  ATableName: string;
begin
  inherited;
  ATableName := CreateTempTable;
  ASQL := String.Format('SELECT ID FROM %s', [ATableName]);
  FDQuery.Open( ASQL );
end;

function TQueryIDTempTable.CreateTempTable: string;
var
  ASQL: string;
  i: Integer;
begin
  i := TQuerySequence.NextValue(temp_table_prefix);
  Result := String.Format('%s_%d', [temp_table_prefix, i]);
  ASQL := String.Format('CREATE TEMP TABLE %s (ID INTEGER)', [Result]);
  FDQuery.ExecSQL(ASQL);
end;

end.
