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
    function Get�����������: TField;
    function Get��������: TField;
    function Get������������: TField;
    function Get�����: TField;
    function Get�����: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property �����������: TField read Get�����������;
    property ��������: TField read Get��������;
    property ������������: TField read Get������������;
    property �����: TField read Get�����;
    property �����: TField read Get�����;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents, ParameterValuesUnit;

constructor TQueryReports.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryReports.DoBeforeOpen(Sender: TObject);
begin
  // ��������� ��� ��������� "�������������"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;

  FDQuery.ParamByName('PackagePinsParameterID').AsInteger :=
    TParameterValues.PackagePinsParameterID;

  FDQuery.ParamByName('DatasheetParameterID').AsInteger :=
    TParameterValues.DatasheetParameterID;

  FDQuery.ParamByName('DiagramParameterID').AsInteger :=
    TParameterValues.DiagramParameterID;

  FDQuery.ParamByName('DrawingParameterID').AsInteger :=
    TParameterValues.DrawingParameterID;

  FDQuery.ParamByName('ImageParameterID').AsInteger :=
    TParameterValues.ImageParameterID;

end;

function TQueryReports.Get�����������: TField;
begin
  Result := Field('�����������');
end;

function TQueryReports.Get��������: TField;
begin
  Result := Field('��������');
end;

function TQueryReports.Get������������: TField;
begin
  Result := Field('������������');
end;

function TQueryReports.Get�����: TField;
begin
  Result := Field('�����');
end;

function TQueryReports.Get�����: TField;
begin
  Result := Field('�����');
end;

end.
