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
    FDQueryInsert: TFDQuery;
  private
    { Private declarations }
  public
    procedure ExecUpdateSQL(const AOldPosID, ANewPosID, AOldOrder,
      ANewOrder: Integer; const AOldIsAttribute, ANewIsAttribute: Boolean;
      const AParameterID, ACategoryID: Integer);
    procedure ExecDeleteSQL(const AParameterID, ACategoryID: Integer);
    procedure ExecInsertSQL(APosID, AOrder: Integer;
      const AParameterID, ACategoryID: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryRecursiveParameters.ExecUpdateSQL(const AOldPosID, ANewPosID,
  AOldOrder, ANewOrder: Integer; const AOldIsAttribute, ANewIsAttribute
  : Boolean; const AParameterID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(AParameterID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(FDQueryUpdate.SQL);
  FDQuery.Params.Assign(FDQueryUpdate.Params);

  // Устанавливаем параметры запроса
  SetParameters(['OLD_POSID', 'NEW_POSID', 'OLD_ORDER', 'NEW_ORDER',
    'OLD_ISATTRIBUTE', 'NEW_ISATTRIBUTE', 'ParameterID', 'CATEGORYID'],
    [AOldPosID, ANewPosID, AOldOrder, ANewOrder, AOldIsAttribute,
    ANewIsAttribute, AParameterID, ACategoryID]);
  // Выполняем запрос
  FDQuery.ExecSQL;
end;

procedure TQueryRecursiveParameters.ExecDeleteSQL(const AParameterID,
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

procedure TQueryRecursiveParameters.ExecInsertSQL(APosID, AOrder: Integer;
  const AParameterID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(AParameterID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(FDQueryInsert.SQL);
  FDQuery.Params.Assign(FDQueryInsert.Params);

  // Устанавливаем параметры запроса
  SetParameters(['PosID', 'Order', 'ParameterID', 'CATEGORYID'],
    [APosID, AOrder, AParameterID, ACategoryID]);
  // Выполняем запрос
  FDQuery.ExecSQL;
end;

end.
