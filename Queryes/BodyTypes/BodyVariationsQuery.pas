unit BodyVariationsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBodyVariationW = class(TDSWrap)
  private
    FIDBodyData: TFieldWrap;
    FID: TFieldWrap;
    FImage: TFieldWrap;
    FLandPattern: TFieldWrap;
    FOutlineDrawing: TFieldWrap;
    FVariation: TFieldWrap;
  protected
    property IDBodyData: TFieldWrap read FIDBodyData;
    property ID: TFieldWrap read FID;
    property Image: TFieldWrap read FImage;
    property LandPattern: TFieldWrap read FLandPattern;
    property OutlineDrawing: TFieldWrap read FOutlineDrawing;
    property Variation: TFieldWrap read FVariation;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TQueryBodyVariations = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TBodyVariationW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppend(AIDBodyData: Integer; const AOutlineDrawing,
        ALandPattern, AVariation, AImage: string);
    property W: TBodyVariationW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryBodyVariations.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyVariationW.Create(FDQuery);
end;

procedure TQueryBodyVariations.LocateOrAppend(AIDBodyData: Integer; const
    AOutlineDrawing, ALandPattern, AVariation, AImage: string);
var
  AFieldNames: string;
begin
  Assert(AIDBodyData > 0);

  AFieldNames := Format('%s;%s', [W.IDBodyData.FieldName, W.Variation.FieldName]);
  if not FDQuery.LocateEx(AFieldNames, VarArrayOf([AIDBodyData, AVariation]),
    [lxoCaseInsensitive]) then
    W.TryAppend
  else
    W.TryEdit;

  W.IDBodyData.F.Value := AIDBodyData;
  W.OutlineDrawing.F.Value := AOutlineDrawing;
  W.LandPattern.F.Value := ALandPattern;
  W.Variation.F.Value := AVariation;
  W.Image.F.Value := AImage;
  W.TryPost;
end;

constructor TBodyVariationW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIDBodyData := TFieldWrap.Create(Self, 'IDBodyData');
  FImage := TFieldWrap.Create(Self, 'Image');
  FLandPattern := TFieldWrap.Create(Self, 'LandPattern');
  FOutlineDrawing := TFieldWrap.Create(Self, 'OutlineDrawing');
  FVariation := TFieldWrap.Create(Self, 'Variation');
end;

end.
