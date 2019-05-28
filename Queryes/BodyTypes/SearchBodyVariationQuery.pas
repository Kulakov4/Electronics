unit SearchBodyVariationQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchBodyVariationW = class(TDSWrap)
  private
    FIDBody: TFieldWrap;
    FIDBodyData: TFieldWrap;
    FIDBodyKind: TFieldWrap;
    FIDS: TFieldWrap;
    FVariations: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property IDBody: TFieldWrap read FIDBody;
    property IDBodyData: TFieldWrap read FIDBodyData;
    property IDBodyKind: TFieldWrap read FIDBodyKind;
    property IDS: TFieldWrap read FIDS;
    property Variations: TFieldWrap read FVariations;
  end;

  TQrySearchBodyVariation = class(TQueryBase)
  private
    FW: TSearchBodyVariationW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchVariation(const ABodyVariation: String): Integer;
    property W: TSearchBodyVariationW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper;

constructor TSearchBodyVariationW.Create(AOwner: TComponent);
begin
  inherited;
  FIDS := TFieldWrap.Create(Self, 'IDS', '', True);
  FIDBodyData := TFieldWrap.Create(Self, 'IDBodyData');
  FVariations := TFieldWrap.Create(Self, 'Variations');
  FIDBody := TFieldWrap.Create(Self, 'IDBody');
  FIDBodyKind := TFieldWrap.Create(Self, 'IDBodyKind');
end;

constructor TQrySearchBodyVariation.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchBodyVariationW.Create(FDQuery);
end;

function TQrySearchBodyVariation.SearchVariation(const ABodyVariation: String):
    Integer;
begin
  Assert(not ABodyVariation.IsEmpty);
  Result := SearchEx([TParamrec.Create(W.Variations.FullName,
    '%,' + ABodyVariation + ',%', ftWideString, True, 'like')]);
end;

{$R *.dfm}

end.
