unit CustomGridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, GridFrame, GridView,
  Vcl.ExtCtrls, CustomErrorTable, Data.DB;

type
  TfrmCustomGridView = class(TfrmRoot)
    MainPanel: TPanel;
    ViewImportError: TViewGrid;
    DataSource: TDataSource;
  private
    FDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    { Private declarations }
  protected
    procedure AssignDataSet; virtual;
  public
    property DataSet: TDataSet read FDataSet write SetDataSet;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmCustomGridView.AssignDataSet;
begin
  DataSource.DataSet := FDataSet;
  // Подключаем представление к данным
  ViewImportError.MainView.DataController.DataSource := DataSource;
  ViewImportError.MainView.DataController.CreateAllItems(True);
  ViewImportError.MyCreateColumnsBarButtons;
  ViewImportError.ApplyBestFitEx;
end;

procedure TfrmCustomGridView.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
  begin
    FDataSet := Value;
    if FDataSet <> nil then
    begin
      AssignDataSet;
    end
    else
    begin
      DataSource.DataSet := nil;
    end;
  end;

end;

end.
