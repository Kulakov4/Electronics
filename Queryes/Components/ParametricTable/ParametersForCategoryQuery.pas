unit ParametersForCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DragHelper,
  System.Generics.Collections;

type
  TQueryParametersForCategory = class(TQueryBase)
  private
    function GetParentCaption: TField;
    function GetFieldType: TField;
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetParentParameter: TField;
    function GetCaption: TField;
    function GetBandHint: TField;
    function GetColumnHint: TField;
    function GetIDCategory: TField;
    function GetIDParameterKind: TField;
    function GetOrd: TField;
    function GetParameterID: TField;
    function GetPosID: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByParameterKind(AProductCategoryID: Integer): Integer;
    property ParentCaption: TField read GetParentCaption;
    property FieldType: TField read GetFieldType;
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property ParentParameter: TField read GetParentParameter;
    property Caption: TField read GetCaption;
    property BandHint: TField read GetBandHint;
    property ColumnHint: TField read GetColumnHint;
    property IDCategory: TField read GetIDCategory;
    property IDParameterKind: TField read GetIDParameterKind;
    property Ord: TField read GetOrd;
    property ParameterID: TField read GetParameterID;
    property PosID: TField read GetPosID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, StrHelper, ParameterKindEnum;

constructor TQueryParametersForCategory.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryId';
end;

function TQueryParametersForCategory.GetParentCaption: TField;
begin
  Result := Field('ParentCaption');
end;

function TQueryParametersForCategory.GetFieldType: TField;
begin
  Result := Field('FieldType');
end;

function TQueryParametersForCategory.GetID: TField;
begin
  Result := Field('ID');
end;

function TQueryParametersForCategory.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryParametersForCategory.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQueryParametersForCategory.GetCaption: TField;
begin
  Result := Field('Caption');
end;

function TQueryParametersForCategory.GetBandHint: TField;
begin
  Result := Field('BandHint');
end;

function TQueryParametersForCategory.GetColumnHint: TField;
begin
  Result := Field('ColumnHint');
end;

function TQueryParametersForCategory.GetIDCategory: TField;
begin
  Result := Field('IDCategory');
end;

function TQueryParametersForCategory.GetIDParameterKind: TField;
begin
  Result := Field('IDParameterKind');
end;

function TQueryParametersForCategory.GetOrd: TField;
begin
  Result := Field('ord');
end;

function TQueryParametersForCategory.GetParameterID: TField;
begin
  Result := Field('ParameterID');
end;

function TQueryParametersForCategory.GetPosID: TField;
begin
  Result := Field('PosID');
end;

function TQueryParametersForCategory.SearchByParameterKind(AProductCategoryID
  : Integer): Integer;
begin
  Assert(AProductCategoryID > 0);

  // ��������� � ������ �������
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('and (ifnull(p.IDParameterKind, pp.IDParameterKind) <> %d)',
    [Integer(��������������)]), 'and 0=0');

  // ����
  Result := Search(['ProductCategoryID'], [AProductCategoryID]);
end;

end.
