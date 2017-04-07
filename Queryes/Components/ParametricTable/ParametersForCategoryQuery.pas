unit ParametersForCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParametersForCategory = class(TQueryBase)
  private
    function GetParentCaption: TField;
    function GetFieldType: TField;
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetParentParameter: TField;
    function GetCaption: TField;
    function GetHint: TField;
    function GetOrd: TField;
    function GetParameterID: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ParentCaption: TField read GetParentCaption;
    property FieldType: TField read GetFieldType;
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property ParentParameter: TField read GetParentParameter;
    property Caption: TField read GetCaption;
    property Hint: TField read GetHint;
    property Ord: TField read GetOrd;
    property ParameterID: TField read GetParameterID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryParametersForCategory.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryId';
end;

function TQueryParametersForCategory.GetParentCaption: TField;
begin
  Result := Field('ParentCaption');
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

function TQueryParametersForCategory.GetCaption: TField;
begin
  Result := Field('Caption');
end;

function TQueryParametersForCategory.GetHint: TField;
begin
  Result := Field('Hint');
end;

function TQueryParametersForCategory.GetOrd: TField;
begin
  Result := Field('ord');
end;

function TQueryParametersForCategory.GetParameterID: TField;
begin
  Result := Field('ParameterID');
end;

end.
