unit DelphiAMQP.BasicProperties;

interface

uses
  System.Classes, System.Generics.Collections, DelphiAMQP.AMQPValue;

type
  TAMQPDeliveryMode = (dmNonPersistent, dmPersistent);

  TAMQPBasicProperties = class(TPersistent)
  private
    FContentType: string;
    FContentEncoding: string;
    FHeaders: TObjectDictionary<string, TAMQPValueType>;
    FDeliveryMode: TAMQPDeliveryMode;
    FPriority: Byte;
    FCorrelationId: string;
    FReplyTo: string;
    FExpiration: string;
    FMessageId: string;
    FTimestamp: TDateTime;
    FMessageType: string;
    FUserId: string;
    FAppId: string;
  published
    property ContentType: string read FContentType write FContentType;
    property ContentEncoding: string read FContentEncoding write FContentEncoding;
    property Headers: TObjectDictionary<string, TAMQPValueType> read FHeaders write FHeaders;
    property DeliveryMode: TAMQPDeliveryMode read FDeliveryMode write FDeliveryMode;
    property Priority: Byte read FPriority write FPriority;
    property CorrelationId: string read FCorrelationId write FCorrelationId;
    property ReplyTo: string read FReplyTo write FReplyTo;
    property Expiration: string read FExpiration write FExpiration;
    property MessageId: string read FMessageId write FMessageId;
    property Timestamp: TDateTime read FTimestamp write FTimestamp;
    property MessageType: string read FMessageType write FMessageType;
    property UserId: string read FUserId write FUserId;
    property AppId: string read FAppId write FAppId;
  end;

implementation

end.
