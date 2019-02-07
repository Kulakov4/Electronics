unit BodyTypesSimpleQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BodyTypesBaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TQueryBodyTypesSimple = class(TQueryBodyTypesBase)
  private
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsertOrUpdate;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryBodyTypesSimple.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Удаляем вариант корпуса
  QueryBodyVariations.W.LocateByPKAndDelete(PK.Value);

  // Удаляем неиспользуемые корпуса
  DropUnusedBodies;
end;

procedure TQueryBodyTypesSimple.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

procedure TQueryBodyTypesSimple.ApplyInsertOrUpdate;
var
  AID: Integer;
begin
  QueryBodies.LocateOrAppend(W.Body.F.Value, W.IDBodyKind.F.Value);
  QueryBodyData.LocateOrAppend(W.BodyData.F.Value, W.IDProducer.F.Value,
    QueryBodies.PK.Value);

  QueryBodyVariations.LocateOrAppend(QueryBodyData.PK.Value,
    W.OutlineDrawing.F.AsString, W.LandPattern.F.AsString,
    W.Variations.F.AsString, W.Image.F.AsString);
  AID := QueryBodyVariations.PK.Value;
  Assert(AID > 0);

  W.IDS.F.Value := AID;

  W.Body.F.Value := QueryBodies.W.Body.F.Value;
  W.BodyData.F.Value := QueryBodyData.W.BodyData.F.Value;

  W.IDBodyData.F.Value := QueryBodyData.W.PK.Value;
  W.IDBody.F.Value := QueryBodies.W.PK.Value;

  UpdateJEDEC;
  UpdateOptions;
end;

procedure TQueryBodyTypesSimple.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

end.
