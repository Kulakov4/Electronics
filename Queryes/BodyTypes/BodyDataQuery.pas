unit BodyDataQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections, DSWrap;

type
  TBodyDataW = class(TDSWrap)
  private
    FBodyData: TFieldWrap;
    FID: TFieldWrap;
    FIDBody: TFieldWrap;
    FIDProducer: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property BodyData: TFieldWrap read FBodyData;
    property ID: TFieldWrap read FID;
    property IDBody: TFieldWrap read FIDBody;
    property IDProducer: TFieldWrap read FIDProducer;
  end;

  TQueryBodyData = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TBodyDataW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppend(const ABodyData: string;
      AIDProducer, AIDBody: Integer);
    property W: TBodyDataW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

constructor TQueryBodyData.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyDataW.Create(FDQuery);
end;

procedure TQueryBodyData.LocateOrAppend(const ABodyData: string;
  AIDProducer, AIDBody: Integer);
var
  AFieldNames: string;
begin
  Assert(not ABodyData.IsEmpty);
  Assert(AIDProducer > 0);
  Assert(AIDBody > 0);

  AFieldNames := Format('%s;%s;%s', [W.IDBody.FieldName, W.BodyData.FieldName,
    W.IDProducer.FieldName]);

  if not FDQuery.LocateEx(AFieldNames,
    VarArrayOf([AIDBody, ABodyData, AIDProducer]), [lxoCaseInsensitive]) then
  begin
    W.TryAppend;
    W.BodyData.F.Value := ABodyData;
    W.IDBody.F.Value := AIDBody;
    W.IDProducer.F.Value := AIDProducer;
    W.TryPost;
  end;
end;

constructor TBodyDataW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FBodyData := TFieldWrap.Create(Self, 'BodyData');
  FIDBody := TFieldWrap.Create(Self, 'IDBody');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
end;

end.
