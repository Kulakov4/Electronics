unit cxTreeListHelper;

interface

uses
  cxTL, cxDBTL;

type
  TcxTreeListHelper = class(TObject)
  public
    class function CalcBandHeight(ABand: TcxTreeListBand): Integer; static;
    class procedure MyApplyBestFit(ABand: TcxTreeListBand); overload; static;
    class procedure MyApplyBestFit(cxDBTreeList: TcxDBTreeList); overload; static;
  end;

implementation

uses
  System.Types, Vcl.Graphics, System.SysUtils, TextRectHelper, System.Math,
  System.Classes;

class function TcxTreeListHelper.CalcBandHeight(ABand: TcxTreeListBand):
    Integer;
const
  MAGIC = 10;
var
  ABandHeight: Integer;
  ABandWidth: Integer;
  ACanvas: TCanvas;
  R: TRect;
begin
  Assert(ABand <> nil);

  ACanvas := ABand.TreeList.Canvas.Canvas;
  // Получаем текущую ширину бэнда
  ABandWidth := ABand.DisplayWidth;

  // Высота текста заголовка бэнда
  ABandHeight := ACanvas.TextHeight(ABand.Caption.Text);

  R := TTextRect.Calc(ACanvas, ABand.Caption.Text,
    Rect(0, 0, ABandWidth, ABandHeight));

  Result := MAGIC + R.Height;
end;

class procedure TcxTreeListHelper.MyApplyBestFit(ABand: TcxTreeListBand);
const
  MAGIC = 12;
var
  ABandRect: TRect;
  ABandWidth: Integer;
  ACanvas: TCanvas;
  ACaption: string;
  AColumn: TcxTreeListColumn;
  AColumnRect: TRect;
  AMinColWidth: Integer;
  j: Integer;
begin
  Assert(ABand <> nil);

  ACanvas := ABand.TreeList.Canvas.Canvas;

  // Предпологаем что дочерних бэндов нет!!!
  Assert(ABand.ChildBandCount = 0);

  for j := 0 to ABand.ColumnCount - 1 do
  begin
    AColumn := ABand.Columns[j] as TcxTreeListColumn;
    if not AColumn.Visible then
      Continue;

    // Пусть ширина бэнда подстраивается под ширину колонок
    ABand.Width := 0;

    // Определяемся с минимальной шириной колонки
    AMinColWidth := 0;
    ACaption := AColumn.Caption.Text;
    // Если заголовок колонки не пустой
    if not ACaption.Trim.IsEmpty then
    begin
      // Колонка вычисляет свою оптимальную ширину без учёта переноса на новую строку!!!
      // Вычисляем минимальную ширину колонки
      AColumnRect := TTextRect.Calc(ACanvas, ACaption);
      AMinColWidth := AColumnRect.Width + MAGIC;
    end;

    // Находим оптимальную ширину колонки без учёта её заголовка
    AColumn.Caption.Text := ' ';
    AColumn.ApplyBestFit;

    if AColumn.DisplayWidth < AMinColWidth then
      AColumn.DisplayWidth := AMinColWidth;

    if AColumn.Caption.Text <> ACaption then
      AColumn.Caption.Text := ACaption;
  end;

  // Вычисляем минимальную ширину бэнда
  ABandRect := TTextRect.Calc(ACanvas, ABand.Caption.Text);
  // Получаем реальную ширину бэнда
  ABandWidth := ABand.DisplayWidth;

  // Если сейчас ширины бэнда не достаточно, для размещения самого длинного слова его заголовка
  if ABandWidth < (ABandRect.Width + MAGIC) then
  begin
    ABand.Width := ABandRect.Width + MAGIC;
    ABandWidth := ABand.DisplayWidth;
    Assert(ABandWidth >= ABandRect.Width);
  end;
end;

class procedure TcxTreeListHelper.MyApplyBestFit(cxDBTreeList: TcxDBTreeList);
var
  ABand: TcxTreeListBand;
  ABandHeight: Integer;
  AMaxBandHeight: Integer;
  I: Integer;
begin
  Assert(cxDBTreeList <> nil);
  cxDBTreeList.BeginUpdate;
  try
    AMaxBandHeight := 0;
    for I := 0 to cxDBTreeList.Bands.Count - 1 do
    begin
      ABand := cxDBTreeList.Bands[I];
      if not ABand.Visible then
        Continue;

      MyApplyBestFit(ABand);

      // Вычисляем, какая должна быть высота бэнда, если оставить неизменной его ширину
      ABandHeight := CalcBandHeight(ABand);

      AMaxBandHeight := IfThen(ABandHeight > AMaxBandHeight, ABandHeight,
        AMaxBandHeight);
    end;

    if AMaxBandHeight > 0 then
      cxDBTreeList.OptionsView.BandLineHeight := AMaxBandHeight;
  finally
    cxDBTreeList.EndUpdate;
  end;
end;

end.
