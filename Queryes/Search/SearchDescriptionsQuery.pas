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
  // Ссылка на метод обрабатывающий таблицу в памяти
  TProcRef = reference to procedure();


  TQuerySearchDescriptions = class(THandlingQuery)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetDescrID: TField;
    function GetDescriptionID: TField;
    { Private declarations }
  public
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

procedure TQuerySearchDescriptions.UpdateComponentDescriptions;
begin
  Assert(FDQuery.Active);
  FDQuery.Last;
  FDQuery.First;

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
      CallOnProcessEvent;
    end;
    FDQuery.Next;
  end;

end;

end.
