unit CurrencyInterface;

interface

type
  ICurrency = interface
    function GetCourses(CurrencyID: Integer; ADate: TDateTime): Double; stdcall;
  end;

implementation

end.
