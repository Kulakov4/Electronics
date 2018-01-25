unit SubParametersQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, SubParametersExcelDataModule;

type
  TQuerySubParameters2 = class(TQueryWithDataSource)
  private
    function GetName: TField;
    function GetTranslation: TField;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDataFromExcelTable(AExcelTable: TSubParametersExcelTable);
    property Name: TField read GetName;
    property Translation: TField read GetTranslation;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySubParameters2.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
end;

function TQuerySubParameters2.GetName: TField;
begin
  Result := Field('Name');
end;

function TQuerySubParameters2.GetTranslation: TField;
begin
  Result := Field('Translation');
end;

procedure TQuerySubParameters2.LoadDataFromExcelTable(AExcelTable:
    TSubParametersExcelTable);
var
  AField: TField;
  I: Integer;
begin
  AExcelTable.DisableControls;
  try
    AExcelTable.First;
    AExcelTable.CallOnProcessEvent;
    while not AExcelTable.Eof do
    begin
      TryAppend;
      try
        for I := 0 to AExcelTable.FieldCount - 1 do
        begin
          AField := FDQuery.FindField(AExcelTable.Fields[I].FieldName);
          if AField <> nil then
          begin
            AField.Value := AExcelTable.Fields[I].Value;
          end;
        end;

        TryPost;
      except
        TryCancel;
        raise;
      end;

      AExcelTable.Next;
      AExcelTable.CallOnProcessEvent;
    end;
  finally
    AExcelTable.EnableControls;
  end;

end;

end.
