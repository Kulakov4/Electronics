unit ColInfo;

interface

uses
  DSWrap;

type
  TColInfo = class(TObject)
  private
    FBandCaption: String;
    FBandIndex: Integer;
    FFieldWrap: TFieldWrap;
  public
    constructor Create(AFieldWrap: TFieldWrap; ABandIndex: Integer;
      ABandCaption: String = '');
    property BandCaption: String read FBandCaption;
    property BandIndex: Integer read FBandIndex;
    property FieldWrap: TFieldWrap read FFieldWrap;
  end;

implementation

constructor TColInfo.Create(AFieldWrap: TFieldWrap; ABandIndex: Integer;
  ABandCaption: String = '');
begin
  FFieldWrap := AFieldWrap;
  FBandIndex := ABandIndex;
  FBandCaption := ABandCaption;
end;

end.
