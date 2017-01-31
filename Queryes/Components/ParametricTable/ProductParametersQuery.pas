unit ProductParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryProductParameters = class(TQueryBase)
    FDQueryId: TFDAutoIncField;
    FDQueryUnionParameterId: TIntegerField;
    FDQueryValue: TWideStringField;
    FDQueryProductId: TIntegerField;
    FDQueryParentProductId: TIntegerField;
  private
    function GetParameterID: TField;
    function GetParentProductID: TField;
    function GetProductID: TField;
    function GetValue: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ParameterID: TField read GetParameterID;
    property ParentProductID: TField read GetParentProductID;
    property ProductID: TField read GetProductID;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryProductParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryId';
end;

function TQueryProductParameters.GetParameterID: TField;
begin
  Result := Field('UnionParameterId');
end;

function TQueryProductParameters.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQueryProductParameters.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductParameters.GetValue: TField;
begin
  Result := Field('Value');
end;

end.
