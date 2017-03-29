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
  private
    { Private declarations }
  public
    procedure Execute(const AOldPosID, ANewPosID, AOldOrder, ANewOrder,
        AParameterID, ACategoryID: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryRecursiveParameters.Execute(const AOldPosID, ANewPosID,
    AOldOrder, ANewOrder, AParameterID, ACategoryID: Integer);
begin
//  Assert(ANewPosID <> AOldPosID);
  Assert(AParameterID > 0);
  Assert(ACategoryID > 0);

  // Устанавливаем параметры запроса
  SetParameters(['OLD_POSID', 'NEW_POSID', 'OLD_ORDER', 'NEW_ORDER', 'ParameterID', 'CATEGORYID'],
    [AOldPosID, ANewPosID, AOldOrder, ANewOrder, AParameterID, ACategoryID]);
  // Выполняем запрос
  FDQuery.ExecSQL;
end;

end.
