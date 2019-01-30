unit SearchComponentGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchComponentGroupW = class(TDSWrap)
  private
    FComponentGroup: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentGroup: TFieldWrap read FComponentGroup;
    property ID: TFieldWrap read FID;
  end;

  TQuerySearchComponentGroup = class(TQueryBase)
  private
    FW: TSearchComponentGroupW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Append(const AComponentGroup: string);
    function SearchByID(const AID: Integer;
      const ATestResult: Boolean = False): Integer;
    function SearchByValue(const AComponentGroup: string): Integer;
    property W: TSearchComponentGroupW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper, System.Math;

constructor TQuerySearchComponentGroup.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchComponentGroupW.Create(FDQuery);
end;

procedure TQuerySearchComponentGroup.Append(const AComponentGroup: string);
begin
  Assert(not AComponentGroup.IsEmpty);
  W.TryAppend;
  W.ComponentGroup.F.Value := AComponentGroup;
  W.TryPost;
end;

function TQuerySearchComponentGroup.SearchByID(const AID: Integer;
  const ATestResult: Boolean = False): Integer;
begin
  Assert(AID > 0);

  // »щем
  Result := SearchEx([TParamRec.Create(W.PK.FullName, AID)],
    IfThen(ATestResult, 1, -1));
end;

function TQuerySearchComponentGroup.SearchByValue(const AComponentGroup
  : string): Integer;
begin
  Assert(not AComponentGroup.IsEmpty);

  // »щем
  Result := SearchEx([TParamRec.Create(W.ComponentGroup.FullName,
    AComponentGroup, ftWideString, True)]);
end;

constructor TSearchComponentGroupW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FComponentGroup := TFieldWrap.Create(Self, 'ComponentGroup');
end;

end.
