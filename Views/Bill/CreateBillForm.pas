unit CreateBillForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  dxSkinXmas2008Blue, cxTextEdit, Vcl.StdCtrls, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.Menus, cxButtons,
  BillQuery, BillInterface;

type
  TFrmCreateBill = class(TForm, IBill)
    Label1: TLabel;
    cxteBillNumber: TcxTextEdit;
    cxdteBillDate: TcxDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnOK: TcxButton;
    cxteDollarCource: TcxTextEdit;
    cxteEuroCource: TcxTextEdit;
    cxdteShipmentDate: TcxDateEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cxdteBillDatePropertiesChange(Sender: TObject);
  strict private
    function GetBillNumberStr: String;
  private
    FQryBill: TQryBill;
    procedure Check;
    function GetBillDate: TDate;
    function GetShipmentDate: TDate;
    function GetBillNumber: Integer;
    function GetBillWidth: Integer;
    function GetDollarCource: Double;
    function GetEuroCource: Double;
    procedure SetBillDate(const Value: TDate);
    procedure SetShipmentDate(const Value: TDate);
    procedure SetBillNumberEx(AWidth, ANumber: Integer);
    procedure SetDollarCource(const Value: Double);
    procedure SetEuroCource(const Value: Double);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property BillDate: TDate read GetBillDate write SetBillDate;
    property ShipmentDate: TDate read GetShipmentDate write SetShipmentDate;
    property BillNumber: Integer read GetBillNumber;
    property BillWidth: Integer read GetBillWidth;
    property DollarCource: Double read GetDollarCource write SetDollarCource;
    property EuroCource: Double read GetEuroCource write SetEuroCource;
    { Public declarations }
  end;

implementation

uses
  MaxBillNumberQuery, CurrencyUnit;

{$R *.dfm}

constructor TFrmCreateBill.Create(AOwner: TComponent);
var
  mn: TMaxNumber;
begin
  inherited;
  FQryBill := nil;

  if AOwner is TQryBill then
  begin
    // Редактирование счёта
    Caption := 'Изменение счёта';
    FQryBill := AOwner as TQryBill;
    Assert(FQryBill.FDQuery.RecordCount > 0);
    SetBillNumberEx(FQryBill.W.Width.F.AsInteger,
      FQryBill.W.Number.F.AsInteger);
    BillDate := FQryBill.W.BillDate.F.AsDateTime;
    EuroCource := FQryBill.W.Euro.F.AsFloat;
    DollarCource := FQryBill.W.Dollar.F.AsFloat;

    if not FQryBill.W.ShipmentDate.F.IsNull then
      ShipmentDate := FQryBill.W.ShipmentDate.F.AsDateTime;
  end
  else
  begin
    // Добавление нового счёта
    mn := TQryMaxBillNumber.Get_Max_Number;
    SetBillNumberEx(mn.Width, mn.Number + 1);
    BillDate := Date;
  end;

end;

procedure TFrmCreateBill.cxdteBillDatePropertiesChange(Sender: TObject);
begin
  // Получаем курсы доллара и евро на эту дату
  DollarCource := TMyCurrency.Create.GetCourses(2, BillDate);
  EuroCource := TMyCurrency.Create.GetCourses(3, BillDate);
end;

procedure TFrmCreateBill.Check;
var
  ANeedChekBillNumber: Boolean;
begin
  if StrToIntDef(cxteBillNumber.Text, 0) = 0 then
  begin
    cxteBillNumber.SetFocus;
    raise Exception.Create('Введённый номер счёта не является целым числом');
  end;
  
  // Если изменили номер у существующего счёта или создали новый счёт
  ANeedChekBillNumber := (FQryBill = nil) or
    ((FQryBill <> nil) and (FQryBill.W.Number.F.AsInteger <> BillNumber));

  // Проверяем, чта такого номера счёта ещё нет
  if ANeedChekBillNumber and (TQryBill.SearchByNumberStatic(BillNumber) > 0) then
  begin
    cxteBillNumber.SetFocus;  
    raise Exception.CreateFmt('Счёт с номером %d уже существует', [BillNumber]);
  end;

  if BillDate = 0 then
    raise Exception.Create('Не задана дата оформления счёта');

  if cxteDollarCource.Text = '' then
  begin
    cxteDollarCource.SetFocus;  
    raise Exception.Create('Не задана курс Доллара');
  end;

  if cxteEuroCource.Text = '' then
  begin
    cxteEuroCource.SetFocus;  
    raise Exception.Create('Не задана курс Евро');
  end;
    
  if StrToFloatDef(cxteDollarCource.Text, 0) = 0 then
  begin
    cxteDollarCource.SetFocus;
    raise Exception.Create('Введённый курс Доллара не является числом');
  end;    

  if StrToFloatDef(cxteEuroCource.Text, 0) = 0 then
  begin
    cxteEuroCource.SetFocus;
    raise Exception.Create('Введённый курс Евро не является числом');
  end;      

  if (ShipmentDate > 0) and (ShipmentDate < BillDate) then
    raise Exception.Create
      ('Дата отгрузки не может быть меньше даты оформления счёта');
end;

procedure TFrmCreateBill.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOk then
    Exit;

  try
    // Чтобы потеряли фокус выпадающие списки и присвоили Dump новое выбранное значение
    btnOK.SetFocus;

    Check;

  except
    CanClose := false;
    raise;
  end;
end;

function TFrmCreateBill.GetBillDate: TDate;
begin
  Result := cxdteBillDate.Date;
end;

function TFrmCreateBill.GetShipmentDate: TDate;
begin
  if cxdteShipmentDate.Date < 0 then
    Result := 0
  else
    Result := cxdteShipmentDate.Date;
end;

function TFrmCreateBill.GetBillNumber: Integer;
begin
  Result := StrToInt(cxteBillNumber.Text);
end;

function TFrmCreateBill.GetBillNumberStr: String;
begin
  Result := cxteBillNumber.Text;
end;

function TFrmCreateBill.GetBillWidth: Integer;
var
  S: string;
begin
  S := cxteBillNumber.Text;
  Result := S.Length;
end;

function TFrmCreateBill.GetDollarCource: Double;
begin
  Result := StrToFloat(cxteDollarCource.Text);
end;

function TFrmCreateBill.GetEuroCource: Double;
begin
  Result := StrToFloat(cxteEuroCource.Text);
end;

procedure TFrmCreateBill.SetBillDate(const Value: TDate);
begin
  cxdteBillDate.Date := Value;
  // Получаем курсы доллара и евро на эту дату
  DollarCource := TMyCurrency.Create.GetCourses(2, Value);
  EuroCource := TMyCurrency.Create.GetCourses(3, Value);
end;

procedure TFrmCreateBill.SetShipmentDate(const Value: TDate);
begin
  cxdteShipmentDate.Date := Value;
end;

procedure TFrmCreateBill.SetBillNumberEx(AWidth, ANumber: Integer);
var
  S: string;
begin
  S := '%.' + AWidth.ToString + 'd';
  cxteBillNumber.Text := Format(S, [ANumber]);
end;

procedure TFrmCreateBill.SetDollarCource(const Value: Double);
begin
  cxteDollarCource.Text := Value.ToString;
end;

procedure TFrmCreateBill.SetEuroCource(const Value: Double);
begin
  cxteEuroCource.Text := Value.ToString;
end;

end.
