unit ReportQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit, DSWrap;

type
  TReportW = class(TDSWrap)
  private
    F�����������: TFieldWrap;
    F��������: TFieldWrap;
    F������������: TFieldWrap;
    F�����: TFieldWrap;
    F�����: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property �����������: TFieldWrap read F�����������;
    property ��������: TFieldWrap read F��������;
    property ������������: TFieldWrap read F������������;
    property �����: TFieldWrap read F�����;
    property �����: TFieldWrap read F�����;
  end;

  TQueryReports = class(TQueryWithDataSource)
  private
    FW: TReportW;
    procedure DoBeforeOpen(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TReportW read FW;
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

function TQueryReports.CreateDSWrap: TDSWrap;
begin
  Result := TReportW.Create(FDQuery);
end;

procedure TQueryReports.DoBeforeOpen(Sender: TObject);
begin
  // ��������� ��� ��������� "�������������"
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

constructor TReportW.Create(AOwner: TComponent);
begin
  inherited;
  F����������� := TFieldWrap.Create(Self, '�����������');
  F�������� := TFieldWrap.Create(Self, '��������');
  F������������ := TFieldWrap.Create(Self, '������������');
  F����� := TFieldWrap.Create(Self, '�����');
  F����� := TFieldWrap.Create(Self, '�����');
end;

end.
