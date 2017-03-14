unit SearchFamilyByValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchFamilyByValue = class(TQueryBase)
  private
    function GetCategoryIDList: TField;
    function GetSubgroup: TField;
    { Private declarations }
  protected
  public
    function Search(const AComponentName: string): Integer; overload;
    property CategoryIDList: TField read GetCategoryIDList;
    property Subgroup: TField read GetSubgroup;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ParameterValuesUnit;

function TQuerySearchFamilyByValue.GetCategoryIDList: TField;
begin
  Result := Field('CategoryIDList');
end;

function TQuerySearchFamilyByValue.GetSubgroup: TField;
begin
  Result := Field('Subgroup');
end;

function TQuerySearchFamilyByValue.Search(const AComponentName
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
