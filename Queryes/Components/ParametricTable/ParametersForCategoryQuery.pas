unit ParametersForCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParametersForCategory = class(TfrmDataModule)
  private
    function GetBand: TField;
    function GetFieldType: TField;
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetParentParameter: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property Band: TField read GetBand;
    property FieldType: TField read GetFieldType;
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property ParentParameter: TField read GetParentParameter;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryParametersForCategory.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryId';
end;

function TQueryParametersForCategory.GetBand: TField;
begin
  Result := Field('Band');
end;

function TQueryParametersForCategory.GetFieldType: TField;
begin
  Result := Field('FieldType');
end;

function TQueryParametersForCategory.GetID: TField;
begin
  Result := Field('ID');
end;

function TQueryParametersForCategory.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryParametersForCategory.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQueryParametersForCategory.GetTableName: TField;
begin
  Result := Field('TableName');
end;

function TQueryParametersForCategory.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryParametersForCategory.GetValueT: TField;
begin
  Result := Field('ValueT');
end;

end.
