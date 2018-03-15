unit BodyVariationsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyVariations = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetIDBodyData: TField;
    function GetImage: TField;
    function GetJEDEC: TField;
    function GetLandPattern: TField;
    function GetOutlineDrawing: TField;
    function GetVariation: TField;
    { Private declarations }
  protected
    property IDBodyData: TField read GetIDBodyData;
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property Variation: TField read GetVariation;
  public
    procedure LocateOrAppend(AIDBodyData: Integer; const AOutlineDrawing,
        ALandPattern, AVariation, AImage, AJedec: string);
    property JEDEC: TField read GetJEDEC;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQueryBodyVariations.GetIDBodyData: TField;
begin
  Result := Field('IDBodyData');
end;

function TQueryBodyVariations.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryBodyVariations.GetJEDEC: TField;
begin
  Result := Field('JEDEC');
end;

function TQueryBodyVariations.GetLandPattern: TField;
begin
  Result := Field('LandPattern');
end;

function TQueryBodyVariations.GetOutlineDrawing: TField;
begin
  Result := Field('OutlineDrawing');
end;

function TQueryBodyVariations.GetVariation: TField;
begin
  Result := Field('Variation');
end;

procedure TQueryBodyVariations.LocateOrAppend(AIDBodyData: Integer; const
    AOutlineDrawing, ALandPattern, AVariation, AImage, AJedec: string);
var
  AFieldNames: string;
begin
  Assert(AIDBodyData > 0);

  AFieldNames := Format('%s;%s', [IDBodyData.FieldName, Variation.FieldName]);
  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyData, AVariation]),
    [lxoCaseInsensitive]) then
    TryAppend
  else
    TryEdit;

  IDBodyData.Value := AIDBodyData;
  OutlineDrawing.Value := AOutlineDrawing;
  LandPattern.Value := ALandPattern;
  Variation.Value := AVariation;
  Image.Value := AImage;
  JEDEC.Value := AJedec;

  TryPost;
end;

end.
