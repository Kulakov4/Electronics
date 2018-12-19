unit DBLookupComboBoxHelper;

interface

uses
  DSWrap, cxDBLookupComboBox, Data.DB, cxDropDownEdit, cxDBLabel,
  cxDBExtLookupComboBox, cxGridCustomTableView, cxGridDBBandedTableView;

type
  TDBLCB = class(TObject)
  private
  public
    class procedure Init(AcxDBLookupComboBox: TcxDBLookupComboBox;
      ADataSource: TDataSource; const ADataField: string;
      AListSource: TDataSource; const AListFieldWrap: TFieldWrap;
      ADropDownListStyle: TcxEditDropDownListStyle = lsEditFixedList); static;
    class procedure InitProp(AcxLookupComboBoxProperties:
        TcxLookupComboBoxProperties; ADataSource: TDataSource; const
        AKeyFieldNames, AListFieldNames: String; ADropDownStyle:
        TcxEditDropDownListStyle); static;
  end;

  TDBL = class(TObject)
  public
    class procedure Init(AcxDBLabel: TcxDBLabel; ADataSource: TDataSource;
      const ADataField: TFieldWrap); static;
  end;

  TExtDBLCB = class(TObject)
  public
    class procedure InitProp(AcxExtLookupComboBoxProperties:
        TcxExtLookupComboBoxProperties; AView: TcxGridDBBandedTableView; const
        AKeyFieldNames, AListFieldNames: String; ADropDownStyle:
        TcxEditDropDownListStyle; ADropDownAutoSize, ADropDownSizeable: Boolean);
        static;
  end;

implementation

uses
  System.SysUtils;

class procedure TDBLCB.Init(AcxDBLookupComboBox: TcxDBLookupComboBox;
  ADataSource: TDataSource; const ADataField: string; AListSource: TDataSource;
  const AListFieldWrap: TFieldWrap;
  ADropDownListStyle: TcxEditDropDownListStyle = lsEditFixedList);
begin
  Assert(AcxDBLookupComboBox <> nil);
  Assert(ADataSource <> nil);
  Assert(not ADataField.IsEmpty);
  Assert(AListSource <> nil);

  AcxDBLookupComboBox.DataBinding.DataSource := ADataSource;
  AcxDBLookupComboBox.DataBinding.DataField := ADataField;

  InitProp(AcxDBLookupComboBox.Properties, AListSource,
    AListFieldWrap.DataSetWrap.PKFieldName,
    AListFieldWrap.FieldName, ADropDownListStyle);
end;

class procedure TDBLCB.InitProp(AcxLookupComboBoxProperties:
    TcxLookupComboBoxProperties; ADataSource: TDataSource; const
    AKeyFieldNames, AListFieldNames: String; ADropDownStyle:
    TcxEditDropDownListStyle);
begin
  Assert(AcxLookupComboBoxProperties <> nil);
  Assert(ADataSource <> nil);
  Assert(not AKeyFieldNames.IsEmpty);
  Assert(not AListFieldNames.IsEmpty);

  with AcxLookupComboBoxProperties do
  begin
    ListSource := ADataSource;
    KeyFieldNames := AKeyFieldNames;
    ListFieldNames := AListFieldNames;
    DropDownListStyle := ADropDownStyle;
  end;
end;

class procedure TDBL.Init(AcxDBLabel: TcxDBLabel; ADataSource: TDataSource;
  const ADataField: TFieldWrap);
begin
  Assert(AcxDBLabel <> nil);
  Assert(ADataSource <> nil);
  Assert(ADataField <> nil);

  with AcxDBLabel.DataBinding do
  begin
    DataSource := ADataSource;
    DataField := ADataField.FieldName;
  end;
end;

class procedure TExtDBLCB.InitProp(AcxExtLookupComboBoxProperties:
    TcxExtLookupComboBoxProperties; AView: TcxGridDBBandedTableView; const
    AKeyFieldNames, AListFieldNames: String; ADropDownStyle:
    TcxEditDropDownListStyle; ADropDownAutoSize, ADropDownSizeable: Boolean);
var
  AColumn: TcxGridDBBandedColumn;
begin
  Assert(AcxExtLookupComboBoxProperties <> nil);
  Assert(AView <> nil);
  Assert(not AKeyFieldNames.IsEmpty);
  Assert(not AListFieldNames.IsEmpty);

  AColumn := AView.GetColumnByFieldName(AListFieldNames);
  Assert(AColumn <> nil);

  with AcxExtLookupComboBoxProperties do
  begin
    View := AView;
    KeyFieldNames := AKeyFieldNames;
    ListFieldItem := AColumn;
//    ListFieldNames := AListFieldNames;
    DropDownListStyle := ADropDownStyle;
    DropDownAutoSize := ADropDownAutoSize;
    DropDownSizeable := ADropDownSizeable;
  end;
end;

end.
