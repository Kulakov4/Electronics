unit QueryWithDataSourceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseEventsQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, QueryWithMasterUnit, BaseQuery;

const
  WM_ON_DATA_CHANGE = WM_USER + 559;

type
  TQueryWithDataSource = class(TQueryWithMaster)
    DataSource: TDataSource;
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DefaultOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure HideNullGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FIsModifedClone: TFDMemTable;
    FOnDataChange: TNotifyEventsEx;
    FResiveOnDataChangeMessage: Boolean;
    procedure DoAfterClose(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    procedure InitializeFields;
    { Private declarations }
  protected
    procedure ProcessOnDataChange(var Message: TMessage);
      message WM_ON_DATA_CHANGE;
  public
    constructor Create(AOwner: TComponent); override;
    function IsModifed(APKValue: Variant): Boolean;
    property OnDataChange: TNotifyEventsEx read FOnDataChange;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryWithDataSource.Create(AOwner: TComponent);
begin
  inherited;
  // Создаём события
  FOnDataChange := TNotifyEventsEx.Create(Self);
  FResiveOnDataChangeMessage := True;

  // Все поля будем выравнивать по левому краю + клонировать курсор (если надо)
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // Во всех строковых полях будем удалять начальные и конечные пробелы
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);

  // После закрытия будем закрывать своих клонов
  TNotifyEventWrap.Create(AfterClose, DoAfterClose, FEventList);
end;

procedure TQueryWithDataSource.DataSourceDataChange(Sender: TObject;
  Field: TField);
begin
  // если есть подписчики
  if (FOnDataChange.Count > 0) and (FResiveOnDataChangeMessage) then
  begin
    FResiveOnDataChangeMessage := False;
    PostMessage(Handle, WM_ON_DATA_CHANGE, 0, 0);
  end;
end;

procedure TQueryWithDataSource.DefaultOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := VarToStr(Sender.Value);
end;

procedure TQueryWithDataSource.DoAfterClose(Sender: TObject);
begin
  // Если ранее создали клона
  if FIsModifedClone <> nil then
    FIsModifedClone.Close; // закроем и клона
end;

procedure TQueryWithDataSource.DoAfterOpen(Sender: TObject);
var
  i: Integer;
begin
  // Костыль с некоторыми типами полей
  InitializeFields;

  // Если клона создавали раньше, то клонируем курсор
  if FIsModifedClone <> nil then
    FIsModifedClone.CloneCursor(FDQuery);

  // делаем выравнивание всех полей по левому краю
  for i := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[i].Alignment := taLeftJustify;
end;

procedure TQueryWithDataSource.DoBeforePost(Sender: TObject);
var
  i: Integer;
  S: string;
begin
  for i := 0 to FDQuery.FieldCount - 1 do
  begin
    if (FDQuery.Fields[i] is TStringField) and
      (not FDQuery.Fields[i].ReadOnly and not FDQuery.Fields[i].IsNull) then
    begin
      S := FDQuery.Fields[i].AsString.Trim;
      if FDQuery.Fields[i].AsString <> S then
        FDQuery.Fields[i].AsString := S;
    end;
  end;
end;

procedure TQueryWithDataSource.HideNullGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if VarIsNull(Sender.Value) or (Sender.Value = 0) then
    Text := ''
  else
    Text := Sender.Value;
end;

procedure TQueryWithDataSource.InitializeFields;
var
  i: Integer;
begin
  for i := 0 to FDQuery.Fields.Count - 1 do
  begin
    // TWideMemoField - событие OnGetText
    if FDQuery.Fields[i] is TWideMemoField then
      FDQuery.Fields[i].OnGetText := DefaultOnGetText;

    if FDQuery.Fields[i] is TFDAutoIncField then
      FDQuery.Fields[i].ProviderFlags := [pfInWhere, pfInKey];
  end;
end;

function TQueryWithDataSource.IsModifed(APKValue: Variant): Boolean;
var
  AFDDataSet: TFDDataSet;
  OK: Boolean;
begin
  // Если проверяем текущую запись
  if PK.Value = APKValue then
    AFDDataSet := FDQuery
  else
  begin
    // Для проверки другой записи надо создать клон
    if FIsModifedClone = nil then
    begin
      // Создаём набор данных в памяти
      FIsModifedClone := TFDMemTable.Create(Self);
      // Создаём клон себя
      FIsModifedClone.CloneCursor(FDQuery);
    end;
    OK := FIsModifedClone.LocateEx(PKFieldName, APKValue);
    Assert(OK);
    AFDDataSet := FIsModifedClone;
  end;

  Result := AFDDataSet.UpdateStatus in [usModified, usInserted]
end;

procedure TQueryWithDataSource.ProcessOnDataChange(var Message: TMessage);
begin
  FOnDataChange.CallEventHandlers(Self);
  FResiveOnDataChangeMessage := True;
end;

end.
