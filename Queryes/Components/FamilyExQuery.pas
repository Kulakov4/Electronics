unit FamilyExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FamilyQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, NotifyEvents, System.Generics.Collections, DBRecordHolder,
  DSWrap;

type
  TFamilyExW = class(TFamilyW)
  private
    FAnalog: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshQuery; override;
    property Analog: TFieldWrap read FAnalog;
  end;

  TQueryFamilyEx = class(TQueryFamily)
  private
    FOn_ApplyUpdate: TNotifyEventsEx;
    function GetFamilyExW: TFamilyExW;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FamilyExW: TFamilyExW read GetFamilyExW;
    property On_ApplyUpdate: TNotifyEventsEx read FOn_ApplyUpdate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryFamilyEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);

  FRecordHolder := TRecordHolder.Create();
end;

destructor TQueryFamilyEx.Destroy;
begin
  FreeAndNil(FOn_ApplyUpdate);
  FreeAndNil(FRecordHolder);
  inherited;
end;

procedure TQueryFamilyEx.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // ничего не делаем при удаении
end;

procedure TQueryFamilyEx.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ничего не делаем при добавлении
end;

procedure TQueryFamilyEx.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Оповещаем что надо обработать обновление
  On_ApplyUpdate.CallEventHandlers(Self);
end;

function TQueryFamilyEx.CreateDSWrap: TDSWrap;
begin
  Result := TFamilyExW.Create(FDQuery);
end;

function TQueryFamilyEx.GetFamilyExW: TFamilyExW;
begin
  Result := W as TFamilyExW;
end;

constructor TFamilyExW.Create(AOwner: TComponent);
begin
  inherited;
  FAnalog := TFieldWrap.Create(Self, 'Analog');
end;

procedure TFamilyExW.RefreshQuery;
begin
  // При каждом обновлении в запрос добавляются разные дополнительные поля.
  // Поэтому обычный Refresh не подходит
  DataSet.DisableControls;
  try
    if DataSet.Active then
      DataSet.Close;
    DataSet.Open;

    NeedRefresh := False;
  finally
    DataSet.EnableControls;
  end;
end;

end.
