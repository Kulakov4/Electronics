unit SearchProductDescriptionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, HandlingQueryUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchProductDescription = class(THandlingQuery)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetDescrID: TField;
    function GetDescriptionID: TField;
    { Private declarations }
  public
    procedure UpdateProductDescriptions(ASender: TObject);
    property DescrID: TField read GetDescrID;
    property DescriptionID: TField read GetDescriptionID;
    { Public declarations }
  end;

var
  QuerySearchProductDescription: TQuerySearchProductDescription;

implementation

{$R *.dfm}

uses RepositoryDataModule;

function TQuerySearchProductDescription.GetDescrID: TField;
begin
  Result := Field('DescrID');
end;

function TQuerySearchProductDescription.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

procedure TQuerySearchProductDescription.UpdateProductDescriptions(ASender:
    TObject);
var
  i: Integer;
begin
  Assert(FDQuery.Active);

  // начинаем транзакцию, если она ещё не началась
  if (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;

  FDQuery.Last;
  FDQuery.First;
  i := 0;

  CallOnProcessEvent;
  while not FDQuery.Eof do
  begin
    // Связываем компоненты со своими описаниями
    if DescriptionID.AsInteger <> DescrID.AsInteger then
    begin
      FDQuery.Edit;
      DescriptionID.AsInteger := DescrID.AsInteger;
      FDQuery.Post;
      Inc(i);
      // Уже много записей обновили в рамках одной транзакции
      if i >= 1000 then
      begin
        i := 0;
        FDQuery.Connection.Commit;
        FDQuery.Connection.StartTransaction;
      end;
    end;
    FDQuery.Next;
    CallOnProcessEvent;
  end;

  FDQuery.Connection.Commit;

end;

end.
