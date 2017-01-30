unit DragHelper;

interface

type
  TRecOrder = class
    Key: Integer;
    Order: Integer;
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

end.
