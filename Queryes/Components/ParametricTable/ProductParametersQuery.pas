unit ProductParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryProductParameters = class(TQueryBase)
  private
    function GetParameterID: TField;
    function GetParentProductID: TField;
    function GetProductID: TField;
    function GetValue: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyFilter(AProductID, AParameterID: Integer);
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

procedure TQueryProductParameters.ApplyFilter(AProductID, AParameterID:
    Integer);
begin
  Assert(AProductID > 0);
  Assert(AParameterID > 0);

  FDQuery.Filter := Format('(%s=%d) and (%s=%d)',
    [ProductID.FieldName, AProductID, ParameterID.FieldName, AParameterID]);
  FDQuery.Filtered := True;
end;

function TQueryProductParameters.GetParameterID: TField;
begin
  Result := Field('ParameterId');
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
