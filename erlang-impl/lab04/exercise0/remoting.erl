-module(store).
-export([start/2, create/1, send_msg/2, stop/1]).

start(N, L) -> spawn(N, store, create, [L]).

create(L) -> 
    group_leader(global:whereis_name(user), self()),
    global:register_name(L, self()),
    io:format("Actor ~p, created on ~p and registered as ~p~n", [self(), node(), L]),   
    wait().

wait() -> 
    io:format("waiting ~n", []),
    receive
        {msg, M} -> io:format("Was waiting, finally got: ~p~n", [M]), wait();
        {stop} -> io:format("Stopping~n", []);
        Other ->  io:format("Maybe something went wrong? I received ~p~n", [Other]), wait()
    end.

send_msg(L, M) -> global:whereis_name(L)!{msg, M}.
stop(L) -> global:whereis_name(L)!{stop}.