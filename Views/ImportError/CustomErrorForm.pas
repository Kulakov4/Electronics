unit CustomErrorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, GridFrame, ImportErrorView,
  Vcl.ExtCtrls, CustomErrorTable, Data.DB;

type
  TfrmCustomError = class(TfrmRoot)
    MainPanel: TPanel;
    ViewImportError: TViewImportError;
    DataSource: TDataSource;
  private
    FErrorTable: TCustomErrorTable;
    procedure SetErrorTable(const Value: TCustomErrorTable);
    { Private declarations }
  protected
    procedure AssignErrorTable; virtual;
  public
    property ErrorTable: TCustomErrorTable read FErrorTable write SetErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmCustomError.AssignErrorTable;
begin
  DataSource.DataSet := FErrorTable;
  // Подключаем представление к данным
  ViewImportError.MainView.DataController.DataSource := DataSource;
  ViewImportError.MainView.DataController.CreateAllItems(True);
  ViewImportError.MyCreateColumnsBarButtons;
  ViewImportError.ApplyBestFitEx;
end;

procedure TfrmCustomError.SetErrorTable(const Value: TCustomErrorTable);
begin
  if FErrorTable <> Value then
  begin
    FErrorTable := Value;
    if FErrorTable <> nil then
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
