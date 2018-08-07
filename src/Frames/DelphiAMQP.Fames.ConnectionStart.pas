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

    property VersionMajor: TAMQPValueType read FVersionMajor write FVersionMajor;
    property VersionMinor: TAMQPValueType read FVersionMinor write FVersionMinor;
    property ServerProperties: TAMQPValueType read FServerProperties write FServerProperties;
    property Mecanisms: TAMQPValueType read FMecanisms write FMecanisms;
    property Locales: TAMQPValueType read FLocales write FLocales;

  end;

implementation

uses
  DelphiAMQP.Util.Helpers;

{ TAMQPConnectionStartHeader }

constructor TAMQPConnectionStartFrame.Create(AOwner: TComponent);
begin
  inherited;
  FVersionMajor := TAMQPValueType.Create;
  FVersionMinor := TAMQPValueType.Create;
  FServerProperties := TAMQPValueType.Create;
  FMecanisms := TAMQPValueType.Create;
  FLocales := TAMQPValueType.Create;
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
  AStream.Read(FVersionMajor, 1);
  AStream.Read(FVersionMinor, 1);
  ServerProperties := TAMQPValueType.Create;
  ServerProperties.Parse(TAMQPValueType.FieldTable, AStream);

  Mecanisms := TAMQPValueType.Create;
  Mecanisms.Parse(TAMQPValueType.LongString, AStream);

  Locales := TAMQPValueType.Create;
  Locales.Parse(TAMQPValueType.LongString, AStream);
end;

end.
