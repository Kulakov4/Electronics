unit BodyTypesMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MasterDetailFrame, Vcl.ExtCtrls, BodyKindsQuery, BodyTypesQuery2,
  FireDAC.Comp.Client, NotifyEvents, BodyTypesExcelDataModule3,
  BodyTypesBranchQuery, QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery,
  QueryWithMasterUnit;

type
  TBodyTypesMasterDetail = class(TfrmMasterDetail)
    qBodyKinds: TQueryBodyKinds;
    qBodyTypes2: TQueryBodyTypes2;
    qBodyTypesBranch: TQueryBodyTypesBranch;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable3);
    // TODO: Append
    /// / TODO: InsertRecordList
    /// /  procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable);
    // function Append(APackage, AOutlineDrawing, ALandPattern, AVariation: String):
    // Integer;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB, BodyTypesTreeQuery;

constructor TBodyTypesMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  Main := qBodyKinds;
  Detail := qBodyTypes2;

  qBodyTypes2.QueryBodyTypesBranch := qBodyTypesBranch;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qBodyKinds.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyKinds.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterOpen, DoAfterOpen);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qBodyKinds.BeforeDelete, DoBeforeDelete);
end;

procedure TBodyTypesMasterDetail.DoAfterOpen(Sender: TObject);
begin
  // Загружаем справочник корпусов 1-го уровня
  // qBodyTypesBranch1.Load(1);
  // Загружаем справочник корпусов 2-го уровня
  // qBodyTypesBranch2.Load(2);
end;

procedure TBodyTypesMasterDetail.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TBodyTypesMasterDetail.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем типы корпусов
  qBodyTypes2.CascadeDelete(qBodyKinds.PKValue,
    qBodyTypes2.IDParentBodyType1.FieldName);
end;

procedure TBodyTypesMasterDetail.InsertRecordList(ABodyTypesExcelTable
  : TBodyTypesExcelTable3);
begin
  ABodyTypesExcelTable.DisableControls;
  try
    ABodyTypesExcelTable.First;
    while not ABodyTypesExcelTable.Eof do
    begin
      // ищем или добавляем корень - вид корпуса
      qBodyKinds.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);

      qBodyTypes2.LocateOrAppend(qBodyKinds.PKValue,
        ABodyTypesExcelTable.BodyType.AsString,
        ABodyTypesExcelTable.Package.AsString,
        ABodyTypesExcelTable.OutlineDrawing.AsString,
        ABodyTypesExcelTable.LandPattern.AsString,
        ABodyTypesExcelTable.Variation.AsString,
        ABodyTypesExcelTable.Image.AsString);

      ABodyTypesExcelTable.Next;
    end;

  finally
    ABodyTypesExcelTable.EnableControls;
  end;

  {

    qBodyTypes2.FDQuery.Close;
    qBodyKinds.FDQuery.Close;


    // Создаём набор данных ввиде дерева
    AQueryBodyTypesTree := TQueryBodyTypesTree.Create(Application.MainForm);
    try
    //    AQueryBodyTypesTree.FDQuery.Name := 'FDQuery1';
    AQueryBodyTypesTree.RefreshQuery;
    // Просим дерево загрузить данные из excel файла
    AQueryBodyTypesTree.InsertRecordList(ABodyTypesExcelTable);
    AQueryBodyTypesTree.ApplyUpdates;
    finally
    AQueryBodyTypesTree.FDQuery.Close;
    FreeAndNil(AQueryBodyTypesTree);
    end;

    qBodyKinds.FDQuery.Open;
    qBodyTypes2.FDQuery.Open;
  }
end;

end.
