unit DelphiAMQP.FrameIntf;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  IAMQPFrame = interface
    ['{0AF1C49A-9FF5-4926-8AEF-35B00D039112}']
    function GetAsBytes: TBytes;
    procedure SetAsBytes(const AValue: TBytes);

    function GetMethodFrame: IAMQPFrame;
    procedure SetMethodFrame(const Value: IAMQPFrame);

    property AsBytes: TBytes read GetAsBytes write SetAsBytes;

    property MethodFrame: IAMQPFrame read GetMethodFrame write SetMethodFrame;
  end;

implementation

end.
