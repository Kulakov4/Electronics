unit CategoryParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap,
  OrderQuery;

type
  TCategoryParamsW = class(TDSWrap)
  private
    FIsAttribute: TFieldWrap;
    FID: TFieldWrap;
    FOrd: TFieldWrap;
    FIsEnabled: TFieldWrap;
    FParamSubParamID: TFieldWrap;
    FPosID: TFieldWrap;
    FProductCategoryID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property IsAttribute: TFieldWrap read FIsAttribute;
    property ID: TFieldWrap read FID;
    property Ord: TFieldWrap read FOrd;
    property IsEnabled: TFieldWrap read FIsEnabled;
    property ParamSubParamID: TFieldWrap read FParamSubParamID;
    property PosID: TFieldWrap read FPosID;
    property ProductCategoryID: TFieldWrap read FProductCategoryID;
  end;

  TQueryCategoryParams = class(TQueryBase)
  private
    FW: TCategoryParamsW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendOrEdit(AProductCategoryID, AParamSubParamID, AOrd: Integer);
    function SearchBy(AProductCategoryID, AParamSubParamID: Integer)
      : Integer; overload;
    property W: TCategoryParamsW read FW;
    { Public declarations }
  end;

implementation

uses
  StrHelper;

{$R *.dfm}

constructor TQueryCategoryParams.Create(AOwner: TComponent);
begin
  inherited;
  FW := TCategoryParamsW.Create(FDQuery);
end;

procedure TQueryCategoryParams.AppendOrEdit(AProductCategoryID,
  AParamSubParamID, AOrd: Integer);
begin
  if SearchBy(AProductCategoryID, AParamSubParamID) <> 0 then
    W.TryEdit
  else
  begin
    W.TryAppend;
    W.ProductCategoryID.F.AsInteger := AProductCategoryID;
    W.ParamSubParamID.F.AsInteger := AParamSubParamID;
    W.IsEnabled.F.AsInteger := 1;
    W.PosID.F.AsInteger := 1; // В середину
  end;

  // если хотим изменить порядок
  if (AOrd > 0) and (W.Ord.F.AsInteger = 0) then
    W.Ord.F.AsInteger := AOrd;

  // Обязательно делаем параметр видимым
  W.IsAttribute.F.Value := 1;

  W.TryPost;
end;

function TQueryCategoryParams.SearchBy(AProductCategoryID, AParamSubParamID
  : Integer): Integer;
begin
  Assert(AProductCategoryID > 0);
  Assert(AParamSubParamID > 0);

  // Ищем
  Result := SearchEx([TParamRec.Create(W.ProductCategoryID.FullName,
    AProductCategoryID), TParamRec.Create(W.ParamSubParamID.FullName,
    AParamSubParamID)]);
end;

constructor TCategoryParamsW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FIsAttribute := TFieldWrap.Create(Self, 'IsAttribute');
  FIsEnabled := TFieldWrap.Create(Self, 'IsEnabled');
  FParamSubParamID := TFieldWrap.Create(Self, 'ParamSubParamID');
  FPosID := TFieldWrap.Create(Self, 'PosID');
  FProductCategoryID := TFieldWrap.Create(Self, 'ProductCategoryID');
end;

end.
