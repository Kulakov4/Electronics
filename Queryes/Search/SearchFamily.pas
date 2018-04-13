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
    function GetDatasheet: TField;
    function GetDiagram: TField;
    function GetDescriptionID: TField;
    function GetDrawing: TField;
    function GetImage: TField;
    function GetSubgroup: TField;
    function GetValue: TField;
    { Private declarations }
  protected
  public
    function SearchByID(const AIDComponent: Integer; TestResult: Integer = -1)
      : Integer; overload;
    function SearchByValue(const AValue: string): Integer;
    function SearchByValueSimple(const AValue: string): Integer;
    property CategoryIDList: TField read GetCategoryIDList;
    property ComponentGroup: TField read GetComponentGroup;
    property Datasheet: TField read GetDatasheet;
    property Diagram: TField read GetDiagram;
    property DescriptionID: TField read GetDescriptionID;
    property Drawing: TField read GetDrawing;
    property Image: TField read GetImage;
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

function TQuerySearchFamily.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQuerySearchFamily.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQuerySearchFamily.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

function TQuerySearchFamily.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQuerySearchFamily.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQuerySearchFamily.GetSubgroup: TField;
begin
  Result := Field('Subgroup');
end;

function TQuerySearchFamily.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchFamily.SearchByID(const AIDComponent: Integer;
  TestResult: Integer = -1): Integer;
var
  S: String;
begin
  Assert(AIDComponent > 0);

  // Добавляем условие
  S := Replace(fdqBase.SQL.Text, 'p.ID = :ID', '0=0');

  // Добавляем поле ComponentGroup
  S := S.Replace('/* ComponentGroup', '', [rfReplaceAll]);
  S := S.Replace('ComponentGroup */', '', [rfReplaceAll]);

  // Добавляем значения параметров
  S := S.Replace('/* ParametersValues', '', [rfReplaceAll]);
  S := S.Replace('ParametersValues */', '', [rfReplaceAll]);

  // Добавляем описание
  S := S.Replace('/* Description', '', [rfReplaceAll]);
  S := S.Replace('Description */', '', [rfReplaceAll]);

  FDQuery.SQL.Text := S;
  SetParamType('ID');
  SetParamType('ProducerParamSubParamID');
  SetParamType('PackagePinsParamSubParamID');
  SetParamType('DatasheetParamSubParamID');
  SetParamType('DiagramParamSubParamID');
  SetParamType('DrawingParamSubParamID');
  SetParamType('ImageParamSubParamID');

  Result := Search(['ID', 'ProducerParamSubParamID',
    'PackagePinsParamSubParamID', 'DatasheetParamSubParamID',
    'DiagramParamSubParamID', 'DrawingParamSubParamID', 'ImageParameterID'],
    [AIDComponent, TDefaultParameters.ProducerParamSubParamID,
    TDefaultParameters.PackagePinsParamSubParamID,
    TDefaultParameters.DatasheetParamSubParamID,
    TDefaultParameters.DiagramParamSubParamID,
    TDefaultParameters.DrawingParamSubParamID,
    TDefaultParameters.ImageParamSubParamID], TestResult);
end;

function TQuerySearchFamily.SearchByValue(const AValue: string): Integer;
var
  S: String;
begin
  Assert(not AValue.IsEmpty);

  // Добавляем условие
  S := Replace(fdqBase.SQL.Text, 'upper(p.Value) = upper(:Value)', '0=0');
  // Добавляем значения параметров
  S := S.Replace('/* ParametersValues', '', [rfReplaceAll]);
  S := S.Replace('ParametersValues */', '', [rfReplaceAll]);

  FDQuery.SQL.Text := S;
  SetParamType('Value', ptInput, ftWideString);
  SetParamType('ProducerParamSubParamID');
  SetParamType('PackagePinsParamSubParamID');
  SetParamType('DatasheetParamSubParamID');
  SetParamType('DiagramParamSubParamID');
  SetParamType('DrawingParamSubParamID');
  SetParamType('ImageParamSubParamID');

  Result := Search(['Value', 'ProducerParamSubParamID',
    'PackagePinsParamSubParamID', 'DatasheetParamSubParamID',
    'DiagramParamSubParamID', 'DrawingParamSubParamID', 'ImageParamSubParamID'],
    [AValue, TDefaultParameters.ProducerParamSubParamID,
    TDefaultParameters.PackagePinsParamSubParamID,
    TDefaultParameters.DatasheetParamSubParamID,
    TDefaultParameters.DiagramParamSubParamID,
    TDefaultParameters.DrawingParamSubParamID,
    TDefaultParameters.ImageParamSubParamID]);
end;

function TQuerySearchFamily.SearchByValueSimple(const AValue: string): Integer;
var
  S: String;
begin
  Assert(not AValue.IsEmpty);

  // Добавляем условие
  S := Replace(fdqBase.SQL.Text, 'upper(p.Value) = upper(:Value)', '0=0');

  FDQuery.SQL.Text := S;
  SetParamType('Value', ptInput, ftWideString);

  Result := Search(['Value'], [AValue]);
end;

end.
