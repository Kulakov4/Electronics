unit DragHelper;

interface

type
  TRecOrder = class
    Key: Integer;
    Order: Integer;
  public
    constructor Create(AKey, AOrder: Integer);
  end;

  TStartDrag = class
  public
    Keys: array of Integer;
    MinOrderValue: Integer;
    MaxOrderValue: Integer;
  end;

  TDropDrag = class
  public
    Key: Integer;
    OrderValue: Integer;
  end;

implementation

constructor TRecOrder.Create(AKey, AOrder: Integer);
begin
  inherited Create;
  Assert(AKey > 0);
  Key := AKey;
  Order := AOrder;
end;

end.
