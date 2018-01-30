unit CategoryParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Data.DB, CategoryParametersQuery2,
  System.Generics.Collections;

type
  TCategoryFDMemTable = class(TFDMemTable)
  protected
    procedure DeleteTail(AFromRecNo: Integer);
  public
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetID: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property ID: TField read GetID;
  end;

  TQryCategorySubParameters = class(TCategoryFDMemTable)
  private
    function GetIDCategoryParam: TField;
  public
    constructor Create(AOwner: TComponent); override;
    property IDCategoryParam: TField read GetIDCategoryParam;
  end;

  TCategoryParametersGroup = class(TQueryGroup)
  private
    FqCategoryParameters: TQryCategoryParameters;
    FqCategoryParameters2: TQueryCategoryParameters2;
    FqCategorySubParameters: TQryCategorySubParameters;
    procedure DoAfterLoad(Sender: TObject);
    { Private declarations }
  protected
    procedure LoadData;
  public
    constructor Create(AOwner: TComponent); override;
    property qCategoryParameters: TQryCategoryParameters
      read FqCategoryParameters;
    property qCategoryParameters2: TQueryCategoryParameters2
      read FqCategoryParameters2;
    property qCategorySubParameters: TQryCategorySubParameters
      read FqCategorySubParameters;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

constructor TQryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('Value', ftWideString, 200);
  FieldDefs.Add('TableName', ftWideString, 200);
  FieldDefs.Add('ValueT', ftWideString, 200);
  FieldDefs.Add('ParameterType', ftWideString, 30);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
end;

function TQryCategoryParameters.GetIsAttribute: TField;
begin
  Result := FieldByName('IsAttribute');
end;

function TQryCategoryParameters.GetOrd: TField;
begin
  Result := FieldByName('Ord');
end;

function TQryCategoryParameters.GetID: TField;
begin
  Result := FieldByName('ID');
end;

constructor TQryCategorySubParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDCategoryParam', ftInteger);
  FieldDefs.Add('Name', ftWideString, 200);
  FieldDefs.Add('Translation', ftWideString, 200);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
end;

function TQryCategorySubParameters.GetIDCategoryParam: TField;
begin
  Result := FieldByName('IDCategoryParam');
end;

constructor TCategoryParametersGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqCategoryParameters2 := TQueryCategoryParameters2.Create(Self);
  FqCategoryParameters := TQryCategoryParameters.Create(Self);
  FqCategorySubParameters := TQryCategorySubParameters.Create(Self);

  TNotifyEventWrap.Create(FqCategoryParameters2.AfterLoad, DoAfterLoad);
end;

procedure TCategoryParametersGroup.DoAfterLoad(Sender: TObject);
begin
  LoadData;
end;

procedure TCategoryParametersGroup.LoadData;
var
  AFieldList: TStringList;
begin
  AFieldList := TStringList.Create;
  try
    qCategoryParameters.Fields.GetFieldNames(AFieldList);
    // Эти поля могут отличаться при группировке
    AFieldList.Delete(AFieldList.IndexOf(qCategoryParameters.ID.FieldName));
    AFieldList.Delete
      (AFieldList.IndexOf(qCategoryParameters.IsAttribute.FieldName));
    AFieldList.Delete(AFieldList.IndexOf(qCategoryParameters.Ord.FieldName));
    Assert(AFieldList.Count > 0);

    qCategoryParameters2.FDQuery.DisableControls;
    try
      qCategoryParameters2.FDQuery.First;
      qCategoryParameters.First;
      while not qCategoryParameters2.FDQuery.Eof do
      begin
        qCategoryParameters.LoadRecFrom(qCategoryParameters2.FDQuery,
          AFieldList);
        if qCategoryParameters.ID.IsNull then
        begin
          qCategoryParameters.Edit;
          qCategoryParameters.ID.AsInteger := qCategoryParameters2.PK.Value;
          qCategoryParameters.IsAttribute.Value :=
            qCategoryParameters2.IsAttribute.Value;
          qCategoryParameters.Ord.Value := qCategoryParameters2.Ord.Value;
          qCategoryParameters.Post;
        end;

        if qCategoryParameters2.IsDefault.AsInteger = 0 then
        begin
          qCategorySubParameters.LoadRecFrom(qCategoryParameters2.FDQuery, nil);
          qCategorySubParameters.Edit;
          qCategorySubParameters.IDCategoryParam.AsInteger :=
            qCategoryParameters.ID.AsInteger;
          qCategorySubParameters.Post;
        end;
        qCategoryParameters2.FDQuery.Next;
      end;
      qCategorySubParameters.DeleteTail(qCategorySubParameters.RecNo + 1);
      qCategoryParameters.DeleteTail(qCategoryParameters.RecNo + 1);
    finally
      qCategoryParameters2.FDQuery.EnableControls;
    end;
  finally
    FreeAndNil(AFieldList);
  end;
end;

procedure TCategoryFDMemTable.DeleteTail(AFromRecNo: Integer);
begin
  if RecordCount < AFromRecNo then
    Exit;

  DisableControls;
  try

    while RecordCount >= AFromRecNo do
    begin
      RecNo := AFromRecNo;
      Delete;
    end;

  finally
    EnableControls;
  end;
end;

procedure TCategoryFDMemTable.LoadRecFrom(ADataSet: TDataSet;
  AFieldList: TStrings);
var
  AFieldName: String;
  AFL: TStrings;
  AUF: TDictionary<String, Variant>;
  F: TField;
  FF: TField;
  NeedAppend: Boolean;
begin
  Assert(ADataSet <> nil);
  Assert(ADataSet.RecordCount > 0);

  if AFieldList = nil then
  begin
    AFL := TStringList.Create;
    ADataSet.Fields.GetFieldNames(AFL);
  end
  else
    AFL := AFieldList;

  Assert(AFL.Count > 0);

  NeedAppend := False;

  AUF := TDictionary<String, Variant>.Create;
  try
    // Цикл по всем полям
    for F in ADataSet.Fields do
    begin
      if AFL.IndexOf(F.FieldName) = -1 then
        Continue;

      FF := FindField(F.FieldName);
      if (FF <> nil) then
      begin
        NeedAppend := NeedAppend or (FF.Value <> F.Value);

        AUF.Add(FF.FieldName, F.Value);
      end;
    end;

    // Если есть отличающиеся заначения
    if NeedAppend then
    begin
      Append;

      for AFieldName in AUF.Keys do
      begin
        FieldByName(AFieldName).Value := AUF[AFieldName];
      end;

      Post;
    end;

  finally
    FreeAndNil(AUF);
    if AFieldList = nil then
      FreeAndNil(AFL);
  end;
end;

{$R *.dfm}

end.
