unit ParamSubParamsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents;

type
  TQueryParamSubParams = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    procedure DoAfterOpen(Sender: TObject);
    function GetChecked: TField;
    function GetIDSubParameter: TField;
    function GetName: TField;
    { Private declarations }
  protected
    procedure DoBeforePost(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property Checked: TField read GetChecked;
    property IDSubParameter: TField read GetIDSubParameter;
    property Name: TField read GetName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TQueryParamSubParams.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create( BeforePost, DoBeforePost, FEventList );
  TNotifyEventWrap.Create( AfterOpen, DoAfterOpen, FEventList );
end;

procedure TQueryParamSubParams.DoAfterOpen(Sender: TObject);
begin
  Checked.ReadOnly := False;
end;

procedure TQueryParamSubParams.DoBeforePost(Sender: TObject);
begin
  if IDSubParameter.IsNull then
    // Ничего не сохраняем на сервере
    FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord
  else
    // Всё сохраняем на сервере
    FDQuery.OnUpdateRecord := nil;
end;

function TQueryParamSubParams.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryParamSubParams.GetIDSubParameter: TField;
begin
  Result := Field('IdSubParameter');
end;

function TQueryParamSubParams.GetName: TField;
begin
  Result := Field('Name');
end;

end.
