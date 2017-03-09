unit SearchFamilyByID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchFamilyByID = class(TQueryBase)
  private
    function GetCategoryIDList: TField;
    function GetComponentGroup: TField;
    function GetDescriptionID: TField;
    { Private declarations }
  protected
  public
    function Search(const AIDComponent: Integer): Integer; overload;
    property CategoryIDList: TField read GetCategoryIDList;
    property ComponentGroup: TField read GetComponentGroup;
    property DescriptionID: TField read GetDescriptionID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ParameterValuesUnit;

function TQuerySearchFamilyByID.GetCategoryIDList: TField;
begin
  Result := Field('CategoryIDList');
end;

function TQuerySearchFamilyByID.GetComponentGroup: TField;
begin
  Result := Field('ComponentGroup');
end;

function TQuerySearchFamilyByID.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQuerySearchFamilyByID.Search(const AIDComponent: Integer):
    Integer;
begin
  Assert(AIDComponent > 0);
  Result := Search(['ID', 'ProducerParameterID', 'PackagePinsParameterID',
    'DatasheetParameterID', 'DiagramParameterID', 'DrawingParameterID',
    'ImageParameterID'], [AIDComponent, TParameterValues.ProducerParameterID,
    TParameterValues.PackagePinsParameterID,
    TParameterValues.DatasheetParameterID, TParameterValues.DiagramParameterID,
    TParameterValues.DrawingParameterID, TParameterValues.ImageParameterID]);
end;

end.
