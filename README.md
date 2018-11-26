# Delphi-AMQP

An AMQP connector for ObjectPascal / Delphi, that targets to implement all AMQP (version 0.9.1) methods of the .

Currently tested on:

- RabbitMQ

This project supports Win32 / Win64 and Linux64 compilation.

This project uses Indy, using Delphi 10.2.X Tokyo, but the connection is just an implementation of a TCP send and receive data. You can
bring any TCP connection and implement the `IAMQPTCPConnection`.

## Contribuitors

Felipe Caputo (Maintainer)
