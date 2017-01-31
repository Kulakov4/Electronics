unit SubParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit;

type
  TQuerySubParameters = class(TQueryWithDataSource)
  private
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetParentParameter: TField;
    function GetValue: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ParentParameter: TField read GetParentParameter;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQuerySubParameters.Create(AOwner: TComponent);
begin
  inherited;
  // Подписываемся на события
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  AutoTransaction := False;
end;

procedure TQuerySubParameters.DoAfterOpen(Sender: TObject);
begin
  Value.DisplayLabel := 'Наименование';
  Value.Required := True;
end;

procedure TQuerySubParameters.DoBeforePost(Sender: TObject);
begin
  FDQuery.FieldByName('IsCustomParameter').AsBoolean := false;
end;

function TQuerySubParameters.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQuerySubParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

end.
