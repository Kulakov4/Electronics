unit RecursiveParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryRecursiveParameters = class(TQueryBase)
    FDQueryDelete: TFDQuery;
    FDQueryUpdate: TFDQuery;
  private
    { Private declarations }
  public
    procedure Update(const AOldPosID, ANewPosID, AOldOrder, ANewOrder,
      AParameterID, ACategoryID: Integer);
    procedure Delete(const AParameterID, ACategoryID: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryRecursiveParameters.Update(const AOldPosID, ANewPosID,
  AOldOrder, ANewOrder, AParameterID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(AParameterID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(FDQueryUpdate.SQL);
  FDQuery.Params.Assign(FDQueryUpdate.Params);

  // Устанавливаем параметры запроса
  SetParameters(['OLD_POSID', 'NEW_POSID', 'OLD_ORDER', 'NEW_ORDER',
    'ParameterID', 'CATEGORYID'], [AOldPosID, ANewPosID, AOldOrder, ANewOrder,
    AParameterID, ACategoryID]);
  // Выполняем запрос
  FDQuery.ExecSQL;
end;

procedure TQueryRecursiveParameters.Delete(const AParameterID,
  ACategoryID: Integer);
begin
  Assert(AParameterID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(FDQueryDelete.SQL);
  FDQuery.Params.Assign(FDQueryDelete.Params);

  // Устанавливаем параметры запроса
  SetParameters(['ParameterID', 'CATEGORYID'], [AParameterID, ACategoryID]);
  // Выполняем запрос
  FDQuery.ExecSQL;
end;

end.
