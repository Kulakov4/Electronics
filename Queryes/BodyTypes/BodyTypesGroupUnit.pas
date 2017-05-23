unit BodyTypesGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, BodyKindsQuery, BodyTypesQuery2, FireDAC.Comp.Client,
  NotifyEvents, BodyTypesExcelDataModule, QueryWithDataSourceUnit,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, QueryGroupUnit,
  ProducersQuery, OrderQuery, BodiesQuery, BodyTypesSimpleQuery,
  BodyTypesBaseQuery;

type
  TBodyTypesGroup = class(TQueryGroup)
    qBodyKinds: TQueryBodyKinds;
    qBodyTypes2: TQueryBodyTypes2;
    qProducers: TQueryProducers;
  private
    FAfterDataChange: TNotifyEventsEx;
    FOldIDBodyKind: Integer;
    FQueryBodyTypesSimple: TQueryBodyTypesSimple;
    procedure DoAfterDelete(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    function GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable;
        AIDProducer: Integer);
    // TODO: Append
    /// / TODO: InsertRecordList
    /// /  procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable);
    // function Append(APackage, AOutlineDrawing, ALandPattern, AVariation: String):
    // Integer;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property QueryBodyTypesSimple: TQueryBodyTypesSimple
      read GetQueryBodyTypesSimple;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB;

constructor TBodyTypesGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qBodyKinds;
  Detail := qBodyTypes2;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qBodyKinds.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyKinds.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterOpen, DoAfterOpen);

  // ��� ���������� ��������
  TNotifyEventWrap.Create(qBodyKinds.BeforeDelete, DoBeforeDelete);
  TNotifyEventWrap.Create(qBodyKinds.AfterDelete, DoAfterDelete);
end;

procedure TBodyTypesGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(FOldIDBodyKind > 0);
  // �������� ������� ���� ��������
  qBodyTypes2.CascadeDelete(FOldIDBodyKind, qBodyTypes2.IDBodyKind.FieldName);
end;

procedure TBodyTypesGroup.DoAfterOpen(Sender: TObject);
begin
  // ��������� ���������� �������� 1-�� ������
  // qBodyTypesBranch1.Load(1);
  // ��������� ���������� �������� 2-�� ������
  // qBodyTypesBranch2.Load(2);
end;

procedure TBodyTypesGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TBodyTypesGroup.DoBeforeDelete(Sender: TObject);
begin
  FOldIDBodyKind := qBodyKinds.PKValue;
  // �������� ������� ���� ��������
//  qBodyTypes2.CascadeDelete(qBodyKinds.PKValue,
//    qBodyTypes2.IDBodyKind.FieldName);
end;

function TBodyTypesGroup.GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
begin
  if FQueryBodyTypesSimple = nil then
  begin
    FQueryBodyTypesSimple := TQueryBodyTypesSimple.Create(Self);
  end;

  Result := FQueryBodyTypesSimple;
end;

procedure TBodyTypesGroup.InsertRecordList(ABodyTypesExcelTable:
    TBodyTypesExcelTable; AIDProducer: Integer);
var
  AField: TField;
  F: TField;
begin
  Assert(AIDProducer > 0);
  ABodyTypesExcelTable.DisableControls;
  try
    QueryBodyTypesSimple.RefreshQuery;

    ABodyTypesExcelTable.First;
    ABodyTypesExcelTable.CallOnProcessEvent;
    QueryBodyTypesSimple.ClearUpdateRecCount;
    while not ABodyTypesExcelTable.Eof do
    begin
      // ���� ��� ��������� ������ - ��� �������
      qBodyKinds.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);

      QueryBodyTypesSimple.TryAppend;
      QueryBodyTypesSimple.IDProducer.AsInteger := AIDProducer;
      QueryBodyTypesSimple.IDBodyKind.AsInteger := qBodyKinds.PKValue;

      for AField in ABodyTypesExcelTable.Fields do
      begin
        F := QueryBodyTypesSimple.FDQuery.FindField(AField.FieldName);
        if F <> nil then
          F.Value := AField.Value;
      end;

      QueryBodyTypesSimple.TryPost;
      QueryBodyTypesSimple.IncUpdateRecCount;

      ABodyTypesExcelTable.Next;
      ABodyTypesExcelTable.CallOnProcessEvent;
    end;
    // ��������� ������
    QueryBodyTypesSimple.FDQuery.Connection.Commit;

    // ��������� ������ � ��������������� �������
    qBodyTypes2.RefreshQuery;
  finally
    ABodyTypesExcelTable.EnableControls;
  end;

end;

end.
