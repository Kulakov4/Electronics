unit BodyTypesSimpleQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BodyTypesBaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryBodyTypesSimple = class(TQueryBodyTypesBase)
  private
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyInsertOrUpdate;
    procedure ApplyUpdate(ASender: TDataSet); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryBodyTypesSimple.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
begin
  Assert(ASender = FDQuery);
  AID := PKValue;

  // Удаляем вариант корпуса
  QueryBodyVariations.LocateByPKAndDelete(AID);

  // Удаляем неиспользуемые корпуса
  DropUnusedBodies;

end;

procedure TQueryBodyTypesSimple.ApplyInsert(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

procedure TQueryBodyTypesSimple.ApplyInsertOrUpdate;
var
  AID: Integer;
begin
  QueryBodies.LocateOrAppend(Body.Value, IDBodyKind.Value);
  QueryBodyData.LocateOrAppend(BodyData.Value, IDProducer.Value,
    QueryBodies.PKValue);

  QueryBodyVariations.LocateOrAppend(QueryBodyData.PKValue,
    OutlineDrawing.AsString, LandPattern.AsString, Variations.AsString,
    Image.AsString);
  AID := QueryBodyVariations.PKValue;
  Assert(AID > 0);

  IDS.Value := AID;
  IDBodyData.Value := QueryBodyData.PKValue;
  IDBody.Value := QueryBodies.PKValue;
end;

procedure TQueryBodyTypesSimple.ApplyUpdate(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

end.
