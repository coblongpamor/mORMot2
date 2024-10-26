/// simple Echo server using WebSockets
program restws_SimpleEchoServer;

uses
  SysUtils,
  mormot.net.server,
  mormot.net.ws.core,
  mormot.net.ws.server,
  mormot.core.os,
  mormot.core.Text,
  mormot.core.base,
  mormot.core.rtti;

{$APPTYPE CONSOLE}

type
  TWebSocketProtocolEcho = class(TWebSocketProtocolChat)
  protected
    procedure EchoFrame(Sender: TWebSocketProcess; const Frame: TWebSocketFrame);
  end;

procedure TWebSocketProtocolEcho.EchoFrame(Sender: TWebSocketProcess; const Frame: TWebSocketFrame);
begin
  TextColor(ccLightMagenta);
  write(GetEnumName(TypeInfo(TWebSocketFrameOpCode),ord(Frame.opcode))^,' - ');
  TextColor(ccWhite);
  case Frame.opcode of
  focContinuation:
    write('Connected');
  focConnectionClose:
    write('Disconnected');
  focText,focBinary: begin
    write('Echoing ',length(Frame.payload),' bytes');
    SendFrame(Sender,Frame);
    end;
  end;
  TextColor(ccCyan);
  writeln(' from ',Sender.Protocol.RemoteIP,'/',PtrInt(Sender.Protocol.URI));
end;

procedure Run;                   
var Server: TWebSocketServer;
    protocol: TWebSocketProtocolEcho;
begin
  Server := TWebSocketServer.Create('8888',nil,nil,'test');
  try
    protocol := TWebSocketProtocolEcho.Create('meow','');
    protocol.OnIncomingFrame := protocol.EchoFrame;
    Server.WebSocketProtocols.Add(protocol);
    TextColor(ccLightGreen);
    writeln('WebSockets Chat Server running on localhost:8888'#13#10);
    TextColor(ccWhite);
    writeln('Please load Project31SimpleEchoServer.html in your browser'#13#10);
    TextColor(ccLightGray);
    writeln('Press [Enter] to quit'#13#10);
    TextColor(ccCyan);
    readln;
  finally
    Server.Free;
  end;
end;


begin
  try
    Run;
  except
    on E: Exception do
      ConsoleShowFatalException(E);
  end;
end.
