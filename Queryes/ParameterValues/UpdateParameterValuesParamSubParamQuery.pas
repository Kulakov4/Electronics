unit UpdateParameterValuesParamSubParamQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TqUpdateParameterValuesParamSubParam = class(TQueryBase)
    fdqDelete: TFDQuery;
    fdqUpdate: TFDQuery;
  private
    { Private declarations }
  public
    procedure ExecUpdateSQL(ANewParamSubParamID, AOldParamSubParamID, ACategoryID:
        Integer);
    class procedure DoUpdate(ANewParamSubParamID, AOldParamSubParamID, ACategoryId:
        Integer); static;
    class procedure DoDelete(AParamSubParamID, ACategoryId: Integer); static;
    procedure ExecDeleteSQL(const AParamSubParamID, ACategoryID: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TqUpdateParameterValuesParamSubParam.ExecUpdateSQL(
    ANewParamSubParamID, AOldParamSubParamID, ACategoryID: Integer);
begin
  Assert(ANewParamSubParamID > 0);
  Assert(AOldParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(fdqUpdate.SQL);
  FDQuery.Params.Assign(fdqUpdate.Params);

  SetParameters(['NewParamSubParamID', 'OldParamSubParamID', 'ProductCategoryId'],
    [ANewParamSubParamID, AOldParamSubParamID, ACategoryID]);

  // Выполняем SQL запрос
  FDQuery.ExecSQL;
end;

class procedure TqUpdateParameterValuesParamSubParam.DoUpdate(
    ANewParamSubParamID, AOldParamSubParamID, ACategoryId: Integer);
var
  Q: TqUpdateParameterValuesParamSubParam;
begin
  Q := TqUpdateParameterValuesParamSubParam.Create(nil);
  try
    Q.ExecUpdateSQL(ANewParamSubParamID, AOldParamSubParamID, ACategoryId);
  finally
    FreeAndNil(Q);
  end;
end;

class procedure TqUpdateParameterValuesParamSubParam.DoDelete(AParamSubParamID,
    ACategoryId: Integer);
var
  Q: TqUpdateParameterValuesParamSubParam;
begin
  Q := TqUpdateParameterValuesParamSubParam.Create(nil);
  try
    Q.ExecDeleteSQL(AParamSubParamID, ACategoryId);
  finally
    FreeAndNil(Q);
  end;
end;

procedure TqUpdateParameterValuesParamSubParam.ExecDeleteSQL(const
    AParamSubParamID, ACategoryID: Integer);
begin
  Assert(AParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // Копируем запрос
  FDQuery.SQL.Assign(fdqDelete.SQL);
  FDQuery.Params.Assign(fdqDelete.Params);

  // Устанавливаем параметры запроса
  SetParameters(['OldParamSubParamID', 'ProductCategoryId'],
    [AParamSubParamID, ACategoryID]);

  // Выполняем запрос
  FDQuery.ExecSQL;
end;

end.
