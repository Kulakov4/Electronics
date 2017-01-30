unit BodyTypesTreeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls,
  System.Generics.Collections, ApplyQueryFrame, BodyTypesExcelDataModule3,
  NotifyEvents;

const
  WM_arInsert = WM_USER + 139;

type
  TQueryBodyTypesTree = class(TfrmDataModule)
    qBodyTypes: TfrmApplyQuery;
    qBodyVariations: TfrmApplyQuery;
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    FAfterDataChange: TNotifyEventsEx;
    FID: Integer;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    function GetIDParentBodyType: TField;
    function GetImage: TField;
    function GetLandPattern: TField;
    function GetLevel: TField; overload;
    function GetOutlineDrawing: TField;
    function GetVariation: TField;
    { Private declarations }
  protected
    procedure AddRootValue(const AValue: string);
    procedure AddValue(AIDParent: Integer; const AValue: string);
    procedure DeleteSelfDetail(AIDMaster: Variant); override;
    procedure DoAfterInsertMessage(var Message: TMessage); message WM_arInsert;
    function GetLevel(AID: Integer): Integer; overload;
    procedure LocateOrAppend(AIDParent: Integer; const AValue: string);
    function LocateVariation(AIDParent: Integer; const AValue: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddNode(AIDParent: Integer);
    procedure AddRoot;
    procedure AddVariation(AIDParent: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable3);
    procedure LocateOrAppendRoot(const AValue: string);
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property IDParentBodyType: TField read GetIDParentBodyType;
    property Image: TField read GetImage;
    property LandPattern: TField read GetLandPattern;
    property Level: TField read GetLevel;
    property OutlineDrawing: TField read GetOutlineDrawing;
    property Variation: TField read GetVariation;
    { Public declarations }
  end;

implementation

uses
  DBRecordHolder, RepositoryDataModule, System.Math;

{$R *.dfm}

constructor TQueryBodyTypesTree.Create(AOwner: TComponent);
begin
  inherited;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen);

  TNotifyEventWrap.Create(AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(AfterDelete, DoAfterPostOrDelete);

  FID := 0;
  // Подписываемся на событие перед удалением
  TNotifyEventWrap.Create(BeforeDelete, DoBeforeDelete, FEventList);

  AutoTransaction := False;
end;

destructor TQueryBodyTypesTree.Destroy;
begin
  inherited;
end;

procedure TQueryBodyTypesTree.AddNode(AIDParent: Integer);
var
  ALevel: Integer;
begin
  Assert(AIDParent > 0);
  ALevel := GetLevel(AIDParent) + 1;
  FDQuery.Append;
  IDParentBodyType.AsInteger := AIDParent;
  Level.AsInteger := ALevel;
end;

procedure TQueryBodyTypesTree.AddRoot;
begin
  FDQuery.Append;
  Level.AsInteger := 0;
end;

procedure TQueryBodyTypesTree.AddRootValue(const AValue: string);
begin
  FDQuery.Append;
  Level.AsInteger := 0;
  OutlineDrawing.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryBodyTypesTree.AddValue(AIDParent: Integer;
  const AValue: string);
var
  ALevel: Integer;
begin
  ALevel := GetLevel(AIDParent) + 1;

  FDQuery.Append;
  IDParentBodyType.AsInteger := AIDParent;
  OutlineDrawing.AsString := AValue;
  Level.AsInteger := ALevel;
  FDQuery.Post;
end;

procedure TQueryBodyTypesTree.AddVariation(AIDParent: Integer);
begin
  FDQuery.Append;
  IDParentBodyType.AsInteger := AIDParent;
  Level.AsInteger := 100;
end;

procedure TQueryBodyTypesTree.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryBodyTypesTree.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryBodyTypesTree.DeleteSelfDetail(AIDMaster: Variant);
var
  X: Integer;
begin
  Assert(not VarIsNull(AIDMaster));
  X := AIDMaster;
  // Удаляем все записи удовлетворяющие фильру
  DeleteByFilter(Format('%s = %d', [IDParentBodyType.FieldName, X]));
end;

procedure TQueryBodyTypesTree.DoAfterInsertMessage(var Message: TMessage);
var
  AID: Integer;
begin
  AID := Message.WParam;

  if LocateByPK(AID) then
  begin
    FDQuery.Edit;
    FDQuery.Post;
  end;
end;

procedure TQueryBodyTypesTree.DoAfterOpen(Sender: TObject);
var
  I: Integer;
begin
  // Поле ID то LargeInt то WideString
  FDQuery.FieldByName('ID').ProviderFlags := [pfInKey];
  for I := 0 to FDQuery.FieldCount - 1 do
    FDQuery.Fields[I].ReadOnly := False;
end;

procedure TQueryBodyTypesTree.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TQueryBodyTypesTree.DoBeforeDelete(Sender: TObject);
begin
  FID := IfThen(FDQuery.RecordCount > 0, PKValue, 0);
end;

procedure TQueryBodyTypesTree.FDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AID: Integer;
  RH: TRecordHolder;
begin
  RH := TRecordHolder.Create();
  try
    RH.Attach(ASender);
    case ARequest of
      arDelete:
        begin
          AID := ASender.FieldByName(PKFieldName).AsInteger;
          if (AID = 0) then
            AID := FID;
          if AID <> 0 then
          begin
            if AID > 0 then
            begin
              qBodyTypes.DeleteRecord(AID);
            end
            else
            begin
              qBodyVariations.DeleteRecord(-AID);
            end;
            AAction := eaApplied;
          end
          // else
          // AAction := eaRetry;
        end;
      arInsert:
        begin
          if ASender.FieldByName('level').AsInteger = 100 then
          begin
            // Делаем замену названия полей
            RH.Find('IDParentBodyType').FieldName := 'IDBodyType';
            qBodyVariations.InsertRecord(RH);
            AID := qBodyVariations.FDQuery.FieldByName(PKFieldName).AsInteger;
            ASender[PKFieldName] := -AID;
          end
          else
          begin
            // Делаем замену названия полей
            RH.Find('OutlineDrawing').FieldName := 'BodyType';
            qBodyTypes.InsertRecord(RH);
            AID := qBodyTypes.FDQuery.FieldByName(PKFieldName).AsInteger;
            // ASender[PKFieldName] := AID;
            ASender.FieldByName(PKFieldName).AsInteger := AID;
          end;
          AAction := eaApplied;
          // Заплатка.
          PostMessage(Handle, WM_arInsert, ASender[PKFieldName], 0);
        end;
      arUpdate:
        begin
          AID := ASender.FieldByName(PKFieldName).AsInteger;
          if AID > 0 then
          begin
            // Делаем замену названия полей
            RH.Find('OutlineDrawing').FieldName := 'BodyType';
            qBodyTypes.UpdateRecord(RH);
          end
          else
          begin
            RH.Field[PKFieldName] := -AID;
            qBodyVariations.UpdateRecord(RH);
          end;
          AAction := eaApplied;
        end;
    end;
  finally
    FreeAndNil(RH);
  end;
end;

function TQueryBodyTypesTree.GetIDParentBodyType: TField;
begin
  Result := Field('IDParentBodyType');
end;

function TQueryBodyTypesTree.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryBodyTypesTree.GetLandPattern: TField;
begin
  Result := Field('LandPattern');
end;

function TQueryBodyTypesTree.GetLevel: TField;
begin
  Result := Field('Level');
end;

function TQueryBodyTypesTree.GetLevel(AID: Integer): Integer;
var
  V: Variant;
begin
  Assert(FDQuery.RecordCount > 0);

  if PKValue = AID then
    Result := Level.AsInteger
  else
  begin
    V := FDQuery.LookupEx(PKFieldName, AID, Level.FieldName);
    Assert(not VarIsNull(V));
    Result := V;
  end;
end;

function TQueryBodyTypesTree.GetOutlineDrawing: TField;
begin
  Result := Field('OutlineDrawing');
end;

function TQueryBodyTypesTree.GetVariation: TField;
begin
  Result := Field('Variation');
end;

procedure TQueryBodyTypesTree.InsertRecordList(ABodyTypesExcelTable
  : TBodyTypesExcelTable3);
var
  AField: TField;
  AIDParent: Integer;
  I: Integer;
begin
  ABodyTypesExcelTable.DisableControls;
  try
    ABodyTypesExcelTable.First;
    while not ABodyTypesExcelTable.Eof do
    begin
      // ищем или добавляем корень - вид корпуса
      LocateOrAppendRoot(ABodyTypesExcelTable.BodyKind.AsString);
      // Ищем или добавляем тип корпуса
      LocateOrAppend(PKValue, ABodyTypesExcelTable.BodyType.AsString);
      // Ищем или добавляем формфактор корпуса
      LocateOrAppend(PKValue, ABodyTypesExcelTable.Package.AsString);

      AIDParent := PKValue;
      // Ищем вариант корпуса
      if LocateVariation(AIDParent, ABodyTypesExcelTable.Variation.AsString)
      then
        FDQuery.Edit
      else
        FDQuery.Append;

      IDParentBodyType.AsInteger := AIDParent;

      // Заполняем остальные поля
      for I := 0 to ABodyTypesExcelTable.FieldCount - 1 do
      begin
        AField := FDQuery.FindField(ABodyTypesExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ABodyTypesExcelTable.Fields[I].Value;
      end;

      Level.AsInteger := 100;

      FDQuery.Post;

      ABodyTypesExcelTable.Next;
    end;

  finally
    ABodyTypesExcelTable.EnableControls;
  end;
end;

procedure TQueryBodyTypesTree.LocateOrAppend(AIDParent: Integer;
  const AValue: string);
begin
  if not FDQuery.LocateEx(Format('%s;%s', [IDParentBodyType.FieldName,
    OutlineDrawing.FieldName]), VarArrayOf([AIDParent, AValue]),
    [lxoCaseInsensitive]) then
    AddValue(AIDParent, AValue);

end;

procedure TQueryBodyTypesTree.LocateOrAppendRoot(const AValue: string);
begin
  // Ищем корневую запись
  if not FDQuery.LocateEx(Format('%s;%s', [IDParentBodyType.FieldName,
    OutlineDrawing.FieldName]), VarArrayOf([null, AValue]), [lxoCaseInsensitive])
  then
    AddRootValue(AValue);

end;

function TQueryBodyTypesTree.LocateVariation(AIDParent: Integer;
  const AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(Format('%s;%s', [IDParentBodyType.FieldName,
    Variation.FieldName]), VarArrayOf([AIDParent, AValue]),
    [lxoCaseInsensitive]);

end;

end.
