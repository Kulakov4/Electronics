unit CustomGridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, GridFrame, GridView,
  Vcl.ExtCtrls, CustomErrorTable, Data.DB;

const
  WM_ON_UPDATE_DATA = WM_USER + 125;

type
  TfrmCustomGridView = class(TfrmRoot)
    MainPanel: TPanel;
    ViewGrid: TViewGrid;
    DataSource: TDataSource;
    Timer1: TTimer;
    procedure DataSourceUpdateData(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FDataSet: TDataSet;
    FOnUpdateDataPost: Boolean;
    procedure SetDataSet(const Value: TDataSet);
    { Private declarations }
  protected
    procedure AssignDataSet; virtual;
    procedure DoOnUpdateData(var Message: TMessage); message WM_ON_UPDATE_DATA;
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
  ViewGrid.MainView.DataController.DataSource := DataSource;
  ViewGrid.MainView.DataController.CreateAllItems(True);
  ViewGrid.MyCreateColumnsBarButtons;
  ViewGrid.ApplyBestFitEx;
end;

procedure TfrmCustomGridView.DataSourceUpdateData(Sender: TObject);
begin
  inherited;
  if not FOnUpdateDataPost then
  begin
    Timer1.Enabled := True;
    FOnUpdateDataPost := True;
    //PostMessage(Handle, WM_ON_UPDATE_DATA, 0, 0);
  end;
end;

procedure TfrmCustomGridView.DoOnUpdateData(var Message: TMessage);
begin
  inherited;
  ViewGrid.ApplyBestFitEx;
  FOnUpdateDataPost := False;
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

procedure TfrmCustomGridView.Timer1Timer(Sender: TObject);
begin
  inherited;
  Timer1.Enabled := False;
  PostMessage(Handle, WM_ON_UPDATE_DATA, 0, 0);
end;

end.
