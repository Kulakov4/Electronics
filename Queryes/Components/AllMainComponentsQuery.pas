unit AllMainComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  MainComponentsQuery, ApplyQueryFrame;

type
  TQueryAllMainComponents = class(TQueryMainComponents)
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    procedure DoAfterOpen(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryAllMainComponents.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList );
end;

procedure TQueryAllMainComponents.DoAfterOpen(Sender: TObject);
var
  AField: TField;
begin
  for AField in FDQuery.Fields do
    AField.ReadOnly := False;
end;

procedure TQueryAllMainComponents.FDQueryUpdateRecord(ASender: TDataSet;
    ARequest: TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
;
  inherited;
end;

end.
