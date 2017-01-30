unit SearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.StdCtrls, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Collections;

type
  TQuerySearch = class(TFrame)
    FDQuery: TFDQuery;
    LabelSearch: TLabel;
  private
    { Private declarations }
  public
    function Search(const AParamNames: array of string;
      const AParamValues: array of Variant): Integer; overload;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

function TQuerySearch.Search(const AParamNames: array of string;
  const AParamValues: array of Variant): Integer;
var
  i: Integer;
begin
  Assert(Low(AParamNames) = Low(AParamValues));
  Assert(High(AParamNames) = High(AParamValues));

  FDQuery.DisableControls;
  try
    FDQuery.Close;
    for i := Low(AParamNames) to High(AParamNames) do
    begin
      FDQuery.ParamByName(AParamNames[i]).Value := AParamValues[i];
    end;
    FDQuery.Open;
  finally
    FDQuery.EnableControls;
  end;
  Result := FDQuery.RecordCount;
end;

end.
