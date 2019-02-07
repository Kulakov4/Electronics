unit SearchProductDescriptionQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, HandlingQueryUnit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchProductDescriptionW = class(TDSWrap)
  private
    FDescrID: TFieldWrap;
    FID: TFieldWrap;
    FDescriptionID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property DescrID: TFieldWrap read FDescrID;
    property ID: TFieldWrap read FID;
    property DescriptionID: TFieldWrap read FDescriptionID;
  end;

  TQuerySearchProductDescription = class(THandlingQuery)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TSearchProductDescriptionW;
    { Private declarations }
  protected
    property W: TSearchProductDescriptionW read FW;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateProductDescriptions(ASender: TObject);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TQuerySearchProductDescription.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchProductDescriptionW.Create(FDQuery);
end;

procedure TQuerySearchProductDescription.UpdateProductDescriptions(ASender:
    TObject);
var
  i: Integer;
begin
  Assert(FDQuery.Active);

  // начинаем транзакцию, если она ещё не началась
  if (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;

  FDQuery.Last;
  FDQuery.First;
  i := 0;

  CallOnProcessEvent;
  while not FDQuery.Eof do
  begin
    // Связываем компоненты со своими описаниями
    if W.DescriptionID.F.AsInteger <> W.DescrID.F.AsInteger then
    begin
      W.TryEdit;
      W.DescriptionID.F.AsInteger := W.DescrID.F.AsInteger;
      W.TryPost;
      Inc(i);
      // Уже много записей обновили в рамках одной транзакции
      if i >= 1000 then
      begin
        i := 0;
        FDQuery.Connection.Commit;
        FDQuery.Connection.StartTransaction;
      end;
    end;
    FDQuery.Next;
    CallOnProcessEvent;
  end;

  FDQuery.Connection.Commit;

end;

constructor TSearchProductDescriptionW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FDescrID := TFieldWrap.Create(Self, 'DescrID');
  FDescriptionID := TFieldWrap.Create(Self, 'DescriptionID');
end;

end.
