-module(client).
-export([is_prime/1, close/0]).
-define(SERVER, s@fedora).

rpc(Msg) -> 
    try
        {server, ?SERVER} ! Msg
    catch
        error:badarg -> 
            self() ! "Service is unavailable!"
    end,
    ok.

close() -> 
    rpc(stop).

is_prime(Int) -> 
    rpc({self(), new, Int}),
    receive 
        {result, Msg} ->  io:format("Is ~p prime? ~p~n", [Int, Msg]);
        Any -> io:format("i received : ~p~n", [Any])
        after 1000 -> io:format("Received no response after 1 seconds~n")
    end,
    ok.
