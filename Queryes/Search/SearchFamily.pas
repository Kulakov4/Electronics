unit SearchFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchFamily = class(TQueryBase)
    fdqBase: TFDQuery;
  private
    function GetCategoryIDList: TField;
    function GetComponentGroup: TField;
    function GetDescriptionID: TField;
    function GetSubgroup: TField;
    function GetValue: TField;
    { Private declarations }
  protected
  public
    function SearchByID(const AIDComponent: Integer): Integer; overload;
    function SearchByValue(const AValue: string): Integer;
    function SearchByValueSimple(const AValue: string): Integer;
    property CategoryIDList: TField read GetCategoryIDList;
    property ComponentGroup: TField read GetComponentGroup;
    property DescriptionID: TField read GetDescriptionID;
    property Subgroup: TField read GetSubgroup;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DefaultParameters, StrHelper;

function TQuerySearchFamily.GetCategoryIDList: TField;
begin
  Result := Field('CategoryIDList');
end;

function TQuerySearchFamily.GetComponentGroup: TField;
begin
  Result := Field('ComponentGroup');
end;

function TQuerySearchFamily.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQuerySearchFamily.GetSubgroup: TField;
begin
  Result := Field('Subgroup');
end;

function TQuerySearchFamily.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchFamily.SearchByID(const AIDComponent: Integer): Integer;
var
  S: String;
begin
  Assert(AIDComponent > 0);

  // Добавляем условие
  S := Replace( fdqBase.SQL.Text, 'p.ID = :ID', '0=0' );

  // Добавляем поле ComponentGroup
  S := S.Replace('/* ComponentGroup', '', [rfReplaceAll] );
  S := S.Replace('ComponentGroup */', '', [rfReplaceAll] );

  // Добавляем значения параметров
  S := S.Replace('/* ParametersValues', '', [rfReplaceAll] );
  S := S.Replace('ParametersValues */', '', [rfReplaceAll] );

  // Добавляем описание
  S := S.Replace('/* Description', '', [rfReplaceAll] );
  S := S.Replace('Description */', '', [rfReplaceAll] );

  FDQuery.SQL.Text := S;
  SetParamType('ID');
  SetParamType('ProducerParameterID');
  SetParamType('PackagePinsParameterID');
  SetParamType('DatasheetParameterID');
  SetParamType('DiagramParameterID');
  SetParamType('DrawingParameterID');
  SetParamType('ImageParameterID');

  Result := Search(['ID', 'ProducerParameterID', 'PackagePinsParameterID',
    'DatasheetParameterID', 'DiagramParameterID', 'DrawingParameterID',
    'ImageParameterID'], [AIDComponent, TDefaultParameters.ProducerParameterID,
    TDefaultParameters.PackagePinsParameterID,
    TDefaultParameters.DatasheetParameterID, TDefaultParameters.DiagramParameterID,
    TDefaultParameters.DrawingParameterID, TDefaultParameters.ImageParameterID]);
end;

function TQuerySearchFamily.SearchByValue(const AValue: string): Integer;
var
  S: String;
begin
  Assert(not AValue.IsEmpty);

  // Добавляем условие
  S := Replace( fdqBase.SQL.Text, 'upper(p.Value) = upper(:Value)', '0=0' );
  // Добавляем значения параметров
  S := S.Replace('/* ParametersValues', '', [rfReplaceAll]);
  S := S.Replace('ParametersValues */', '', [rfReplaceAll]);

  FDQuery.SQL.Text := S;
  SetParamType('Value', ptInput, ftWideString);
  SetParamType('ProducerParameterID');
  SetParamType('PackagePinsParameterID');
  SetParamType('DatasheetParameterID');
  SetParamType('DiagramParameterID');
  SetParamType('DrawingParameterID');
  SetParamType('ImageParameterID');

  Result := Search(['Value', 'ProducerParameterID', 'PackagePinsParameterID',
    'DatasheetParameterID', 'DiagramParameterID', 'DrawingParameterID',
    'ImageParameterID'], [AValue, TDefaultParameters.ProducerParameterID,
    TDefaultParameters.PackagePinsParameterID,
    TDefaultParameters.DatasheetParameterID, TDefaultParameters.DiagramParameterID,
    TDefaultParameters.DrawingParameterID, TDefaultParameters.ImageParameterID]);
end;

function TQuerySearchFamily.SearchByValueSimple(const AValue: string): Integer;
var
  S: String;
begin
  Assert(not AValue.IsEmpty);

  // Добавляем условие
  S := Replace( fdqBase.SQL.Text, 'upper(p.Value) = upper(:Value)', '0=0' );

  FDQuery.SQL.Text := S;
  SetParamType('Value', ptInput, ftWideString);

  Result := Search(['Value'], [AValue]);
end;

end.
