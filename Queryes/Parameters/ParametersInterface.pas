unit ParametersInterface;

interface

uses
  ErrorType;

type
  TRecordCheck = record
    ErrorMessage: String;
    ErrorType: TErrorType;
  end;

  IParameters = interface(IInterface)
    function Check(const AParameterName: string): TRecordCheck; stdcall;
  end;

implementation

end.
