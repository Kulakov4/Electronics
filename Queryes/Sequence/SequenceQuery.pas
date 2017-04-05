unit SequenceQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySequence = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetName: TField;
    function GetSeq: TField;
    { Private declarations }
  public
    function GetNextValue(const AName: string): Integer;
    class function NextValue(AName: string): Integer; static;
    property Name: TField read GetName;
    property Seq: TField read GetSeq;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TQuerySequence.GetName: TField;
begin
  Result := Field('Name');
end;

function TQuerySequence.GetNextValue(const AName: string): Integer;
begin
  Assert(not AName.IsEmpty);

  // Выбираем последнее значение нашей последовательности
  Load(['name'], [AName]);

  case FDQuery.RecordCount of
    0: // Если такой последовательности не существует
      begin
        TryAppend;
        Name.AsString := AName;
        Seq.AsInteger := 1;
        TryPost;
      end;
    1: // Если такая последовательность существует
      begin
        // Сохраняем в БД новое значение последовательности
        TryEdit;
        Seq.AsInteger := Seq.AsInteger + 1;
        TryPost;
      end
  else
    raise Exception.CreateFmt
      ('Найдено более одной последовательности с именем %s', [AName]);
  end;
  Result := Seq.AsInteger;
end;

function TQuerySequence.GetSeq: TField;
begin
  Result := Field('seq');
end;

class function TQuerySequence.NextValue(AName: string): Integer;
var
  Q: TQuerySequence;
begin
  Q := TQuerySequence.Create(nil);
  try
    Result := Q.GetNextValue(AName);
  finally
    FreeAndNil(Q);
  end;
end;

end.
