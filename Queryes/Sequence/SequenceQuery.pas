unit SequenceQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSequenceW = class(TDSWrap)
  private
    FName: TFieldWrap;
    FSeq: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    function GetNextValue(const AName: string): Integer;
    property Name: TFieldWrap read FName;
    property Seq: TFieldWrap read FSeq;
  end;

  TQuerySequence = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TSequenceW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    class function NextValue(AName: string): Integer; static;
    property W: TSequenceW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQuerySequence.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSequenceW.Create(FDQuery);
end;

class function TQuerySequence.NextValue(AName: string): Integer;
var
  Q: TQuerySequence;
begin
  Q := TQuerySequence.Create(nil);
  try
    Result := Q.W.GetNextValue(AName);
  finally
    FreeAndNil(Q);
  end;
end;

constructor TSequenceW.Create(AOwner: TComponent);
begin
  inherited;
  FName := TFieldWrap.Create(Self, 'Name');
  FSeq := TFieldWrap.Create(Self, 'Seq');
end;

function TSequenceW.GetNextValue(const AName: string): Integer;
begin
  Assert(not AName.IsEmpty);

  // Выбираем последнее значение нашей последовательности
  Load([Name.FieldName], [AName]);

  case DataSet.RecordCount of
    0: // Если такой последовательности не существует
      begin
        TryAppend;
        Name.F.AsString := AName;
        Seq.F.AsInteger := 1;
        TryPost;
      end;
    1: // Если такая последовательность существует
      begin
        // Сохраняем в БД новое значение последовательности
        TryEdit;
        Seq.F.AsInteger := Seq.F.AsInteger + 1;
        TryPost;
      end
  else
    raise Exception.CreateFmt
      ('Найдено более одной последовательности с именем %s', [AName]);
  end;
  Result := Seq.F.AsInteger;
end;

end.
