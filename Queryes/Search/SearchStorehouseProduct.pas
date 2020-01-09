unit SearchStorehouseProduct;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchStoreHouseProductW = class(TDSWrap)
  private
    FProductID: TFieldWrap;
    FID: TFieldWrap;
    FIDComponentGroup: TFieldWrap;
    FAmount: TFieldWrap;
    FStorehouseID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ProductID: TFieldWrap read FProductID;
    property ID: TFieldWrap read FID;
    property IDComponentGroup: TFieldWrap read FIDComponentGroup;
    property Amount: TFieldWrap read FAmount;
    property StorehouseID: TFieldWrap read FStorehouseID;
  end;

  TQuerySearchStorehouseProduct = class(TQueryBase)
    procedure FDQueryUpdateError(ASender: TDataSet; AException: EFDException; ARow:
        TFDDatSRow; ARequest: TFDUpdateRequest; var AAction: TFDErrorAction);
  private
    FW: TSearchStoreHouseProductW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function SearchByGroupID(AStorehouseID, AIDComponentGroup: Integer)
      : Integer;
    function SearchByID(AID: Integer): Integer;
    function SearchByProductID(AProductID: Integer): Integer;
    property W: TSearchStoreHouseProductW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, FireDAC.Phys.SQLiteWrapper;

constructor TQuerySearchStorehouseProduct.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchStoreHouseProductW.Create(FDQuery);
end;

procedure TQuerySearchStorehouseProduct.FDQueryUpdateError(ASender: TDataSet;
    AException: EFDException; ARow: TFDDatSRow; ARequest: TFDUpdateRequest; var
    AAction: TFDErrorAction);
var
  AE: ESQLiteNativeException;
begin
  inherited;
  if not (AException is ESQLiteNativeException) then
    Exit;

  AE := AException as ESQLiteNativeException;
  //UNIQUE constraint failed
  if AE.ErrorCode = 2067 then
    AException.Message := 'Строка(и) уже сохранена(ы) на складе';
end;

function TQuerySearchStorehouseProduct.SearchByGroupID(AStorehouseID,
  AIDComponentGroup: Integer): Integer;
begin
  Assert(AStorehouseID > 0);
  Assert(AIDComponentGroup > 0);

  Result := SearchEx([TParamRec.Create(W.StorehouseID.FullName, AStorehouseID),
    TParamRec.Create(W.IDComponentGroup.FullName, AIDComponentGroup)]);
end;

function TQuerySearchStorehouseProduct.SearchByID(AID: Integer): Integer;
begin
  Assert(AID > 0);

  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)]);
end;

function TQuerySearchStorehouseProduct.SearchByProductID
  (AProductID: Integer): Integer;
begin
  Assert(AProductID > 0);

  Result := SearchEx([TParamRec.Create(W.ProductID.FullName, AProductID)]);
end;

constructor TSearchStoreHouseProductW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FProductID := TFieldWrap.Create(Self, 'ProductID');
  FStorehouseID := TFieldWrap.Create(Self, 'StorehouseID');
  FIDComponentGroup := TFieldWrap.Create(Self, 'IDComponentGroup');
  FAmount := TFieldWrap.Create(Self, 'Amount');
end;

end.
