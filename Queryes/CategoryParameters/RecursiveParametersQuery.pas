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
    FDQueryUpdateOrd: TFDQuery;
    FDQueryUpdateNegativeOrder: TFDQuery;
  private
    { Private declarations }
  public
    procedure ExecUpdateSQL(const AOldPosID, ANewPosID, AOldOrder, ANewOrder,
      AOldIsAttribute, ANewIsAttribute, AOldParamSubParamID,
      ANewParamSubParamID, ACategoryID: Integer);
    procedure ExecDeleteSQL(const AParamSubParamID, ACategoryID: Integer);
    procedure ExecInsertSQL(APosID, AOrder: Integer;
      const AParamSubParamID, ACategoryID: Integer);
    procedure ExecUpdateOrdSQL(const AOldPosID, ANewPosID, AOldOrder, ANewOrder,
      AParamSubParamID, ACategoryID: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryRecursiveParameters.ExecUpdateSQL(const AOldPosID, ANewPosID,
  AOldOrder, ANewOrder, AOldIsAttribute, ANewIsAttribute, AOldParamSubParamID,
  ANewParamSubParamID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(ANewParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // �������� ������
  FDQuery.SQL.Assign(FDQueryUpdate.SQL);
  FDQuery.Params.Assign(FDQueryUpdate.Params);

  // ������������� ��������� �������
  SetParameters(['OLD_POSID', 'NEW_POSID', 'OLD_ORD', 'NEW_ORD',
    'OLD_ISATTRIBUTE', 'NEW_ISATTRIBUTE', 'OLD_PARAMSUBPARAMID',
    'NEW_PARAMSUBPARAMID', 'CATEGORYID'], [AOldPosID, ANewPosID, AOldOrder,
    ANewOrder, AOldIsAttribute, ANewIsAttribute, AOldParamSubParamID,
    ANewParamSubParamID, ACategoryID]);
  // ��������� ������
  FDQuery.ExecSQL;
end;

procedure TQueryRecursiveParameters.ExecDeleteSQL(const AParamSubParamID,
  ACategoryID: Integer);
begin
  Assert(AParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // �������� ������
  FDQuery.SQL.Assign(FDQueryDelete.SQL);
  FDQuery.Params.Assign(FDQueryDelete.Params);

  // ������������� ��������� �������
  SetParameters(['ParamSubParamID', 'CATEGORYID'],
    [AParamSubParamID, ACategoryID]);
  // ��������� ������
  FDQuery.ExecSQL;
end;

procedure TQueryRecursiveParameters.ExecInsertSQL(APosID, AOrder: Integer;
  const AParamSubParamID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(AParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // �������� ������
  FDQuery.SQL.Assign(FDQueryInsert.SQL);
  FDQuery.Params.Assign(FDQueryInsert.Params);

  // ������������� ��������� �������
  SetParameters(['PosID', 'Ord', 'ParamSubParamID', 'CATEGORYID'],
    [APosID, -AOrder, AParamSubParamID, ACategoryID]);
  // ��������� ������
  FDQuery.ExecSQL;
end;

procedure TQueryRecursiveParameters.ExecUpdateOrdSQL(const AOldPosID, ANewPosID,
  AOldOrder, ANewOrder, AParamSubParamID, ACategoryID: Integer);
begin
  // Assert(ANewPosID <> AOldPosID);
  Assert(AParamSubParamID > 0);
  Assert(ACategoryID > 0);

  // �������� ������
  FDQuery.SQL.Assign(FDQueryUpdateOrd.SQL);
  FDQuery.Params.Assign(FDQueryUpdateOrd.Params);

  // ������������� ��������� �������
  // ������� ������� ������ �� �������������, ����� �������� ����������� ������������
  SetParameters(['OLD_POSID', 'NEW_POSID', 'OLD_ORD', 'NEW_ORD',
    'PARAMSUBPARAMID', 'CATEGORYID'], [AOldPosID, ANewPosID, AOldOrder,
    -ANewOrder, AParamSubParamID, ACategoryID]);
  // ��������� ������
  FDQuery.ExecSQL;

  // ����� ������ ������������� ������� �� �������������
//  FDQuery.SQL.Assign(FDQueryUpdateNegativeOrder.SQL);
//  FDQuery.ExecSQL;
end;

end.
