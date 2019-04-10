unit DescriptionsQueryWrap;

interface

uses
  DSWrap, System.Classes;

type
  TDescriptionW = class(TDSWrap)
  private
    FDescription: TFieldWrap;
    FDescriptionComponentName: TFieldWrap;
    FDescriptionID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Description: TFieldWrap read FDescription;
    property DescriptionComponentName: TFieldWrap read FDescriptionComponentName;
    property DescriptionID: TFieldWrap read FDescriptionID;
  end;

implementation

constructor TDescriptionW.Create(AOwner: TComponent);
begin
  inherited;
  FDescription := TFieldWrap.Create(Self, 'Description');
  FDescriptionComponentName := TFieldWrap.Create(Self,
    'DescriptionComponentName', 'Краткое описание');
  FDescriptionID := TFieldWrap.Create(Self, 'DescriptionID');
end;

end.
