unit SearchFamily;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchFamilyW = class(TDSWrap)
  private
    FCategoryIDList: TFieldWrap;
    FID: TFieldWrap;
    FComponentGroup: TFieldWrap;
    FDatasheet: TFieldWrap;
    FDescription: TFieldWrap;
    FDescriptionComponentName: TFieldWrap;
    FDescriptionID: TFieldWrap;
    FDiagram: TFieldWrap;
    FDrawing: TFieldWrap;
    FIDDatasheet: TFieldWrap;
    FIDDiagram: TFieldWrap;
    FIDDrawing: TFieldWrap;
    FIDImage: TFieldWrap;
    FIDProducer: TFieldWrap;
    FImage: TFieldWrap;
    FSubgroup: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property CategoryIDList: TFieldWrap read FCategoryIDList;
    property ID: TFieldWrap read FID;
    property ComponentGroup: TFieldWrap read FComponentGroup;
    property Datasheet: TFieldWrap read FDatasheet;
    property Description: TFieldWrap read FDescription;
    property DescriptionComponentName: TFieldWrap
      read FDescriptionComponentName;
    property DescriptionID: TFieldWrap read FDescriptionID;
    property Diagram: TFieldWrap read FDiagram;
    property Drawing: TFieldWrap read FDrawing;
    property IDDatasheet: TFieldWrap read FIDDatasheet;
    property IDDiagram: TFieldWrap read FIDDiagram;
    property IDDrawing: TFieldWrap read FIDDrawing;
    property IDImage: TFieldWrap read FIDImage;
    property IDProducer: TFieldWrap read FIDProducer;
    property Image: TFieldWrap read FImage;
    property Subgroup: TFieldWrap read FSubgroup;
    property Value: TFieldWrap read FValue;
  end;

  TQuerySearchFamily = class(TQueryBase)
  private
    FW: TSearchFamilyW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByID(const AIDComponent: Integer; TestResult: Integer = -1)
      : Integer; overload;
    function SearchByValue(const AValue: string): Integer;
    function SearchByValueAndProducer(const AValue, AProducer: string): Integer;
    function SearchByValueSimple(const AValue: string): Integer;
    property W: TSearchFamilyW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DefaultParameters, StrHelper;

constructor TQuerySearchFamily.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchFamilyW.Create(FDQuery);
end;

function TQuerySearchFamily.SearchByID(const AIDComponent: Integer;
  TestResult: Integer = -1): Integer;
var
  ASQL: String;
begin
  Assert(AIDComponent > 0);

  ASQL := SQL;

  // Добавляем поле ComponentGroup
  ASQL := ASQL.Replace('/* ComponentGroup', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ComponentGroup */', '', [rfReplaceAll]);

  // Добавляем значения параметров
  ASQL := ASQL.Replace('/* ParametersValues', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ParametersValues */', '', [rfReplaceAll]);

  // Добавляем описание
  ASQL := ASQL.Replace('/* Description', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('Description */', '', [rfReplaceAll]);

  // Добавляем условие
  FDQuery.SQL.Text := ReplaceInSQL(ASQL,
    Format('%s = :%s', [W.ID.FullName, W.ID.FieldName]), 0);

  SetParamType(W.ID.FieldName);
  SetParamType('ProducerParamSubParamID');
  SetParamType('PackagePinsParamSubParamID');
  SetParamType('DatasheetParamSubParamID');
  SetParamType('DiagramParamSubParamID');
  SetParamType('DrawingParamSubParamID');
  SetParamType('ImageParamSubParamID');

  Result := Search([W.ID.FieldName, 'ProducerParamSubParamID',
    'PackagePinsParamSubParamID', 'DatasheetParamSubParamID',
    'DiagramParamSubParamID', 'DrawingParamSubParamID', 'ImageParamSubParamID'],
    [AIDComponent, TDefaultParameters.ProducerParamSubParamID,
    TDefaultParameters.PackagePinsParamSubParamID,
    TDefaultParameters.DatasheetParamSubParamID,
    TDefaultParameters.DiagramParamSubParamID,
    TDefaultParameters.DrawingParamSubParamID,
    TDefaultParameters.ImageParamSubParamID], TestResult);
end;

function TQuerySearchFamily.SearchByValue(const AValue: string): Integer;
var
  ASQL: String;
begin
  Assert(not AValue.IsEmpty);

  ASQL := SQL;

  // Добавляем значения параметров
  ASQL := ASQL.Replace('/* ParametersValues', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ParametersValues */', '', [rfReplaceAll]);

  FDQuery.SQL.Text := ReplaceInSQL(ASQL, Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]), 0);
  SetParamType(W.Value.FieldName, ptInput, ftWideString);
  SetParamType('ProducerParamSubParamID');
  SetParamType('PackagePinsParamSubParamID');
  SetParamType('DatasheetParamSubParamID');
  SetParamType('DiagramParamSubParamID');
  SetParamType('DrawingParamSubParamID');
  SetParamType('ImageParamSubParamID');

  Result := Search([W.Value.FieldName, 'ProducerParamSubParamID',
    'PackagePinsParamSubParamID', 'DatasheetParamSubParamID',
    'DiagramParamSubParamID', 'DrawingParamSubParamID', 'ImageParamSubParamID'],
    [AValue, TDefaultParameters.ProducerParamSubParamID,
    TDefaultParameters.PackagePinsParamSubParamID,
    TDefaultParameters.DatasheetParamSubParamID,
    TDefaultParameters.DiagramParamSubParamID,
    TDefaultParameters.DrawingParamSubParamID,
    TDefaultParameters.ImageParamSubParamID]);
end;

function TQuerySearchFamily.SearchByValueAndProducer(const AValue,
  AProducer: string): Integer;
var
  ASQL: String;
begin
  Assert(not AValue.IsEmpty);
  Assert(not AProducer.IsEmpty);

  ASQL := SQL;

  // Добавляем значения параметров
  ASQL := ASQL.Replace('/* ParametersValues', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ParametersValues */', '', [rfReplaceAll]);

  // Добавляем краткое описание
  ASQL := ASQL.Replace('/* Description', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('Description */', '', [rfReplaceAll]);

  // Добавляем условие по наименованию семейства и его производителю
  ASQL := ReplaceInSQL(ASQL, Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]), 0);

  FDQuery.SQL.Text := ReplaceInSQL(ASQL,
    'upper(pv.Value) = upper(:Producer)', 0);
  SetParamType(W.Value.FieldName, ptInput, ftWideString);
  SetParamType('Producer', ptInput, ftWideString);
  SetParamType('ProducerParamSubParamID');
  SetParamType('PackagePinsParamSubParamID');
  SetParamType('DatasheetParamSubParamID');
  SetParamType('DiagramParamSubParamID');
  SetParamType('DrawingParamSubParamID');
  SetParamType('ImageParamSubParamID');

  Result := Search([W.Value.FieldName, 'Producer', 'ProducerParamSubParamID',
    'PackagePinsParamSubParamID', 'DatasheetParamSubParamID',
    'DiagramParamSubParamID', 'DrawingParamSubParamID', 'ImageParamSubParamID'],
    [AValue, AProducer, TDefaultParameters.ProducerParamSubParamID,
    TDefaultParameters.PackagePinsParamSubParamID,
    TDefaultParameters.DatasheetParamSubParamID,
    TDefaultParameters.DiagramParamSubParamID,
    TDefaultParameters.DrawingParamSubParamID,
    TDefaultParameters.ImageParamSubParamID]);
end;

function TQuerySearchFamily.SearchByValueSimple(const AValue: string): Integer;
begin
  Assert(not AValue.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.Value.FullName, AValue,
    ftWideString, True)]);
end;

constructor TSearchFamilyW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FCategoryIDList := TFieldWrap.Create(Self, 'CategoryIDList');
  FComponentGroup := TFieldWrap.Create(Self, 'ComponentGroup');
  FDatasheet := TFieldWrap.Create(Self, 'Datasheet');
  FDescription := TFieldWrap.Create(Self, 'Description');
  FDescriptionComponentName := TFieldWrap.Create(Self,
    'DescriptionComponentName');
  FDescriptionID := TFieldWrap.Create(Self, 'DescriptionID');
  FDiagram := TFieldWrap.Create(Self, 'Diagram');
  FDrawing := TFieldWrap.Create(Self, 'Drawing');
  FIDDatasheet := TFieldWrap.Create(Self, 'IDDatasheet');
  FIDDiagram := TFieldWrap.Create(Self, 'IDDiagram');
  FIDDrawing := TFieldWrap.Create(Self, 'IDDrawing');
  FIDImage := TFieldWrap.Create(Self, 'IDImage');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FImage := TFieldWrap.Create(Self, 'Image');
  FSubgroup := TFieldWrap.Create(Self, 'Subgroup');
  FValue := TFieldWrap.Create(Self, 'p.Value');
end;

end.
