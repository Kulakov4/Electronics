unit ComponentsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, BaseComponentsQuery;

type
  TQueryComponentsSearch = class(TQueryBaseComponents)
  private
    { Private declarations }
  protected
    procedure ApplyInsert(ASender: TDataSet); override;
  public
    procedure ClearSearchResult;
    procedure Search(const AParentIDList, ADetailIDList: string);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

procedure TQueryComponentsSearch.ApplyInsert(ASender: TDataSet);
begin
  // Не разрешаем добавление записи
end;

procedure TQueryComponentsSearch.ClearSearchResult;
begin
  Search('', '');
end;

procedure TQueryComponentsSearch.Search(const AParentIDList,
  ADetailIDList: string);
begin
  Load(['ParentIDList', 'DetailIDList'], [AParentIDList, ADetailIDList]);
end;

end.
