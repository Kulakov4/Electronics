unit GridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, GridFrame, GridView,
  Vcl.ExtCtrls, CustomErrorTable, Data.DB;

type
  TfrmGridView = class(TfrmRoot)
    MainPanel: TPanel;
    ViewImportError: TViewGrid;
    DataSource: TDataSource;
  private
    FDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    { Private declarations }
  protected
    procedure AssignErrorTable; virtual;
  public
    property DataSet: TDataSet read FDataSet write SetDataSet;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmGridView.AssignErrorTable;
begin
  DataSource.DataSet := FDataSet;
  // Подключаем представление к данным
  ViewImportError.MainView.DataController.DataSource := DataSource;
  ViewImportError.MainView.DataController.CreateAllItems(True);
  ViewImportError.MyCreateColumnsBarButtons;
  ViewImportError.ApplyBestFitEx;
end;

procedure TfrmGridView.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
  begin
    FDataSet := Value;
    if FDataSet <> nil then
    begin
      AssignErrorTable;
    end
    else
    begin
      DataSource.DataSet := nil;
    end;
  end;

end;

end.
