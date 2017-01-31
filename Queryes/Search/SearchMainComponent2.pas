unit SearchMainComponent2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchMainComponent2 = class(TQueryBase)
  private
    function GetCategoryIDList: TField;
    function GetIDProductUnionParameters: TField;
    function GetSubgroup: TField;
    { Private declarations }
  public
    function Search(const AComponentName: string): Integer; overload;
    property CategoryIDList: TField read GetCategoryIDList;
    property IDProductUnionParameters: TField read GetIDProductUnionParameters;
    property Subgroup: TField read GetSubgroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ParameterValuesUnit;

function TQuerySearchMainComponent2.GetCategoryIDList: TField;
begin
  Result := Field('CategoryIDList');
end;

function TQuerySearchMainComponent2.GetIDProductUnionParameters: TField;
begin
  Result := Field('IDProductUnionParameters');
end;

function TQuerySearchMainComponent2.GetSubgroup: TField;
begin
  Result := Field('Subgroup');
end;

function TQuerySearchMainComponent2.Search(const AComponentName
  : string): Integer;
begin
  Assert(not AComponentName.IsEmpty);
  Result := Search(['Value', 'ProducerParameterID', 'PackagePinsParameterID',
    'DatasheetParameterID', 'DiagramParameterID', 'DrawingParameterID',
    'ImageParameterID'], [AComponentName, TParameterValues.ProducerParameterID,
    TParameterValues.PackagePinsParameterID,
    TParameterValues.DatasheetParameterID, TParameterValues.DiagramParameterID,
    TParameterValues.DrawingParameterID, TParameterValues.ImageParameterID]);
end;

end.
