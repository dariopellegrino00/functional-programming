-module(echo_client).
-export([start/0, print/1, stop/0]).

start() -> 
            ServerPID = whereis(server),
            case ServerPID of 

            undefined -> io:format("The echo server has not started yet, try to run the echo server first~n");

            _ -> link(ServerPID),
                 io:format("Connected to echo server. ~n")

            end.

print(Message) -> echo:print(Message).

stop() -> io:format("Echo client stopping. ~n"),
          exit(stopped).

