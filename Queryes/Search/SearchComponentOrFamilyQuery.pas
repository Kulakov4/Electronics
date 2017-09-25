unit SearchComponentOrFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentOrFamily = class(TQueryBase)
    fdqBase: TFDQuery;
  private
    function GetParentProductID: TField;
    function GetProducer: TField;
    function GetValue: TField;
    { Private declarations }
  public
    function SearchComponentWithProducer(const AComponentName,
      AProducer: string): Integer; overload;
    function SearchComponentWithProducer(const AComponentName: string)
      : Integer; overload;
    function SearchByValueLike(const AComponentNames: string): Integer;
    function SearchByValues(const AComponentNames: string): Integer;
    function SearchByValue(const AComponentName: string): Integer;
    function SearchFamily(const AFamilyName: string): Integer;
    function SearchComponent(AParentID: Integer; const AComponentName: string):
        Integer; overload;
    function SearchComponent(const AComponentName: string): Integer; overload;
    property ParentProductID: TField read GetParentProductID;
    property Producer: TField read GetProducer;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, System.Strutils, DefaultParameters;

function TQuerySearchComponentOrFamily.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQuerySearchComponentOrFamily.GetProducer: TField;
begin
  Result := Field('Producer');
end;

function TQuerySearchComponentOrFamily.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchComponentOrFamily.SearchComponentWithProducer
  (const AComponentName, AProducer: string): Integer;
var
  ACondition: string;
  S: string;
begin
  Assert(not AComponentName.IsEmpty);
  Assert(not AProducer.IsEmpty);

  // Добавляем Производителя
  S := fdqBase.SQL.Text;
  S := S.Replace('/* Producer', '', [rfReplaceAll]);
  S := S.Replace('Producer */', '', [rfReplaceAll]);
  S := Replace(S, 'pv.Value = :Producer', '1=1');
  // Меняем условие
  ACondition := 'upper(p.Value) = upper(:Value)';

  FDQuery.SQL.Text := Replace(S, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);
  SetParamType('ProducerParameterID');
  SetParamType('Producer', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value', 'ProducerParameterID', 'Producer'],
    [AComponentName, TDefaultParameters.ProducerParameterID, AProducer]);
end;

function TQuerySearchComponentOrFamily.SearchComponentWithProducer
  (const AComponentName: string): Integer;
var
  ACondition: string;
  S: string;
begin
  Assert(not AComponentName.IsEmpty);

  // Добавляем Производителя
  S := fdqBase.SQL.Text;
  S := S.Replace('/* Producer', '', [rfReplaceAll]);
  S := S.Replace('Producer */', '', [rfReplaceAll]);
  // Меняем условие
  ACondition := 'upper(p.Value) = upper(:Value)';
  FDQuery.SQL.Text := Replace(S, ACondition, '0=0');

  SetParamType('ProducerParameterID');
  SetParamType('Value', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value', 'ProducerParameterID'],
    [AComponentName, TDefaultParameters.ProducerParameterID]);
end;

function TQuerySearchComponentOrFamily.SearchByValueLike(const AComponentNames
  : string): Integer;
var
  ACondition: string;
  m: TArray<String>;
  S: String;
begin
  Assert(not AComponentNames.IsEmpty);
  m := AComponentNames.Split([',']);

  ACondition := '';
  // Формируем несколько условий
  for S in m do
  begin
    ACondition := IfThen(ACondition.IsEmpty, '', ' or ');
    ACondition := ACondition + Format('p.Value like %s', [QuotedStr(S + '%')]);
  end;

  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');

  Result := Search([], []);
end;

function TQuerySearchComponentOrFamily.SearchByValues(const AComponentNames
  : string): Integer;
var
  ACondition: string;
begin
  Assert(not AComponentNames.IsEmpty);

  ACondition := 'instr('',''||:Value||'','', '',''||p.Value||'','') > 0';
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);

  Result := Search(['Value'], [AComponentNames]);
end;

function TQuerySearchComponentOrFamily.SearchByValue(const AComponentName
  : string): Integer;
var
  ACondition: string;
begin
  Assert(not AComponentName.IsEmpty);

  // Меняем условие
  ACondition := 'upper(p.Value) = upper(:Value)';
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value'], [AComponentName]);
end;

function TQuerySearchComponentOrFamily.SearchFamily(const AFamilyName
  : string): Integer;
var
  ACondition: string;
begin
  Assert(not AFamilyName.IsEmpty);

  // Меняем условие
  ACondition :=
    '(upper(p.Value) = upper(:Value)) and (ParentProductID is null)';
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value'], [AFamilyName]);
end;

function TQuerySearchComponentOrFamily.SearchComponent(AParentID: Integer;
    const AComponentName: string): Integer;
var
  ACondition: string;
begin
  Assert(AParentID > 0);
  Assert(not AComponentName.IsEmpty);

  // Добавляем условие
  ACondition :=
    'upper(p.Value) = upper(:Value) and ParentProductID = :ParentProductID';
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);
  SetParamType('ParentProductID');

  // Ищем
  Result := Search(['ParentProductID', 'Value'], [AParentID, AComponentName]);
end;

function TQuerySearchComponentOrFamily.SearchComponent(const AComponentName:
    string): Integer;
var
  ACondition: string;
begin
  Assert(not AComponentName.IsEmpty);
  // Добавляем условие
  ACondition :=
    '( upper(p.Value) = upper(:Value) ) and ( not (ParentProductID is null) )';
  FDQuery.SQL.Text := Replace(fdqBase.SQL.Text, ACondition, '0=0');
  SetParamType('Value', ptInput, ftWideString);

  // Ищем
  Result := Search(['Value'], [AComponentName]);
end;

end.
