unit ComponentsExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, NotifyEvents,
  ComponentsQuery, System.Generics.Collections, DSWrap;

type
  TQueryComponentsEx = class(TQueryComponents)
  private
    FOnLocate: TNotifyEventsEx;
    FOn_ApplyUpdate: TNotifyEventsEx;
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
    procedure LocateInStorehouse;
    property OnLocate: TNotifyEventsEx read FOnLocate;
    property On_ApplyUpdate: TNotifyEventsEx read FOn_ApplyUpdate;
    { Public declarations }
  end;

  TComponentsExW = class(TComponentsW)
  private
    FAnalog: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Analog: TFieldWrap read FAnalog;
  end;

implementation

{$R *.dfm}

uses DBRecordHolder;

constructor TQueryComponentsEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);
  FOnLocate := TNotifyEventsEx.Create(Self);
  FRecordHolder := TRecordHolder.Create();
end;

destructor TQueryComponentsEx.Destroy;
begin
  inherited;
  FreeAndNil(FOn_ApplyUpdate);
  FreeAndNil(FOnLocate);
  FreeAndNil(FRecordHolder);
end;

procedure TQueryComponentsEx.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  // ничего не делаем при удаении
end;

procedure TQueryComponentsEx.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ќичего не делаем при добавлении
end;

procedure TQueryComponentsEx.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // ќповещаем что надо обработать обновление
  On_ApplyUpdate.CallEventHandlers(Self);
end;

function TQueryComponentsEx.CreateDSWrap: TDSWrap;
begin
  Result := TComponentsExW.Create(FDQuery);
end;

procedure TQueryComponentsEx.LocateInStorehouse;
Var
  l: TList<String>;
begin
  Assert(FOnLocate <> nil);
  Assert(FDQuery.RecordCount > 0);

  l := TList<String>.Create();
  try
    l.Add(W.Value.F.AsString);
    // »звещаем всех что нужно осуществить поиск этого компонента на складах
    FOnLocate.CallEventHandlers(l);
  finally
    FreeAndNil(l);
  end;
end;

constructor TComponentsExW.Create(AOwner: TComponent);
begin
  inherited;
  FAnalog := TFieldWrap.Create(Self, 'Analog');
end;

end.
