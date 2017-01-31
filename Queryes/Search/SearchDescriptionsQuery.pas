unit SearchDescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, ProgressInfo, BaseQuery, SearchQuery;

type
  // Ссылка на метод обрабатывающий таблицу в памяти
  TProcRef = reference to procedure();


  TQuerySearchDescriptions = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FOnProgress: TNotifyEventsEx;
    FPI: TProgressInfo;
    function GetDescrID: TField;
    function GetDescriptionID: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallOnProcessEvent;
    procedure Process(AProcRef: TProcRef; const ACaption: string); overload;
    procedure Process(AProcRef: TProcRef; ANotifyEventRef: TNotifyEventRef);
        overload;
    procedure UpdateComponentDescriptions;
    property DescrID: TField read GetDescrID;
    property DescriptionID: TField read GetDescriptionID;
    property OnProgress: TNotifyEventsEx read FOnProgress;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProgressBarForm;

constructor TQuerySearchDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  FPI := TProgressInfo.Create;
  FOnProgress := TNotifyEventsEx.Create(Self);
end;

destructor TQuerySearchDescriptions.Destroy;
begin
  FreeAndNil(FPI);
  inherited;
end;

procedure TQuerySearchDescriptions.CallOnProcessEvent;
begin
  Assert(FDQuery.Active);
  Assert(FPI <> nil);
  FPI.TotalRecords := FDQuery.RecordCount;
  FPI.ProcessRecords := FDQuery.RecNo;
  OnProgress.CallEventHandlers(FPI)
end;

function TQuerySearchDescriptions.GetDescrID: TField;
begin
  Result := Field('DescrID');
end;

function TQuerySearchDescriptions.GetDescriptionID: TField;
begin
  Result := Field('DescriptionID');
end;

procedure TQuerySearchDescriptions.Process(AProcRef: TProcRef; const ACaption:
    string);
var
  AfrmProgressBar: TfrmProgressBar;
begin
  Assert(Assigned(AProcRef));

  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    if not ACaption.IsEmpty then
      AfrmProgressBar.Caption := ACaption;
    AfrmProgressBar.Show;

    // Вызываем метод-обработку табличных данных
    Process(AProcRef,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
  finally
    FreeAndNil(AfrmProgressBar);
  end;
end;

procedure TQuerySearchDescriptions.Process(AProcRef: TProcRef; ANotifyEventRef:
    TNotifyEventRef);
var
  ne: TNotifyEventR;
begin
  Assert(Assigned(AProcRef));

  // Подписываем кого-то на событие
  ne := TNotifyEventR.Create(OnProgress, ANotifyEventRef);
  try
    // Вызываем метод, обрабатывающий нашу таблицу
    AProcRef;
  finally
    // Отписываем кого-то от события
    FreeAndNil(ne);
  end;
end;

procedure TQuerySearchDescriptions.UpdateComponentDescriptions;
begin
  Assert(FDQuery.Active);
//  FDQuery.Close;
//  FDQuery.Open;

  CallOnProcessEvent;
  while not FDQuery.Eof do
  begin
    // Связываем компоненты со своими описаниями
    if DescriptionID.AsInteger  <>
      DescrID.AsInteger then
    begin
      FDQuery.Edit;
      DescriptionID.AsInteger := DescrID.AsInteger;
      FDQuery.Post;
      CallOnProcessEvent;
    end;
    FDQuery.Next;
  end;

end;

end.
