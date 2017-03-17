unit SearchDescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, ProgressInfo, HandlingQueryUnit;

type
  TQuerySearchDescriptions = class(THandlingQuery)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetDescrID: TField;
    function GetDescriptionID: TField;
    { Private declarations }
  public
    function Search(const AIDCategory: Integer): Integer; overload;
    procedure UpdateComponentDescriptions;
    property DescrID: TField read GetDescrID;
    property DescriptionID: TField read GetDescriptionID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProgressBarForm;

function TQuerySearchDescriptions.GetDescrID: TField;
begin
  Result := Field('DescrID');
end;

function TQuerySearchDescriptions.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQuerySearchDescriptions.Search(const AIDCategory: Integer): Integer;
var
  S: String;
begin
  Assert(AIDCategory > 0);

  S := FDQuery.SQL.Text;

  // Убираем из текста SQL запроса комментарий
  FDQuery.SQL.Text := S.Replace('--', '');

  // Настраиваем появившийся параметр
  with FDQuery.ParamByName('ProductCategoryId') do
  begin
    ParamType := ptInput;
    DataType := ftInteger;
  end;

  Result := Search(['ProductCategoryId'], [AIDCategory]);
end;

procedure TQuerySearchDescriptions.UpdateComponentDescriptions;
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
    if DescriptionID.AsInteger  <>
      DescrID.AsInteger then
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
