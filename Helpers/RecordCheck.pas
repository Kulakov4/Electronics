unit RecordCheck;

interface

uses
  ErrorType;

type
  TRecordCheck = record
    ErrorType: TErrorType;
    Row: Integer;
    Col: Integer;
    ErrorMessage: String;
    Description: String;
  end;


implementation

end.
