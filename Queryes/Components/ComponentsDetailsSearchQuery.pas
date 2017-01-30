unit ComponentsDetailsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ComponentsBaseDetailQuery, ApplyQueryFrame;

type
  TQueryComponentsDetailsSearch = class(TQueryComponentsBaseDetail)
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

procedure TQueryComponentsDetailsSearch.ApplyInsert(ASender: TDataSet);
begin
  // �� ��������� ���������� ������
end;

procedure TQueryComponentsDetailsSearch.ClearSearchResult;
begin
  Search('', '');
end;

procedure TQueryComponentsDetailsSearch.Search(const AParentIDList,
    ADetailIDList: string);
begin
  Load(['ParentIDList', 'DetailIDList'],[AParentIDList, ADetailIDList]);
end;

end.
