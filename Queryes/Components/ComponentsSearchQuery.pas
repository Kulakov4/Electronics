unit ComponentsSearchQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, BaseComponentsQuery, DSWrap, SearchFamOrCompoQuery;

type
  TQueryComponentsSearch = class(TQueryBaseComponents)
  private
    FqSearchFamilyOrComp: TQuerySearchFamilyOrComp;
    function GetqSearchFamilyOrComp: TQuerySearchFamilyOrComp;
    { Private declarations }
  protected
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    property qSearchFamilyOrComp: TQuerySearchFamilyOrComp
      read GetqSearchFamilyOrComp;
  public
    procedure AfterConstruction; override;
    procedure ClearSearchResult;
    procedure SearchByValue(AValues: TArray<String>; ALike: Boolean);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, StrHelper;

procedure TQueryComponentsSearch.AfterConstruction;
begin
  inherited;
  // ѕодставл€ем заведомо ложное условие чтобы очистить список
  FDQuery.SQL.Text := ReplaceInSQL(SQL, '0=1', 0);
end;

procedure TQueryComponentsSearch.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ќе разрешаем добавление записи
end;

procedure TQueryComponentsSearch.ClearSearchResult;
begin
  // ѕодставл€ем заведомо ложное условие чтобы очистить список
  FDQuery.SQL.Text := ReplaceInSQL(SQL, '0=1', 0);
  W.RefreshQuery;
end;

function TQueryComponentsSearch.GetqSearchFamilyOrComp
  : TQuerySearchFamilyOrComp;
begin
  if FqSearchFamilyOrComp = nil then
    FqSearchFamilyOrComp := TQuerySearchFamilyOrComp.Create(Self);

  Result := FqSearchFamilyOrComp;
end;

procedure TQueryComponentsSearch.SearchByValue(AValues: TArray<String>;
  ALike: Boolean);
var
  AStipulation: string;
  AStipulation1: string;
  AStipulation2: string;
begin
  // √отовим SQL запрос дл€ поиска семейств по названию
  qSearchFamilyOrComp.PrepareSearchByValue(AValues, ALike, True);

  AStipulation1 := Format('%s in (%s)', [W.ParentProductID.FullName,
    qSearchFamilyOrComp.FDQuery.SQL.Text]);

  // √отовим SQL запрос дл€ поиска компонентов
  qSearchFamilyOrComp.PrepareSearchByValue(AValues, ALike, False);

  AStipulation2 := Format('%s in (%s)', [W.ID.FullName,
    qSearchFamilyOrComp.FDQuery.SQL.Text]);

  AStipulation := Format('%s or %s', [AStipulation1, AStipulation2]);

  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);
  W.RefreshQuery;
end;

end.
