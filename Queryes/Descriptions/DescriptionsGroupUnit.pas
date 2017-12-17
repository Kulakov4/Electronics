unit DescriptionsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, DescriptionTypesQuery, DescriptionsQuery,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, ProducersQuery, NotifyEvents,
  DescriptionsExcelDataModule, QueryWithDataSourceUnit, BaseQuery,
  BaseEventsQuery, QueryWithMasterUnit, QueryGroupUnit, OrderQuery,
  System.Generics.Collections, ProducersGroupUnit;

type
  TDescriptionsGroup = class(TQueryGroup)
    qDescriptionTypes: TQueryDescriptionTypes;
    qDescriptions: TQueryDescriptions;
  private
    FAfterDataChange: TNotifyEventsEx;
    FProducersGroup: TProducersGroup;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoAfterDelete(Sender: TObject);
    function GetProducersGroup: TProducersGroup;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Commit; override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure InsertRecordList(ADescriptionsExcelTable
      : TDescriptionsExcelTable);
    procedure LocateDescription(AIDDescription: Integer);
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property ProducersGroup: TProducersGroup read GetProducersGroup;
    { Public declarations }
  end;

implementation

uses
  FireDAC.Comp.DataSet, Data.DB, RepositoryDataModule;

{$R *.dfm}

constructor TDescriptionsGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qDescriptionTypes;
  Detail := qDescriptions;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qDescriptionTypes.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptionTypes.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptions.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptions.AfterDelete, DoAfterPostOrDelete);

  // ƒл€ каскадного удалени€
  TNotifyEventWrap.Create(qDescriptionTypes.AfterDelete, DoAfterDelete);
end;

procedure TDescriptionsGroup.Commit;
begin
  Inherited;
  // qProducers.DropUnuses;
end;

procedure TDescriptionsGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TDescriptionsGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(qDescriptionTypes.OldPKValue > 0);
  //  аскадно удал€ем производителей
  qDescriptions.CascadeDelete(qDescriptionTypes.OldPKValue,
    qDescriptions.IDComponentType.FieldName, True);
end;

function TDescriptionsGroup.Find(const AFieldName, S: string): TList<String>;
var
  OK: Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // ѕытаемс€ искать среди кратких описаний по какому-то полю
  if qDescriptions.LocateByField(AFieldName, S) then
  begin
    OK := qDescriptionTypes.LocateByPK(qDescriptions.IDComponentType.Value);
    Assert(OK);
    // запоминаем что надо искать на первом уровне
    Result.Add(qDescriptionTypes.ComponentType.AsString);
    // запоминаем что надо искать на втором уровне
    Result.Add(S);
  end
  else
    // ѕытаемс€ искать среди типов кратких описаний
    if qDescriptionTypes.LocateByField(qDescriptionTypes.ComponentType.FieldName, S) then
    begin
      Result.Add(S);
    end;

end;

function TDescriptionsGroup.GetProducersGroup: TProducersGroup;
begin
  if FProducersGroup = nil then
    FProducersGroup := TProducersGroup.Create(Self);

  Result := FProducersGroup;
end;

procedure TDescriptionsGroup.InsertRecordList(ADescriptionsExcelTable
  : TDescriptionsExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    // ÷икл по всем запис€м, которые будем добавл€ть
    ADescriptionsExcelTable.First;
    ADescriptionsExcelTable.CallOnProcessEvent;
    while not ADescriptionsExcelTable.Eof do
    begin
      qDescriptionTypes.LocateOrAppend
        (ADescriptionsExcelTable.ComponentType.AsString);

      ProducersGroup.LocateOrAppend(ADescriptionsExcelTable.Producer.AsString, ' раткие описани€');

      qDescriptions.FDQuery.Append;

      for I := 0 to ADescriptionsExcelTable.FieldCount - 1 do
      begin
        AField := qDescriptions.FDQuery.FindField
          (ADescriptionsExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ADescriptionsExcelTable.Fields[I].Value;
      end;
      qDescriptions.IDComponentType.Value := qDescriptionTypes.PK.Value;
      qDescriptions.IDProducer.Value := ProducersGroup.qProducers.PK.Value;
      qDescriptions.FDQuery.Post;

      ADescriptionsExcelTable.Next;
      ADescriptionsExcelTable.CallOnProcessEvent;
    end;

  finally
    qDescriptions.FDQuery.EnableControls;
    qDescriptionTypes.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsGroup.LocateDescription(AIDDescription: Integer);
begin
  Assert(AIDDescription > 0);

  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    qDescriptions.LocateByPK(AIDDescription);
    qDescriptionTypes.LocateByPK(qDescriptions.IDComponentType.AsInteger );
  finally
    qDescriptionTypes.FDQuery.EnableControls;
    qDescriptions.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsGroup.ReOpen;
begin
  qDescriptionTypes.RefreshQuery;
  qDescriptions.RefreshQuery;
  ProducersGroup.ReOpen;
end;

procedure TDescriptionsGroup.Rollback;
begin
  inherited;
end;

end.
