unit BodyKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, OrderQuery, DSWrap;

type
  TBodyKindW = class(TOrderW)
  private
    FBodyKind: TFieldWrap;
    FID: TFieldWrap;
    FColor: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure ApplyColor(AIDArr: TArray<Integer>; AColor: TColor);
    procedure LocateOrAppend(AValue: string);
    property BodyKind: TFieldWrap read FBodyKind;
    property ID: TFieldWrap read FID;
    property Color: TFieldWrap read FColor;
  end;

  TQueryBodyKinds = class(TQueryOrder)
  private
    FShowDuplicate: Boolean;
    FW: TBodyKindW;
    procedure SetShowDuplicate(const Value: Boolean);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ShowDuplicate: Boolean read FShowDuplicate write SetShowDuplicate;
    property W: TBodyKindW read FW;
    { Public declarations }
  end;

implementation

uses NotifyEvents, StrHelper;

{$R *.dfm}

constructor TQueryBodyKinds.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TBodyKindW;

  AutoTransaction := False;

  // Не проверять необходимость заполнения полей на клиенте
  FDQuery.UpdateOptions.CheckRequired := False;
end;

function TQueryBodyKinds.CreateDSWrap: TDSWrap;
begin
  Result := TBodyKindW.Create(FDQuery);
end;

procedure TQueryBodyKinds.SetShowDuplicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDuplicate = Value then
    Exit;

  FShowDuplicate := Value;

  // Получаем первоначальный запрос
  ASQL := SQL;
  if FShowDuplicate then
  begin
    ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
  end;

  FDQuery.Close;
  FDQuery.SQL.Text := ASQL;
  FDQuery.Open;
end;

constructor TBodyKindW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FBodyKind := TFieldWrap.Create(Self, 'BodyKind');
  FColor := TFieldWrap.Create(Self, 'Color');
end;

procedure TBodyKindW.AddNewValue(const AValue: string);
begin
  TryAppend;
  BodyKind.F.AsString := AValue;
  TryPost;
end;

procedure TBodyKindW.ApplyColor(AIDArr: TArray<Integer>; AColor: TColor);
var
  AID: Integer;
begin
  Assert(Length(AIDArr) > 0);

  SaveBookmark;

  for AID in AIDArr do
  begin
    ID.Locate(AID, [], True);
    TryEdit;
    Color.F.AsInteger := AColor;
    TryPost;
  end;

  RestoreBookmark;
end;

procedure TBodyKindW.LocateOrAppend(AValue: string);
begin
  if not FDDataSet.LocateEx(BodyKind.FieldName, AValue, [lxoCaseInsensitive])
  then
    AddNewValue(AValue);
end;

end.
