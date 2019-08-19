unit ProductCategoriesMemTable;

interface

uses
  FireDAC.Comp.Client, DSWrap, System.Classes, System.Generics.Collections;

type
  TProductCategoriesW = class(TDSWrap)
  private
    FProductCategoryID: TFieldWrap;
    FCategory: TFieldWrap;
    FExternalID: TFieldWrap;
    FChecked: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ProductCategoryID: TFieldWrap read FProductCategoryID;
    property Category: TFieldWrap read FCategory;
    property ExternalID: TFieldWrap read FExternalID;
    property Checked: TFieldWrap read FChecked;
  end;

  TProductCategoriesMemTbl = class(TFDMemTable)
  private
    FW: TProductCategoriesW;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(AProductCategoryID: Integer; AExternalID, ACategory: string);
    function GetChecked: TArray<Integer>;
    property W: TProductCategoriesW read FW;
  end;

implementation

uses
  Data.DB, FireDAC.Comp.DataSet, System.Variants, System.SysUtils;

constructor TProductCategoriesW.Create(AOwner: TComponent);
begin
  inherited;
  FProductCategoryID := TFieldWrap.Create(Self, 'ProductCategoryID', '', True);
  FCategory := TFieldWrap.Create(Self, 'Category', 'Категория');
  FExternalID := TFieldWrap.Create(Self, 'ExternalID', 'Идентификатор');
  FChecked := TFieldWrap.Create(Self, 'Checked', 'X');
end;

constructor TProductCategoriesMemTbl.Create(AOwner: TComponent);
var
  AFDIndex: TFDIndex;
begin
  inherited;
  FW := TProductCategoriesW.Create(Self);

  FieldDefs.Add(W.ProductCategoryID.FieldName, ftInteger);
  FieldDefs.Add(W.Checked.FieldName, ftInteger);
  FieldDefs.Add(W.ExternalID.FieldName, ftWideString, 20);
  FieldDefs.Add(W.Category.FieldName, ftWideString, 200);
{
  AFDIndex := Indexes.Add;
  AFDIndex.Name := 'by_' + W.ProductCategoryID.FieldName;
  AFDIndex.Fields := W.ProductCategoryID.FieldName;
  AFDIndex.Distinct := True;
  AFDIndex.Active := True;
  AFDIndex.Selected := True;
}
  CreateDataSet;
  Open;
end;

procedure TProductCategoriesMemTbl.Add(AProductCategoryID: Integer;
    AExternalID, ACategory: string);
var
  V: Variant;
begin
  V := LookupEx(W.ProductCategoryID.FieldName, AProductCategoryID, W.ProductCategoryID.FieldName);
  if not VarIsNull(V) then
    Exit;


  W.TryAppend;
  W.Checked.F.AsInteger := 1;
  W.ProductCategoryID.F.AsInteger := AProductCategoryID;
  W.ExternalID.F.AsString := AExternalID;
  W.Category.F.AsString := ACategory;
  W.TryPost;  // Пытаемся сохранить
end;

function TProductCategoriesMemTbl.GetChecked: TArray<Integer>;
var
  AClone: TFDMemTable;
  AIntList: TList<Integer>;
begin
  AIntList := TList<Integer>.Create;
  AClone := W.AddClone(Format('%s = %d', [W.Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      AIntList.Add( W.PK.AsInteger );
      AClone.Next;
    end;
    Result := AIntList.ToArray;
  finally
    W.DropClone(AClone);
    FreeAndNil(AIntList);
  end;
end;

end.
