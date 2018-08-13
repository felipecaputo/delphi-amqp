unit DelphiAMQP.Fames.ConnectionStart;

interface

uses
  DelphiAMQP.Frames.Header, System.Generics.Collections, System.Classes,
  DelphiAMQP.AMQPValue, DelphiAMQP.Frames.BasicFrame;

type
  TAMQPConnectionStartFrame = class(TAMQPBasicFrame)
  private
    FVersionMajor: TAMQPValueType;
    FVersionMinor: TAMQPValueType;
    FServerProperties: TAMQPValueType;
    FMecanisms: TAMQPValueType;
    FLocales: TAMQPValueType;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Parse(const AStream: TBytesStream);

    function Parameters(): TArray<string>; override;

  published
    property VersionMajor: TAMQPValueType read FVersionMajor write FVersionMajor;
    property VersionMinor: TAMQPValueType read FVersionMinor write FVersionMinor;
    property ServerProperties: TAMQPValueType read FServerProperties write FServerProperties;
    property Mecanisms: TAMQPValueType read FMecanisms write FMecanisms;
    property Locales: TAMQPValueType read FLocales write FLocales;

  end;

implementation

uses
  DelphiAMQP.Util.Helpers, DelphiAMQP.Constants;

{ TAMQPConnectionStartHeader }

constructor TAMQPConnectionStartFrame.Create(AOwner: TComponent);
begin
  inherited;
  FClassId := Ord(TAMQPClasses.Connection);
  FMethodId := Ord(TAMQPConnectionMethods.Start);
  FVersionMajor := TAMQPValueType.Create(TAMQPValueType.ShortShortUInt);
  FVersionMinor := TAMQPValueType.Create(TAMQPValueType.ShortShortUInt);
  FServerProperties := TAMQPValueType.Create(TAMQPValueType.FieldTable);
  FMecanisms := TAMQPValueType.Create(TAMQPValueType.LongString);
  FLocales := TAMQPValueType.Create(TAMQPValueType.LongString);
end;

function TAMQPConnectionStartFrame.Parameters: TArray<string>;
begin
  SetLength(Result, 5);
  Result[0] := 'VersionMajor';
  Result[1] := 'VersionMinor';
  Result[2] := 'ServerProperties';
  Result[3] := 'Mecanisms';
  Result[4] := 'Locales';
end;

procedure TAMQPConnectionStartFrame.Parse(const AStream: TBytesStream);
begin
  FVersionMajor.Parse(AStream);
  FVersionMinor.Parse(AStream);
  ServerProperties.Parse(AStream);
  Mecanisms.Parse(AStream);
  Locales.Parse(AStream);
end;

end.
