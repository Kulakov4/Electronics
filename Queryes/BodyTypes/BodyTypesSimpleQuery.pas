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
    procedure ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions); override;
    procedure ApplyInsertOrUpdate;
    procedure ApplyUpdate(ASender: TDataSet); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryBodyTypesSimple.ApplyDelete(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  // Удаляем вариант корпуса
  QueryBodyVariations.LocateByPKAndDelete(PK.Value);

  // Удаляем неиспользуемые корпуса
  DropUnusedBodies;
end;

procedure TQueryBodyTypesSimple.ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
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
    QueryBodies.PK.Value);

  QueryBodyVariations.LocateOrAppend(QueryBodyData.PK.Value,
    OutlineDrawing.AsString, LandPattern.AsString, Variations.AsString,
    Image.AsString);
  AID := QueryBodyVariations.PK.Value;
  Assert(AID > 0);

  IDS.Value := AID;

  // Заполняем части наименования
  SetMySplitDataValues(QueryBodies.FDQuery, 'BODY');
  // Заполняем части корпусных данных
  SetMySplitDataValues(QueryBodyData.FDQuery, 'BODYDATA');

  IDBodyData.Value := QueryBodyData.PK.Value;
  IDBody.Value := QueryBodies.PK.Value;
end;

procedure TQueryBodyTypesSimple.ApplyUpdate(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);

  ApplyInsertOrUpdate;
end;

end.
