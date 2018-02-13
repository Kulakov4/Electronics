unit ReportQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit;

type
  TQueryReports = class(TQueryWithDataSource)
  private
    procedure DoBeforeOpen(Sender: TObject);
    function GetИзображение: TField;
    function GetОписание: TField;
    function GetСпецификация: TField;
    function GetСхема: TField;
    function GetЧертёж: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property Изображение: TField read GetИзображение;
    property Описание: TField read GetОписание;
    property Спецификация: TField read GetСпецификация;
    property Схема: TField read GetСхема;
    property Чертёж: TField read GetЧертёж;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, DefaultParameters;

constructor TQueryReports.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryReports.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParamSubParamID').AsInteger :=
    TDefaultParameters.ProducerParamSubParamID;

  FDQuery.ParamByName('PackagePinsParamSubParamID').AsInteger :=
    TDefaultParameters.PackagePinsParamSubParamID;

  FDQuery.ParamByName('DatasheetParamSubParamID').AsInteger :=
    TDefaultParameters.DatasheetParamSubParamID;

  FDQuery.ParamByName('DiagramParamSubParamID').AsInteger :=
    TDefaultParameters.DiagramParamSubParamID;

  FDQuery.ParamByName('DrawingParamSubParamID').AsInteger :=
    TDefaultParameters.DrawingParamSubParamID;

  FDQuery.ParamByName('ImageParamSubParamID').AsInteger :=
    TDefaultParameters.ImageParamSubParamID;

end;

function TQueryReports.GetИзображение: TField;
begin
  Result := Field('Изображение');
end;

function TQueryReports.GetОписание: TField;
begin
  Result := Field('Описание');
end;

function TQueryReports.GetСпецификация: TField;
begin
  Result := Field('Спецификация');
end;

function TQueryReports.GetСхема: TField;
begin
  Result := Field('Схема');
end;

function TQueryReports.GetЧертёж: TField;
begin
  Result := Field('Чертёж');
end;

end.
