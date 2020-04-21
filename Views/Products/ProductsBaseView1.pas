unit ProductsBaseView1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ProductsBaseView0, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxDBLookupComboBox, cxDropDownEdit, cxButtonEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, cxCalendar,
  cxCurrencyEdit, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar,
  cxBarEditItem, cxClasses, Vcl.ComCtrls, cxInplaceContainer, cxDBTL, cxTLData,
  BaseProductsViewModel1, ExtraChargeSimpleView, ProductsBaseQuery, Data.DB,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TViewProductsBase1 = class(TViewProductsBase0)
    dxBarManagerBar2: TdxBar;
    cxbeiExtraChargeType: TcxBarEditItem;
    cxbeiExtraCharge: TcxBarEditItem;
    dxbcWholeSale: TdxBarCombo;
    actRubToDollar: TAction;
    dxbcMinWholeSale: TdxBarCombo;
    dxbbRubToDollar: TdxBarButton;
    dxbcRetail: TdxBarCombo;
    actCommit: TAction;
    actRollback: TAction;
    actDelete: TAction;
    actCreateBill: TAction;
    actOpenInParametricTable: TAction;
    actClearPrice: TAction;
    procedure actClearPriceExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actCreateBillExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actOpenInParametricTableExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actRubToDollarExecute(Sender: TObject);
    procedure cxbeiExtraChargeTypePropertiesChange(Sender: TObject);
    procedure dxbcMinWholeSaleChange(Sender: TObject);
    procedure dxbcRetailChange(Sender: TObject);
    procedure dxbcWholeSaleChange(Sender: TObject);
    procedure dxbcWholeSaleDrawItem(Sender: TdxBarCustomCombo; AIndex: Integer;
      ARect: TRect; AState: TOwnerDrawState);
  private
    FViewExtraChargeSimple: TViewExtraChargeSimple;
    procedure DoAfterCancelUpdates(Sender: TObject);
    procedure DoOnCloseExtraChargesPopup(Sender: TObject);
    procedure DoOnRubToDollarChange(Sender: TObject);
    function GetIDExtraChargeType: Integer;
    function GetModel: TBaseProductsViewModel1;
    function GetProductW: TProductW;
    function GetViewExtraChargeSimple: TViewExtraChargeSimple;
    function SaveBarComboValue(AdxBarCombo: TdxBarCombo): Double;
    procedure SetIDExtraChargeType(const Value: Integer);
    procedure SetModel(const Value: TBaseProductsViewModel1);
    procedure UpdateAllBarComboText;
    { Private declarations }
  protected
    procedure DoOnSelectionChange; override;
    procedure LoadWholeSale;
    procedure UpdateFieldValue(AFields: TArray<TField>;
      AValues: TArray<Variant>);
    property IDExtraChargeType: Integer read GetIDExtraChargeType
      write SetIDExtraChargeType;
    property ViewExtraChargeSimple: TViewExtraChargeSimple
      read GetViewExtraChargeSimple;
  public
    function CheckAndSaveChanges: Integer;
    procedure UpdateView; override;
    property Model: TBaseProductsViewModel1 read GetModel write SetModel;
    property ProductW: TProductW read GetProductW;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, DBLookupComboBoxHelper, System.Generics.Collections,
  SettingsController, MinWholeSaleForm, DialogUnit, CreateBillForm, DataModule,
  System.StrUtils;

const
  clClickedColor = clRed;

{$R *.dfm}

procedure TViewProductsBase1.actClearPriceExecute(Sender: TObject);
begin
  inherited;

  BeginUpdate;
  try
    Model.qProductsBase.ClearInternalCalcFields;
    FocusFirstNode;
  finally
    EndUpdate;
  end;
  UpdateView;

end;

procedure TViewProductsBase1.actCommitExecute(Sender: TObject);
var
  AMinWholeSale: Double;
  ASave: Boolean;
begin
  inherited;
  Model.qProductsBase.W.TryPost;

  // если есть записи, которые были добавлены
  if Model.qProductsBase.HaveInsertedProducts then
  begin
    AMinWholeSale := TSettings.Create.MinWholeSale;
    if TfrmMinWholeSale.DoShowModal(AMinWholeSale, ASave) then
    begin
      if ASave then
        // Сохраняем минимальную оптовую наценку по умолчанию в настройках
        TSettings.Create.MinWholeSale := AMinWholeSale;
      // Применяем минимальную оптовую наценку
      Model.qProductsBase.ApplyMinWholeSale(AMinWholeSale);
    end;
  end;

  // Мы просто завершаем транзакцию
  Model.qProductsBase.ApplyUpdates;
  UpdateView;
end;

procedure TViewProductsBase1.actCreateBillExecute(Sender: TObject);
var
  AfrmCreateBill: TFrmCreateBill;
begin
  inherited;

  AfrmCreateBill := TFrmCreateBill.Create(nil);
  try
    if AfrmCreateBill.ShowModal <> mrOK then
      Exit;

    // Создаём новый счёт
    TDM.Create.AddBill(Model.qProductsBase, AfrmCreateBill);
  finally
    FreeAndNil(AfrmCreateBill);
  end;

end;

procedure TViewProductsBase1.actDeleteExecute(Sender: TObject);
var
  AID: Integer;
  APKArray: TArray<Variant>;
  S: string;
begin
  inherited;
  if cxDBTreeList.SelectionCount = 0 then
    Exit;

  if cxDBTreeList.Selections[0].IsGroupNode then
    S := 'Удалить группу компонентов с текущего склада?'
  else
    S := Format('Удалить %s?', [IfThen(cxDBTreeList.SelectionCount = 1,
      'компонент', 'компоненты')]);

  if not(TDialog.Create.DeleteRecordsDialog(S)) then
    Exit;

  // Заполняем список идентификаторов узлов, которые будем удалять
  APKArray := GetSelectedValues(W.PKFieldName);

  cxDBTreeList.BeginUpdate;
  try
    for AID in APKArray do
      Model.qProductsBase.DeleteNode(AID);
    // Это почему-то не работает
    // cxDBTreeList.DataController.DeleteFocused;
  finally
    cxDBTreeList.EndUpdate;
  end;
  UpdateView;
end;

procedure TViewProductsBase1.actOpenInParametricTableExecute(Sender: TObject);
begin
  inherited;
  Assert(Model.qProductsBase.FDQuery.RecordCount > 0);

  if ProductW.Value.F.AsString.Trim.IsEmpty then
  begin
    TDialog.Create.ErrorMessageDialog('Не задано наименование');
    Exit;
  end;

  if ProductW.IDProducer.F.AsInteger = 0 then
  begin
    TDialog.Create.ErrorMessageDialog('Не задан производитель');
    Exit;
  end;

  if not Model.qProductsBase.LocateInComponents then
  begin
    TDialog.Create.ErrorMessageDialog
      (Format('Компонент %s не найден в теоретической базе',
      [ProductW.Value.F.AsString]));
    Exit;
  end;
end;

procedure TViewProductsBase1.actRollbackExecute(Sender: TObject);
begin
  inherited;
  cxDBTreeList.BeginUpdate;
  try
    Model.qProductsBase.CancelUpdates;
    cxDBTreeList.FullCollapse;
  finally
    cxDBTreeList.EndUpdate;
  end;
  UpdateView;
end;

procedure TViewProductsBase1.actRubToDollarExecute(Sender: TObject);
begin
  inherited;
  Model.qProductsBase.RubToDollar := not Model.qProductsBase.RubToDollar;
  UpdateView;
end;

function TViewProductsBase1.CheckAndSaveChanges: Integer;
begin
  Result := 0;
  if Model.qProductsBase = nil then
    Exit;

  UpdateView;

  if Model.qProductsBase.HaveAnyChanges then
  begin
    Result := TDialog.Create.SaveDataDialog;
    case Result of
      IDYES:
        actCommit.Execute;
      IDNO:
        begin
          actRollback.Execute;
        end;
    end;
  end;
end;

procedure TViewProductsBase1.cxbeiExtraChargeTypePropertiesChange
  (Sender: TObject);
var
  A: TArray<String>;
  S: string;
begin
  inherited;

  if cxbeiExtraChargeType.Tag <> 0 then
    Exit;

  (Sender as TcxLookupComboBox).PostEditValue;

  // Фильтруем оптовые наценки по типу
  Model.ExtraChargeGroup.qExtraCharge2.W.FilterByType
    (cxbeiExtraChargeType.EditValue);
  ViewExtraChargeSimple.MainView.ApplyBestFit;

  // Помещаем пустое значение в качестве выбранного
  dxbcWholeSale.Tag := 1;
  try
    dxbcWholeSale.ItemIndex := -1;

    // Получаем список оптовых наценок
    A := Model.ExtraChargeGroup.qExtraCharge2.W.GetWholeSaleList;

    // Заполняем выпадающий список оптовых наценок
    dxbcWholeSale.Items.Clear;
    for S in A do
      dxbcWholeSale.Items.Add(S);
  finally
    dxbcWholeSale.Tag := 0;
  end;

end;

procedure TViewProductsBase1.DoAfterCancelUpdates(Sender: TObject);
begin
  UpdateAllBarComboText;
end;

procedure TViewProductsBase1.DoOnCloseExtraChargesPopup(Sender: TObject);
var
  AIDExtraCharge: Integer;
  AWholeSale: string;
begin
  AIDExtraCharge := Model.ExtraChargeGroup.qExtraCharge2.W.ID.F.AsInteger;

  cxbeiExtraCharge.EditValue := Model.ExtraChargeGroup.qExtraCharge2.W.Range.
    F.AsString;

  AWholeSale := Model.ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.AsString;

  dxbcWholeSale.Tag := 1;
  dxbcWholeSale.ItemIndex := dxbcWholeSale.Items.IndexOf(AWholeSale);
  dxbcWholeSale.Tag := 0;

  // Сохраняем выбранный диапазон и значение оптовой наценки
  UpdateFieldValue([ProductW.IDExtraChargeType.F, ProductW.IDExtraCharge.F,
    ProductW.WholeSale.F], [IDExtraChargeType, AIDExtraCharge,
    Model.ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.Value]);

  // Выбираем это значение в выпадающем списке
  UpdateBarComboText(dxbcWholeSale,
    Model.ExtraChargeGroup.qExtraCharge2.W.WholeSale.F.Value);
end;

procedure TViewProductsBase1.DoOnRubToDollarChange(Sender: TObject);
begin
  Assert(Model <> nil);
  actRubToDollar.Checked := Model.qProductsBase.RubToDollar;
  if not FResyncDataSetMessagePosted then
  begin
    FResyncDataSetMessagePosted := True;
    PostMessage(Handle, WM_RESYNC_DATASET, 0, 0);
  end;
end;

procedure TViewProductsBase1.DoOnSelectionChange;
begin
  inherited;
  UpdateAllBarComboText;
end;

procedure TViewProductsBase1.dxbcMinWholeSaleChange(Sender: TObject);
var
  AdxBarCombo: TdxBarCombo;
  AValue: Double;
begin
  inherited;
  AdxBarCombo := Sender as TdxBarCombo;
  if AdxBarCombo.Tag = 1 then
    Exit;

  // Сохраняем значение в выпадающем списке
  AValue := SaveBarComboValue(AdxBarCombo);

  // Сохраняем значение в БД
  UpdateFieldValue([ProductW.MinWholeSale.F], [AValue]);
end;

procedure TViewProductsBase1.dxbcRetailChange(Sender: TObject);
var
  AdxBarCombo: TdxBarCombo;
  AValue: Double;
begin
  inherited;
  AdxBarCombo := Sender as TdxBarCombo;
  if AdxBarCombo.Tag = 1 then
    Exit;

  // Сохраняем значение в выпадающем списке
  AValue := SaveBarComboValue(AdxBarCombo);

  // Сохраняем значение в БД
  UpdateFieldValue([ProductW.Retail.F], [AValue]);
end;

procedure TViewProductsBase1.dxbcWholeSaleChange(Sender: TObject);
var
  AdxBarCombo: TdxBarCombo;
  AValue: Double;
begin
  inherited;
  AdxBarCombo := Sender as TdxBarCombo;

  if AdxBarCombo.Tag <> 0 then
    Exit;

  AValue := SaveBarComboValue(AdxBarCombo);

  // Сохраняем выбранный диапазон и значение оптовой наценки
  UpdateFieldValue([ProductW.IDExtraChargeType.F, ProductW.IDExtraCharge.F,
    ProductW.WholeSale.F], [NULL, NULL, AValue]);

  cxbeiExtraChargeType.Tag := 1;
  cxbeiExtraChargeType.EditValue := NULL;
  cxbeiExtraChargeType.Tag := 0;

  // Фильтруем оптовые наценки по типу
  Model.ExtraChargeGroup.qExtraCharge2.W.FilterByType(0);
  cxbeiExtraCharge.EditValue := NULL;
end;

procedure TViewProductsBase1.dxbcWholeSaleDrawItem(Sender: TdxBarCustomCombo;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
var
  S: string;
begin
  inherited;

  if odSelected in AState then
  begin
    Brush.Color := clClickedColor;
    Font.Color := clHighlightText;
  end
  else
  begin
    Brush.Color := clWindow;
    Font.Color := clWindowText;
  end;

  Sender.Canvas.FillRect(ARect);
  if odFocused in AState then
    DrawFocusRect(Sender.Canvas.Handle, ARect);

  if AIndex >= 0 then
    S := Sender.Items[AIndex]
  else
    S := Sender.Text;
  if S <> '' then
    S := S + '%';

  Sender.Canvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
end;

function TViewProductsBase1.GetIDExtraChargeType: Integer;
begin
  if VarIsNull(cxbeiExtraChargeType.EditValue) then
    Result := 0
  else
    Result := cxbeiExtraChargeType.EditValue;
end;

function TViewProductsBase1.GetModel: TBaseProductsViewModel1;
begin
  Result := M as TBaseProductsViewModel1;
end;

function TViewProductsBase1.GetProductW: TProductW;
begin
  Result := Model.qProductsBase.W;
end;

function TViewProductsBase1.GetViewExtraChargeSimple: TViewExtraChargeSimple;
begin
  if FViewExtraChargeSimple = nil then
  begin
    FViewExtraChargeSimple := TViewExtraChargeSimple.Create(Self);
    TNotifyEventWrap.Create(FViewExtraChargeSimple.OnClosePopup,
      DoOnCloseExtraChargesPopup);
  end;

  Result := FViewExtraChargeSimple;
end;

procedure TViewProductsBase1.LoadWholeSale;
var
  AWholeSale: string;
  AWholeSaleList: TArray<String>;
begin
  AWholeSaleList := ['5', '10', '15', '20', '25', '30', '35', '40', '45', '50',
    '55', '60', '65', '70', '75', '80', '85', '90', '95', '100'];

  dxbcWholeSale.Items.BeginUpdate;
  try
    dxbcWholeSale.Items.Clear;

    for AWholeSale in AWholeSaleList do
      dxbcWholeSale.Items.Add(AWholeSale);

  finally
    dxbcWholeSale.Items.EndUpdate;
  end;
end;

function TViewProductsBase1.SaveBarComboValue(AdxBarCombo: TdxBarCombo): Double;
begin
  Assert(AdxBarCombo <> nil);
  Result := 0;

  if AdxBarCombo.Tag = 1 then
    Exit;

  Result := StrToFloatDef(AdxBarCombo.Text, 0);

  if Result < 0 then
    Result := 0;

  // если ввели какое-то недопустимое значение или 0
  if Result = 0 then
    UpdateBarComboText(AdxBarCombo, NULL);

  UpdateView;
end;

procedure TViewProductsBase1.SetIDExtraChargeType(const Value: Integer);
begin
  cxbeiExtraChargeType.EditValue := Value;
end;

procedure TViewProductsBase1.SetModel(const Value: TBaseProductsViewModel1);
begin
  if M = Value then
    Exit;

  M := Value;

  if M = nil then
    Exit;

  TNotifyEventWrap.Create(Model.qProductsBase.OnRubToDollarChange,
    DoOnRubToDollarChange, FEventList);
  // Обновляем состояние кнопки
  actRubToDollar.Checked := Model.qProductsBase.RubToDollar;
  dxbbRubToDollar.Down := actRubToDollar.Checked;

  // Фильтруем оптовые надбавки по типу
  Model.ExtraChargeGroup.qExtraChargeType.W.TryOpen;
  Model.ExtraChargeGroup.qExtraCharge2.W.TryOpen;
  Model.ExtraChargeGroup.qExtraCharge2.W.FilterByType(0);
  ViewExtraChargeSimple.MainView.ApplyBestFit;

  // Привязываем представление оптовых надбавок
  TDBLCB.InitProp(cxbeiExtraChargeType.Properties as
    TcxLookupComboBoxProperties,
    Model.ExtraChargeGroup.qExtraChargeType.W.DataSource,
    Model.ExtraChargeGroup.qExtraChargeType.W.PK.FieldName,
    Model.ExtraChargeGroup.qExtraChargeType.W.Name.FieldName, lsFixedList);

  ViewExtraChargeSimple.qExtraCharge := Model.ExtraChargeGroup.qExtraCharge2;
//  ViewExtraChargeSimple.Font.Size := 9;

  (cxbeiExtraCharge.Properties as TcxPopupEditproperties).PopupControl :=
    ViewExtraChargeSimple;

  LoadWholeSale;

  TNotifyEventWrap.Create(M.qProductsBase0.AfterCancelUpdates,
    DoAfterCancelUpdates, FEventList);
end;

procedure TViewProductsBase1.UpdateAllBarComboText;
var
  ARange: Variant;
begin
  if (W.DataSet.RecordCount > 0) and (cxDBTreeList.SelectionCount > 0) then
  begin
    // Отображаем розничную наценку у текущей записи
    UpdateBarComboText(dxbcRetail, ProductW.Retail.F.Value);
    // Отображаем оптовую наценку у текущей записи
    UpdateBarComboText(dxbcWholeSale, ProductW.WholeSale.F.Value);
    // Отображаем минимальную оптовую наценку у текущей записи
    UpdateBarComboText(dxbcMinWholeSale, ProductW.MinWholeSale.F.Value);

    if IDExtraChargeType <> ProductW.IDExtraChargeType.F.AsInteger then
    begin
      IDExtraChargeType := ProductW.IDExtraChargeType.F.AsInteger;
      // Фильтруем оптовые наценки по типу
      Model.ExtraChargeGroup.qExtraCharge2.W.FilterByType(IDExtraChargeType);
      ViewExtraChargeSimple.MainView.ApplyBestFit;
    end;

    ARange := NULL;
    if ProductW.IDExtraCharge.F.AsInteger > 0 then
    begin
      if Model.ExtraChargeGroup.qExtraCharge2.W.LocateByPK
        (ProductW.IDExtraCharge.F.AsInteger) then
        ARange := Model.ExtraChargeGroup.qExtraCharge2.W.Range.F.AsVariant;
    end;

    cxbeiExtraCharge.Tag := 1;
    cxbeiExtraCharge.EditValue := ARange;
    cxbeiExtraCharge.Tag := 0;
  end
  else
  begin
    // Выпадающий список "Стоимость"
    cxbeiExtraChargeType.EditValue := NULL;
    // Выпадающий список "Кол-во"
    cxbeiExtraCharge.EditValue := NULL;
    // Отображаем ПУСТУЮ оптовую наценку у текущей записи
    UpdateBarComboText(dxbcWholeSale, NULL);
    // Отображаем ПУСТУЮ минимальную оптовую наценку у текущей записи
    UpdateBarComboText(dxbcMinWholeSale, NULL);
    // Отображаем ПУСТУЮ розничную наценку
    UpdateBarComboText(dxbcRetail, NULL);
  end;
end;

procedure TViewProductsBase1.UpdateFieldValue(AFields: TArray<TField>;
  AValues: TArray<Variant>);
var
  ANode: TcxDBTreeListNode;
  AUpdatedIDList: TList<Integer>;
  i: Integer;
begin
  AUpdatedIDList := TList<Integer>.Create;
  Model.qProductsBase.FDQuery.DisableControls;
  try
    for i := 0 to cxDBTreeList.SelectionCount - 1 do
    begin
      ANode := cxDBTreeList.Selections[i] as TcxDBTreeListNode;

      Model.qProductsBase.UpdateFieldValue(ANode.Values[clID.ItemIndex],
        AFields, AValues, AUpdatedIDList);
    end;
  finally
    Model.qProductsBase.FDQuery.EnableControls;
    FreeAndNil(AUpdatedIDList);
    MyApplyBestFit;
  end;
end;

procedure TViewProductsBase1.UpdateView;
var
  OK: Boolean;
begin
  inherited;
  OK := (cxDBTreeList.DataController.DataSource <> nil) and (Model <> nil) and
    (Model.qProductsBase.FDQuery.Active) and IsViewOK and
    (cxDBTreeList.DataController.DataSet <> nil);

  actOpenInParametricTable.Enabled := OK and (cxDBTreeList.FocusedNode <> nil)
    and (cxDBTreeList.SelectionCount = 1) and (W.DataSet.State = dsBrowse) and
    (not W.IsGroup.F.IsNull) and (W.IsGroup.F.AsInteger = 0);

  actExportToExcelDocument.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actDelete.Enabled := OK and (cxDBTreeList.FocusedNode <> nil) and
    (cxDBTreeList.SelectionCount > 0) and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actCreateBill.Enabled := OK and (Model.qProductsBase.BasketW <> nil) and
    (Model.qProductsBase.BasketW.RecordCount > 0) and
    (W.DataSet.State = dsBrowse);
  { and (FqProductsBase.DollarCource > 0) and (FqProductsBase.EuroCource > 0) };

  actClearPrice.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0) and
    (W.DataSet.State = dsBrowse) and (not Model.qProductsBase.HaveAnyChanges);

  actRubToDollar.Enabled := OK and
    (cxDBTreeList.DataController.DataSet.RecordCount > 0);

  actCommit.Enabled := OK and Model.qProductsBase.HaveAnyChanges;

  actRollback.Enabled := actCommit.Enabled;
end;

end.
