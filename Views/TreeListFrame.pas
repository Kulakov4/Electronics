unit TreeListFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxInplaceContainer, cxTLData, cxDBTL, dxSkinsdxBarPainter,
  cxClasses, dxBar, System.Actions, Vcl.ActnList, cxGridDBBandedTableView,
  Data.DB, cxDropDownEdit, cxDBLookupComboBox, System.Generics.Collections;

type
  TfrmTreeList = class(TFrame)
    cxDBTreeList: TcxDBTreeList;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    procedure cxDBTreeListEdited(Sender: TcxCustomTreeList; AColumn:
        TcxTreeListColumn);
  private
    FPostOnEnterFields: TList<String>;
    { Private declarations }
  protected
    procedure InitializeComboBoxColumn(AColumn: TcxDBTreeListColumn;
        ADropDownListStyle: TcxEditDropDownListStyle; AField: TField); overload;
    procedure InitializeLookupColumn(AColumn: TcxDBTreeListColumn; ADataSource:
        TDataSource; ADropDownListStyle: TcxEditDropDownListStyle; const
        AListFieldNames: string; const AKeyFieldNames: string = 'ID'); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FocusedNodeValue(AcxDBTreeListColumn: TcxDBTreeListColumn): Variant;
    procedure UpdateView; virtual;
    property PostOnEnterFields: TList<String> read FPostOnEnterFields;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmTreeList.Create(AOwner: TComponent);
begin
  inherited;
  // —писок полей при редактировании которых Enter - сохранение
  FPostOnEnterFields := TList<String>.Create;
end;

destructor TfrmTreeList.Destroy;
begin
  FreeAndNil(FPostOnEnterFields);
  inherited;
end;

procedure TfrmTreeList.cxDBTreeListEdited(Sender: TcxCustomTreeList; AColumn:
    TcxTreeListColumn);
begin
  // ≈сли закончили редактирование группы
  if (Sender.FocusedNode <> nil) and (Sender.FocusedNode.IsGroupNode) then
    Sender.Post
  else
  begin
    if FPostOnEnterFields.IndexOf( (AColumn as TcxDBTreeListColumn).DataBinding.FieldName ) >= 0 then
      Sender.Post
  end;

  UpdateView;
end;

function TfrmTreeList.FocusedNodeValue(AcxDBTreeListColumn:
    TcxDBTreeListColumn): Variant;
var
  ANode: TcxTreeListNode;
begin
  Assert(AcxDBTreeListColumn <> nil);
  ANode := cxDBTreeList.FocusedNode;
  Assert(ANode <> nil);
  Result := ANode.Values[AcxDBTreeListColumn.ItemIndex];
end;

procedure TfrmTreeList.InitializeComboBoxColumn(AColumn: TcxDBTreeListColumn;
    ADropDownListStyle: TcxEditDropDownListStyle; AField: TField);
var
  AcxComboBoxProperties: TcxComboBoxProperties;
begin
  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxComboBoxProperties;
  AcxComboBoxProperties := AColumn.Properties as TcxComboBoxProperties;
  AcxComboBoxProperties.DropDownListStyle := ADropDownListStyle;

  // «аполн€ем выпадающий список значени€ми из запроса
  AcxComboBoxProperties.Items.Clear;
  AField.DataSet.First;
  while not AField.DataSet.Eof do
  begin
    AcxComboBoxProperties.Items.Add(AField.AsString);
    AField.DataSet.Next;
  end;
end;

procedure TfrmTreeList.InitializeLookupColumn(AColumn: TcxDBTreeListColumn;
    ADataSource: TDataSource; ADropDownListStyle: TcxEditDropDownListStyle;
    const AListFieldNames: string; const AKeyFieldNames: string = 'ID');
var
  AcxLookupComboBoxProperties: TcxLookupComboBoxProperties;
begin
  Assert(AColumn <> nil);
  Assert(ADataSource <> nil);
  Assert(not AListFieldNames.IsEmpty);
  Assert(not AKeyFieldNames.IsEmpty);

  Assert(AColumn <> nil);

  AColumn.PropertiesClass := TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties :=
    AColumn.Properties as TcxLookupComboBoxProperties;
  AcxLookupComboBoxProperties.ListSource := ADataSource;
  AcxLookupComboBoxProperties.ListFieldNames := AListFieldNames;
  AcxLookupComboBoxProperties.KeyFieldNames := AKeyFieldNames;
  AcxLookupComboBoxProperties.DropDownListStyle := ADropDownListStyle;
end;

procedure TfrmTreeList.UpdateView;
begin
end;

end.
