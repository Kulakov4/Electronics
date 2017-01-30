unit AllParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryAllParameters = class(TfrmDataModule)
  private
    function GetFieldType: TField;
    function GetID: TField;
    function GetParentParameter: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  public
    property FieldType: TField read GetFieldType;
    property ID: TField read GetID;
    property ParentParameter: TField read GetParentParameter;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryAllParameters.GetFieldType: TField;
begin
  Result := Field('FieldType');
end;

function TQueryAllParameters.GetID: TField;
begin
  Result := Field('ID');
end;

function TQueryAllParameters.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQueryAllParameters.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryAllParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryAllParameters.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

end.
