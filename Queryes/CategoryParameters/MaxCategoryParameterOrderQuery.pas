unit MaxCategoryParameterOrderQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TMaxCategoryParameterOrderW = class(TDSWrap)
  private
    FMaxOrder: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property MaxOrder: TFieldWrap read FMaxOrder;
  end;

  TQueryMaxCategoryParameterOrder = class(TQueryBase)
  private
    FW: TMaxCategoryParameterOrderW;
    { Private declarations }
  protected
    property W: TMaxCategoryParameterOrderW read FW;
  public
    constructor Create(AOwner: TComponent); override;
    class function Max_Order: Integer; static;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryMaxCategoryParameterOrder.Create(AOwner: TComponent);
begin
  inherited;
  FW := TMaxCategoryParameterOrderW.Create(FDQuery);
end;

class function TQueryMaxCategoryParameterOrder.Max_Order: Integer;
var
  Q: TQueryMaxCategoryParameterOrder;
begin
  Q := TQueryMaxCategoryParameterOrder.Create(nil);
  try
    Q.FDQuery.Open;
    Result := Q.W.MaxOrder.F.AsInteger;
  finally
    FreeAndNil(Q);
  end;
end;

constructor TMaxCategoryParameterOrderW.Create(AOwner: TComponent);
begin
  inherited;
  FMaxOrder := TFieldWrap.Create(Self, 'MaxOrder');
end;

end.
