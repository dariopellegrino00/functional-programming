-module(dummy_client).
-export([start/0, dummy1/0, dummy2/0, dummy3/0, dummy4/0, dummy5/0, tot/0]).

start() -> 
    Server = whereis(counting_server),
    case Server of 
        undefined -> io:format("counting_server not found, try to start the server first");
        _ -> ok
    end.

send(Message) -> 
    counting_server!{self(), Message},
    receive
        Response -> Response
    after
        5000 -> {error, timeout}
    end.

dummy1() -> send(dummy1).

dummy2() -> send(dummy2).

dummy3() -> send(dummy3).

dummy4() -> send(dummy4).

dummy5() -> send(dummy5).

tot() -> send(tot).