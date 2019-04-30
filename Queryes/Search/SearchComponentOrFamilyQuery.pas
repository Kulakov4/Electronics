unit SearchComponentOrFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchComponentOrFamilyW = class(TDSWrap)
  private
    FParentProductID: TFieldWrap;
    FID: TFieldWrap;
    FFamilyID: TFieldWrap;
    FFamilyValue: TFieldWrap;
    FProducer: TFieldWrap;
    FProducerParamSubParamID: TParamWrap;
    FProducerParam: TParamWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyFamilyFilter;
    procedure ApplyComponentFilter;
    property ParentProductID: TFieldWrap read FParentProductID;
    property ID: TFieldWrap read FID;
    property FamilyID: TFieldWrap read FFamilyID;
    property FamilyValue: TFieldWrap read FFamilyValue;
    property Producer: TFieldWrap read FProducer;
    property ProducerParamSubParamID: TParamWrap read FProducerParamSubParamID;
    property ProducerParam: TParamWrap read FProducerParam;
    property Value: TFieldWrap read FValue;
  end;

  TQuerySearchComponentOrFamily = class(TQueryBase)
  private
    FW: TSearchComponentOrFamilyW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByValue(const AComponentName: string): Integer;
    function SearchByValueLike(const AComponentNames: string): Integer;
    function SearchByValues(const AComponentNames: string): Integer;
    function SearchComponent(const AComponentName: string): Integer; overload;
    function SearchComponent(AParentID: Integer; const AComponentName: string)
      : Integer; overload;
    function SearchComponentWithProducer(const AComponentName,
      AProducer: string): Integer; overload;
    function SearchComponentWithProducer(const AComponentName: string)
      : Integer; overload;
    function SearchFamily(const AFamilyName: string): Integer;
    property W: TSearchComponentOrFamilyW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, System.Strutils, DefaultParameters;

constructor TQuerySearchComponentOrFamily.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchComponentOrFamilyW.Create(FDQuery);
end;

function TQuerySearchComponentOrFamily.SearchComponentWithProducer
  (const AComponentName, AProducer: string): Integer;
var
  AStipulation: string;
  ASQL: string;
begin
  Assert(not AComponentName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  // Добавляем Производителя
  ASQL := SQL;
  ASQL := ASQL.Replace('/* Producer', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('Producer */', '', [rfReplaceAll]);
  ASQL := ReplaceInSQL(ASQL, Format('pv.Value = :%s',
    [W.ProducerParam.FieldName]), 2);

  // условие
  AStipulation := Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]);

  FDQuery.SQL.Text := ReplaceInSQL(ASQL, AStipulation, 0);

  SetParamType(W.Value.FieldName, ptInput, ftWideString);
  SetParamType(W.ProducerParamSubParamID.FieldName);
  SetParamType(W.ProducerParam.FieldName, ptInput, ftWideString);

  // Ищем
  Result := Search([W.Value.FieldName, W.ProducerParamSubParamID.FieldName,
    W.ProducerParam.FieldName], [AComponentName,
    TDefaultParameters.ProducerParamSubParamID, AProducer]);
end;

function TQuerySearchComponentOrFamily.SearchComponentWithProducer
  (const AComponentName: string): Integer;
var
  AStipulation: string;
  ASQL: string;
begin
  Assert(not AComponentName.IsEmpty);

  // Добавляем Производителя
  ASQL := SQL;
  ASQL := ASQL.Replace('/* Producer', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('Producer */', '', [rfReplaceAll]);

  // Меняем условие
  AStipulation := Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]);
  FDQuery.SQL.Text := ReplaceInSQL(ASQL, AStipulation, 0);

  SetParamType(W.ProducerParamSubParamID.FieldName);
  SetParamType(W.Value.FieldName, ptInput, ftWideString);

  // Ищем
  Result := Search([W.Value.FieldName, W.ProducerParamSubParamID.FieldName],
    [AComponentName, TDefaultParameters.ProducerParamSubParamID]);
end;

function TQuerySearchComponentOrFamily.SearchByValueLike(const AComponentNames
  : string): Integer;
var
  AStipulation: string;
  m: TArray<String>;
  S: String;
begin
  Assert(not AComponentNames.IsEmpty);
  m := AComponentNames.Split([',']);

  AStipulation := '';
  // Формируем несколько условий
  for S in m do
  begin
    AStipulation := IfThen(AStipulation.IsEmpty, '', ' or ');
    AStipulation := AStipulation + Format('%s like %s',
      [W.Value.FullName, QuotedStr(S + '%')]);
  end;

  // Делаем замену в первоначальном SQL запросе
  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);

  Result := Search([], []);
end;

function TQuerySearchComponentOrFamily.SearchByValues(const AComponentNames
  : string): Integer;
var
  AStipulation: string;
begin
  Assert(not AComponentNames.IsEmpty);

  AStipulation := Format('instr('',''||:%s||'','', '',''||%s||'','') > 0',
    [W.Value.FieldName, W.Value.FullName]);

  FDQuery.SQL.Text := ReplaceInSQL(SQL, AStipulation, 0);
  SetParamType(W.Value.FieldName, ptInput, ftWideString);

  Result := Search([W.Value.FieldName], [AComponentNames]);
end;

function TQuerySearchComponentOrFamily.SearchByValue(const AComponentName
  : string): Integer;
begin
  Assert(not AComponentName.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.Value.FullName, AComponentName,
    ftWideString, True)]);
end;

function TQuerySearchComponentOrFamily.SearchFamily(const AFamilyName
  : string): Integer;
var
  ANewSQL: string;
begin
  Assert(not AFamilyName.IsEmpty);

  // Делаем замену в первоначальном SQL запросе
  ANewSQL := ReplaceInSQL(SQL, Format('%s is null',
    [W.ParentProductID.FullName]), 0);

  FDQuery.SQL.Text := ReplaceInSQL(ANewSQL, Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]), 1);

  SetParamType(W.Value.FieldName, ptInput, ftWideString);

  // Ищем
  Result := Search([W.Value.FieldName], [AFamilyName]);
end;

function TQuerySearchComponentOrFamily.SearchComponent(AParentID: Integer;
  const AComponentName: string): Integer;
begin
  Assert(AParentID > 0);
  Assert(not AComponentName.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.Value.FullName, AComponentName,
    ftWideString, True), TParamRec.Create(W.ParentProductID.FullName,
    AParentID)]);
end;

function TQuerySearchComponentOrFamily.SearchComponent(const AComponentName
  : string): Integer;
var
  ANewSQL: string;
begin
  Assert(not AComponentName.IsEmpty);

  // Делаем замену в первоначальном SQL запросе
  ANewSQL := ReplaceInSQL(SQL, Format('not (%s is null)',
    [W.ParentProductID.FullName]), 0);

  FDQuery.SQL.Text := ReplaceInSQL(ANewSQL, Format('upper(%s) = upper(:%s)',
    [W.Value.FullName, W.Value.FieldName]), 1);

  SetParamType(W.Value.FieldName, ptInput, ftWideString);

  // Ищем
  Result := Search([W.Value.FieldName], [AComponentName]);
end;

constructor TSearchComponentOrFamilyW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FParentProductID := TFieldWrap.Create(Self, 'p.ParentProductID');
  FProducer := TFieldWrap.Create(Self, 'Producer');
  FValue := TFieldWrap.Create(Self, 'p.Value');
  FFamilyID := TFieldWrap.Create(Self, 'FamilyID');
  FFamilyValue := TFieldWrap.Create(Self, 'FamilyValue');

  FProducerParamSubParamID := TParamWrap.Create(Self,
    'ProducerParamSubParamID');

  FProducerParam := TParamWrap.Create(Self, 'Producer');
end;

procedure TSearchComponentOrFamilyW.ApplyFamilyFilter;
begin
  DataSet.Filter := Format('%s = NULL', [ParentProductID.FieldName]);
  DataSet.Filtered := True;
end;

procedure TSearchComponentOrFamilyW.ApplyComponentFilter;
begin
  DataSet.Filter := Format('%s <> NULL', [ParentProductID.FieldName]);
  DataSet.Filtered := True;
end;

end.
