unit ProductsView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView, cxGraphics,
  cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, dxBar,
  cxGridDBTableView, System.Actions, Vcl.ActnList, ProductsQuery,
  Vcl.ComCtrls, System.Generics.Collections, cxTextEdit, cxBlobEdit,
  cxButtonEdit, cxSpinEdit,
  cxCurrencyEdit, GridFrame, cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxDBLookupComboBox, CustomErrorTable, FieldInfoUnit;

type
  TViewProducts = class(TViewProductsBase)
    actAdd: TAction;
    actDelete: TAction;
    dxbrbtnAdd: TdxBarButton;
    dxbrbtnDelete: TdxBarButton;
    dxbrbtnSave: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actPasteComponents: TAction;
    N2: TMenuItem;
    procedure actAddExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actPasteComponentsExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure cxGridDBBandedTableViewSelectionChanged
      (Sender: TcxCustomGridTableView);
    procedure cxGridDBBandedTableViewDataControllerCompare(ADataController
      : TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure StatusBarResize(Sender: TObject);
  private
    procedure AfterDelete(Sender: TObject);
    procedure AfterLoad(Sender: TObject);
    procedure AfterOpen(Sender: TObject);
    procedure AfterPost(Sender: TObject);
    procedure BeforeLoad(Sender: TObject);
    function GetQueryProducts: TQueryProducts;
    procedure SetQueryProducts(const Value: TQueryProducts);
    // TODO: SortList
    // function SortList(AList: TList<TProductRecord>; ASortMode: Integer)
    // : TList<TProductRecord>;
    procedure UpdateProductCount;
    procedure UpdateSelectedCount;
    { Private declarations }
  protected
    procedure OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn); override;
  public
    function LoadExcelFileHeader(const AFileName: String; AFieldsInfo:
        TList<TFieldInfo>): Boolean;
    procedure LoadFromExcelDocument(const AFileName: String);
    procedure UpdateView; override;
    property QueryProducts: TQueryProducts read GetQueryProducts
      write SetQueryProducts;
    { Public declarations }
  end;

  TProductsErrorTable = class(TCustomErrorTable)
  private
    function GetDescription: TField;
    function GetError: TField;
    function GetColumnName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddErrorMessage(const AColumnName: string; AMessage: string);
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property ColumnName: TField read GetColumnName;
  end;

implementation

{$R *.dfm}

uses NotifyEvents, System.Generics.Defaults, RepositoryDataModule,
  System.IOUtils, Winapi.ShellAPI, ClipboardUnit, System.Math, ProjectConst,
  DialogUnit, Vcl.Clipbrd, SettingsController, ExcelDataModule,
  ProductsExcelDataModule, ProgressBarForm, ErrorForm, CustomExcelTable,
  GridViewForm;

procedure TViewProducts.actAddExecute(Sender: TObject);
var
  AColumn: TcxGridDBBandedColumn;
  AView: TcxGridDBBandedTableView;
begin
  AView := GetDBBandedTableView(0);
  AView.Focused := True;

  AView.DataController.Append;

  AColumn := AView.GetColumnByFieldName(QueryProducts.Value.FieldName);
  // Site ������������ ������ � ��������� ����������� �� cxGrid
  AView.Site.SetFocus;
  // ���������� �������� ��� �������
  AView.Controller.EditingController.ShowEdit(AColumn);

  UpdateView;
end;

procedure TViewProducts.actCommitExecute(Sender: TObject);
begin
  inherited;;
end;

procedure TViewProducts.actDeleteExecute(Sender: TObject);
var
  AFocusedView: TcxGridDBBandedTableView;
begin

  if TDialog.Create.DeleteRecordsDialog(sDoYouWantToDeleteProducts) then
  begin
    AFocusedView := FocusedTableView;
    if AFocusedView <> nil then
    begin

      BeginUpdate;
      try
        AFocusedView.Controller.DeleteSelection;
      finally
        EndUpdate
      end;

      UpdateView;
    end;
  end;
end;

procedure TViewProducts.actPasteComponentsExecute(Sender: TObject);
var
  m: TArray<String>;
begin
  m := TClb.Create.GetRowsAsArray;
  if Length(m) = 0 then
    Exit;

  // ������ �������� ���������� �� �����
  QueryProducts.AppendRows(QueryProducts.Value.FieldName, m);

  PutInTheCenterFocusedRecord(MainView);

  UpdateView;
end;

procedure TViewProducts.actRefreshExecute(Sender: TObject);
begin
  CheckAndSaveChanges;
end;

procedure TViewProducts.actRollbackExecute(Sender: TObject);
begin
  inherited;;
end;

procedure TViewProducts.AfterDelete(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts.AfterLoad(Sender: TObject);
begin
  ApplyBestFitEx;
end;

procedure TViewProducts.AfterOpen(Sender: TObject);
begin
  UpdateProductCount;
  UpdateView;
end;

procedure TViewProducts.AfterPost(Sender: TObject);
begin
  UpdateProductCount;
end;

procedure TViewProducts.BeforeLoad(Sender: TObject);
begin
  UpdateView;
  { ��� ������ ������� ������ ��������� ������� ��������� � ������ ������ }
  if CheckAndSaveChanges = IDCANCEL then
    raise EAbort.Create('Cancel scroll');
end;

procedure TViewProducts.cxGridDBBandedTableViewDataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  AVar1, AVar2: Integer;
begin
  if AItemIndex = 1 then
  begin
    if VarIsNull(V1) and not(VarIsNull(V2)) then
      Compare := -1;
    if VarIsNull(V2) and not(VarIsNull(V1)) then
      Compare := 1;
    if VarIsNull(V1) and VarIsNull(V2) then
      Compare := 0;
    if not(VarIsNull(V1) or VarIsNull(V2)) then
    begin
      if Pos('-', V1) > 0 then
        AVar1 := StrToInt(Copy(V1, 0, Pos('-', V1) - 1))
      else
        AVar1 := StrToInt(V1);

      if Pos('-', V2) > 0 then
        AVar2 := StrToInt(Copy(V2, 0, Pos('-', V2) - 1))
      else
        AVar2 := StrToInt(V2);

      if AVar1 > AVar2 then
        Compare := -1;
      if AVar1 < AVar2 then
        Compare := 1;
      if AVar1 = AVar2 then
        Compare := 0;

      { if V1 > V2 then
        Compare := -1;
        if V1 < V2 then
        Compare := 1;
        if V1 = V2 then
        Compare := 0; }
    end;
    // if btStorehouseProducts.Columns[AItemIndex].SortOrder = soAscending then
    Compare := Compare * (-1); // ������������� ������� ��� �������������

  end
  else
  begin
    case VarCompareValue(V1, V2) of
      vrEqual:
        Compare := 0;
      vrLessThan:
        Compare := -1;
      vrGreaterThan:
        Compare := 1;
    else
      Compare := 0;
    end;
  end;
end;

procedure TViewProducts.cxGridDBBandedTableViewSelectionChanged
  (Sender: TcxCustomGridTableView);
begin
  UpdateSelectedCount;
end;

function TViewProducts.GetQueryProducts: TQueryProducts;
begin
  Result := QueryProductsBase as TQueryProducts;
end;

function TViewProducts.LoadExcelFileHeader(const AFileName: String;
    AFieldsInfo: TList<TFieldInfo>): Boolean;
var
  ADefaultFields: TDictionary<String, TFieldInfo>;
  AExcelDM: TExcelDM;
  AFieldInfo: TFieldInfo;
  AfrmGridView: TfrmGridView;
  AProductsErrorTable: TProductsErrorTable;
  ARootTreeNode: TStringTreeNode;
  AStringTreeNode: TStringTreeNode;
  i: Integer;
  OK: Boolean;
  UnknownFieldCount: cardinal;
begin
  Result := False;
  Assert(not AFileName.IsEmpty);
  Assert(AFieldsInfo <> nil);

  ADefaultFields := TDictionary<String, TFieldInfo>.Create;
  try
    // ��������� ���� "�� ���������"
    ADefaultFields.Add(clValue.Caption.ToUpper,
      TFieldInfo.Create(QueryProducts.Value.FieldName, True,
      '�� ������ �������� ����������'));

    ADefaultFields.Add(clProducer.Caption.ToUpper, TFieldInfo.Create('Producer',
      True, '�� ����� �������������'));

    AExcelDM := TExcelDM.Create(Self);
    try
      // ��������� �������� ����� Excel �����
      ARootTreeNode := AExcelDM.LoadExcelFileHeader(AFileName);

      UnknownFieldCount := 0; // ���-�� �������������� �����

      // ������ ������� � ��������
      AProductsErrorTable := TProductsErrorTable.Create(Self);
      try
        // ���� �� ���� ���������� �������
        for AStringTreeNode in ARootTreeNode.Childs do
        begin
          AFieldInfo := nil;
          // ������� ���� ����� ������� � ������� ����� "�� ���������"
          if ADefaultFields.ContainsKey(AStringTreeNode.Value.ToUpper) then
          begin
            AFieldInfo := ADefaultFields[AStringTreeNode.Value.ToUpper];
          end
          else
          begin
            // ���� �� ���� �������� �������������
            for i := 0 to MainView.ColumnCount - 1 do
            begin
              if SameText(MainView.Columns[i].Caption, AStringTreeNode.Value)
              then
              begin
                AFieldInfo := TFieldInfo.Create
                  (MainView.Columns[i].DataBinding.FieldName);
                break;
              end;
            end;
          end;
          if AFieldInfo = nil then
          begin
            Inc(UnknownFieldCount);

            // ������ �������� �������������� �������
            AFieldInfo := TFieldInfo.Create(Format('UnknownField_%d',
              [UnknownFieldCount]));
          end;
          AProductsErrorTable.AddErrorMessage(AStringTreeNode.Value,
            '�������������� �������');
          // ������ �������� ���� ��� Excel �������
          AFieldsInfo.Add(AFieldInfo);
        end;

        // ���� ����� ������� excel ����� ���� ��������������
        OK := AProductsErrorTable.RecordCount = 0;
        if not OK then
        begin
          AfrmGridView := TfrmGridView.Create(Self);
          try
            AfrmGridView.Caption := '�������������� �������';
            AfrmGridView.DataSet := AProductsErrorTable;
            // ���������� ��� �� ���������� �����������
            OK := AfrmGridView.ShowModal = mrOk;
          finally
            FreeAndNil(AfrmGridView);
          end;

        end;

      finally
        FreeAndNil(AProductsErrorTable);
      end;
    finally
      FreeAndNil(AExcelDM);
    end;
  finally
    FreeAndNil(ADefaultFields);
  end;

  OK := OK and (AFieldsInfo.Count > 0);
  Result := OK;
end;

procedure TViewProducts.LoadFromExcelDocument(const AFileName: String);
var
  AFieldsInfo: TList<TFieldInfo>;
  AfrmError: TfrmError;
  AProductsExcelDM: TProductsExcelDM;
  OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  AFieldsInfo := TList<TFieldInfo>.Create();
  try
    // ��������� ������ ����� �� �����
    if not LoadExcelFileHeader(AFileName, AFieldsInfo) then Exit;

    AProductsExcelDM := TProductsExcelDM.Create(Self, AFieldsInfo);
    try
      // ��������� ������ �� Excel �����
      TfrmProgressBar.Process(AProductsExcelDM,
        procedure
        begin
          AProductsExcelDM.LoadExcelFile(AFileName);
        end, '�������� ��������� ������', sRows);

      OK := AProductsExcelDM.ExcelTable.Errors.RecordCount = 0;
      // ���� � ���� �������� ������ ��������� ������ (������������� �� ������)
      if not OK then
      begin
        AfrmError := TfrmError.Create(Self);
        try
          AfrmError.ErrorTable := AProductsExcelDM.ExcelTable.Errors;
          // ���������� ������
          OK := AfrmError.ShowModal = mrOk;
          AProductsExcelDM.ExcelTable.ExcludeErrors(etError);
        finally
          FreeAndNil(AfrmError);
        end;
      end;
      if OK then
      begin
        // ��������� ������ � ��
        TfrmProgressBar.Process(AProductsExcelDM.ExcelTable,
          procedure
          begin
            QueryProducts.AppendList(AProductsExcelDM.ExcelTable);
          end, '���������� ��������� ������ � ��', sRecords);
      end;

    finally
      FreeAndNil(AProductsExcelDM);
    end;
  finally
    FreeAndNil(AFieldsInfo);
  end;

end;

procedure TViewProducts.OnGridPopupMenuPopup(AColumn: TcxGridDBBandedColumn);
Var
  OK: Boolean;
begin
  OK := Clipboard.HasFormat(CF_TEXT) and (AColumn <> nil);

  actPasteComponents.Enabled := OK and (AColumn.GridView.Level = cxGridLevel)
    and (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);

  OK := (AColumn <> nil);

  actPasteComponents.Visible := OK and (AColumn.GridView.Level = cxGridLevel)
    and (AColumn.DataBinding.FieldName = clValue.DataBinding.FieldName);
end;

procedure TViewProducts.SetQueryProducts(const Value: TQueryProducts);
begin
  if QueryProductsBase <> Value then
  begin
    QueryProductsBase := Value;

    FEventList.Clear;

    if QueryProducts <> nil then
    begin
      // ������������� �� �������
      TNotifyEventWrap.Create(QueryProducts.Master.BeforeScrollI, BeforeLoad,
        FEventList);

      // ������������� �� �������
      TNotifyEventWrap.Create(QueryProducts.AfterLoad, AfterLoad, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterOpen, AfterOpen, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterPost, AfterPost, FEventList);

      TNotifyEventWrap.Create(QueryProducts.AfterDelete, AfterDelete,
        FEventList);

      Assert(clProducer.DataBinding.FieldName <> '');
      Assert(MainView.GetColumnByFieldName(clProducer.DataBinding.FieldName)
        .DataBinding.FieldName <> '');
    end;

    UpdateView;
  end;
end;

procedure TViewProducts.StatusBarResize(Sender: TObject);
const
  EmptyPanelIndex = 2;
var
  i: Integer;
  x: Integer;
begin
  x := StatusBar.ClientWidth;
  for i := 0 to StatusBar.Panels.Count - 1 do
  begin
    if i <> EmptyPanelIndex then
    begin
      Dec(x, StatusBar.Panels[i].Width);
    end;
  end;
  x := IfThen(x >= 0, x, 0);
  StatusBar.Panels[EmptyPanelIndex].Width := x;
end;

procedure TViewProducts.UpdateProductCount;
begin
  // �� ��������� ������
  StatusBar.Panels[0].Text := Format('%d', [QueryProducts.FDQuery.RecordCount]);

  // �� ���� �������
  StatusBar.Panels[3].Text := Format('�����: %d', [QueryProducts.TotalCount]);

end;

procedure TViewProducts.UpdateSelectedCount;
begin
  StatusBar.Panels[1].Text :=
    Format('%d', [cxGridDBBandedTableView.DataController.GetSelectedCount]);
end;

procedure TViewProducts.UpdateView;
var
  AFocusedView: TcxGridDBBandedTableView;
  OK: Boolean;
begin
  inherited;
  OK := (QueryProductsBase <> nil) and (QueryProductsBase.FDQuery.Active);
  AFocusedView := FocusedTableView;

  actAdd.Enabled := OK;
  {
    and ((QueryProductsBase.FDQuery.State = dsBrowse) or
    ((QueryProductsBase.FDQuery.State in [dsEdit, dsInsert]) and
    (not QueryProductsBase.Value.AsString.IsEmpty)));
  }
  actDelete.Enabled := OK and (AFocusedView <> nil) and
    (AFocusedView.DataController.RowCount > 0);
end;

constructor TProductsErrorTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ColumnName', ftString, 100);
  FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  ColumnName.DisplayLabel := '�������';
  Description.DisplayLabel := '��������';
  Error.DisplayLabel := '��� ������';
end;

procedure TProductsErrorTable.AddErrorMessage(const AColumnName: string;
AMessage: string);
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Append;

  ColumnName.AsString := AColumnName;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  Post;
end;

function TProductsErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TProductsErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TProductsErrorTable.GetColumnName: TField;
begin
  Result := FieldByName('ColumnName');
end;

end.
