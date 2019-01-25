unit IDTempTableQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  SequenceQuery, DSWrap;

type
  TIDTempTableW = class(TDSWrap)
  private
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendData(AField: TField);
    property ID: TFieldWrap read FID;
  end;

  TQueryIDTempTable = class(TQueryBase)
  private
    FTableName: string;
    FW: TIDTempTableW;
    function CreateTempTable: string;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property TableName: string read FTableName;
    property W: TIDTempTableW read FW;
    { Public declarations }
  end;

implementation

const
  temp_table_prefix = 'temp_table';

{$R *.dfm}

constructor TQueryIDTempTable.Create(AOwner: TComponent);
var
  ASQL: string;
begin
  inherited;
  FW := TIDTempTableW.Create(FDQuery);
  FTableName := CreateTempTable;
  ASQL := String.Format('SELECT ID FROM %s', [FTableName]);
  FDQuery.Open(ASQL);
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

constructor TIDTempTableW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
end;

procedure TIDTempTableW.AppendData(AField: TField);
begin
  Assert(AField <> nil);
  Assert(AField.DataSet <> nil);
  Assert(AField.DataSet.Active);

  AField.DataSet.DisableControls;
  try
    AField.DataSet.First;
    while not AField.DataSet.Eof do
    begin
      TryAppend;
      ID.F.Value := AField.Value;
      TryPost;
      AField.DataSet.Next;
    end;
  finally
    AField.DataSet.EnableControls;
  end;
end;

end.
