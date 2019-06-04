unit BodyKindsColorQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFDQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, DSWrap;

type
  TBodyKindsColorW = class(TDSWrap)
  private
    FColor: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Color: TFieldWrap read FColor;
  end;

  TQryBodyKindsColor = class(TQryBase)
  private
    FW: TBodyKindsColorW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property W: TBodyKindsColorW read FW;
    { Public declarations }
  end;

implementation

constructor TBodyKindsColorW.Create(AOwner: TComponent);
begin
  inherited;
  FColor := TFieldWrap.Create(Self, 'Color', 'Цвет', True);
end;

constructor TQryBodyKindsColor.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBodyKindsColorW.Create(FDQuery);
end;

{$R *.dfm}

end.
