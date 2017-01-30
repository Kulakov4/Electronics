unit BodyKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyKinds = class(TfrmDataModule)
  private
    procedure DoAfterInsert(Sender: TObject);
    function GetBodyType: TField;
    function GetLevel: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property BodyType: TField read GetBodyType;
    property Level: TField read GetLevel;
    { Public declarations }
  end;

implementation

uses NotifyEvents;

{$R *.dfm}

constructor TQueryBodyKinds.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);

  AutoTransaction := False;
end;

procedure TQueryBodyKinds.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  BodyType.AsString := AValue;
  Level.AsInteger := 0;
  FDQuery.Post;
end;

procedure TQueryBodyKinds.DoAfterInsert(Sender: TObject);
begin
  Level.AsInteger := 0;
end;

function TQueryBodyKinds.GetBodyType: TField;
begin
  Result := Field('BodyType');
end;

function TQueryBodyKinds.GetLevel: TField;
begin
  Result := Field('Level');
end;

procedure TQueryBodyKinds.LocateOrAppend(AValue: string);
begin
  if not FDQuery.LocateEx(BodyType.FieldName, AValue, []) then
    AddNewValue(AValue);
end;

end.
