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
    procedure DefaultOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure HideNullGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
// TODO: FIsModifedClone
//  FIsModifedClone: TFDMemTable;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    procedure InitializeFields;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
// TODO: IsModifed
//  function IsModifed(APKValue: Variant): Boolean;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryWithDataSource.Create(AOwner: TComponent);
begin
  inherited;

  // ¬се пол€ будем выравнивать по левому краю + клонировать курсор (если надо)
  TNotifyEventWrap.Create(Wrap.AfterOpen, DoAfterOpen, Wrap.EventList);

  // ¬о всех строковых пол€х будем удал€ть начальные и конечные пробелы
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
end;

procedure TQueryWithDataSource.DefaultOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := VarToStr(Sender.Value);
end;

procedure TQueryWithDataSource.DoAfterOpen(Sender: TObject);
var
  i: Integer;
begin
  //  остыль с некоторыми типами полей
  InitializeFields;

  // делаем выравнивание всех полей по левому краю
  for i := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[i].Alignment := taLeftJustify;
end;

procedure TQueryWithDataSource.DoBeforePost(Sender: TObject);
var
  i: Integer;
  S: string;
begin
  // ”бираем начальные и конечные пробелы в строковых пол€х
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

// TODO: IsModifed
//function TQueryWithDataSource.IsModifed(APKValue: Variant): Boolean;
//var
//AFDDataSet: TFDDataSet;
//OK: Boolean;
//begin
//// ≈сли провер€ем текущую запись
//if PK.Value = APKValue then
//  AFDDataSet := FDQuery
//else
//begin
//  // ƒл€ проверки другой записи надо создать клон
//  if FIsModifedClone = nil then
//  begin
//    // —оздаЄм клон
//    FIsModifedClone := AddClone('');
//  end;
//  OK := FIsModifedClone.LocateEx(PKFieldName, APKValue);
//  Assert(OK);
//  AFDDataSet := FIsModifedClone;
//end;
//
//Result := AFDDataSet.UpdateStatus in [usModified, usInserted]
//end;

end.
