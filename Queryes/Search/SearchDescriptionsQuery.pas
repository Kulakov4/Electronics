unit SearchDescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SearchQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDescriptions = class(TQuerySearch)
    FDUpdateSQL: TFDUpdateSQL;
  private
    { Private declarations }
  public
    procedure UpdateComponentDescriptions;
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TQuerySearchDescriptions.UpdateComponentDescriptions;
begin
  FDQuery.Close;
  FDQuery.Open;

  while not FDQuery.Eof do
  begin
    // Связываем компоненты со своими описаниями
    FDQuery.Edit;
    FDQuery.FieldByName('DescriptionID').AsInteger := FDQuery.FieldByName('DescrID').AsInteger;
    FDQuery.Post;
    FDQuery.Next;
  end;

end;

end.
