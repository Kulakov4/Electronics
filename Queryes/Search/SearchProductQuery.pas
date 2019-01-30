unit SearchProductQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchProductW = class(TDSWrap)
  private
    FDatasheet: TFieldWrap;
    FValue: TFieldWrap;
    FDescriptionID: TFieldWrap;
    FDiagram: TFieldWrap;
    FDrawing: TFieldWrap;
    FID: TFieldWrap;
    FIDProducer: TFieldWrap;
    FImage: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Datasheet: TFieldWrap read FDatasheet;
    property Value: TFieldWrap read FValue;
    property DescriptionID: TFieldWrap read FDescriptionID;
    property Diagram: TFieldWrap read FDiagram;
    property Drawing: TFieldWrap read FDrawing;
    property ID: TFieldWrap read FID;
    property IDProducer: TFieldWrap read FIDProducer;
    property Image: TFieldWrap read FImage;
  end;

  TQuerySearchProduct = class(TQueryBase)
  private
    FW: TSearchProductW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByID(AID: Integer): Integer;
    function SearchByValue(const AValue: string): Integer; overload;
    function SearchByValue(const AValue: string; const AIDProducer: Integer)
      : Integer; overload;
    property W: TSearchProductW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

constructor TQuerySearchProduct.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchProductW.Create(FDQuery);
end;

function TQuerySearchProduct.SearchByID(AID: Integer): Integer;
begin
  Assert(AID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)]);
end;

function TQuerySearchProduct.SearchByValue(const AValue: string;
  const AIDProducer: Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AIDProducer > 0);

  // Меняем в запросе условие
  Result := SearchEx([TParamRec.Create(W.Value.FullName, AValue, ftWideString),
    TParamRec.Create(W.IDProducer.FullName, AIDProducer)])
end;

function TQuerySearchProduct.SearchByValue(const AValue: string): Integer;
begin
  Assert(not AValue.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.Value.FullName, AValue,
    ftWideString)]);
end;

constructor TSearchProductW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FDatasheet := TFieldWrap.Create(Self, 'Datasheet');
  FDescriptionID := TFieldWrap.Create(Self, 'DescriptionID');
  FDiagram := TFieldWrap.Create(Self, 'Diagram');
  FDrawing := TFieldWrap.Create(Self, 'Drawing');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FImage := TFieldWrap.Create(Self, 'Image');
  FValue := TFieldWrap.Create(Self, 'Value');
end;

end.
