-module(ring).
-export([start/1, stop/0, scrive/0, message/1, message/2]).
-define(A, a@fedora).

start(N) when N < 1 -> 
    "Invalid ring size";
start(N) ->
    try
        stop(),
        start(N)
    catch 
        error:badarg -> 
            group_leader(whereis(user), self()),
            register(first, spawn(fun() -> create(N, N) end))
    end.

scrive() -> 
    {gnu, ?A} ! "ooooo".

stop() -> 
    first ! {exit}.

create(N, 1) ->
    loop_last(first, N-1);
create(N, C) ->
    Next = spawn_link(fun() -> create(N, C-1) end),
    loop(Next, N-C).

message(Msg) -> 
    message(Msg, 1).

message(_, M) when M < 1 -> 
    "Invalid message count";
message(Msg, N) -> 
    first ! {starter, Msg, N}.
    
loop(Next, N) -> 
    receive
        {exit} -> 
            unregister(first),
            exit(crash);
        {_, _, 0} -> 
            loop(Next, N);
        {From, Msg, C} -> 
            io:format("~p Received ~p from ~p~n", [N, Msg, From]),
            Next ! {N, Msg, C},
            loop(Next, N);
        {From, Msg} -> 
            io:format("~p Received ~p from ~p~n", [N, Msg, From]),
            Next ! {N, Msg},
            loop(Next, N);
        Any -> io:format("~p Received ~p~n", [N, Any])
    end.

loop_last(Next, N) -> 
    receive
        {_, _, 0} -> 
            loop_last(Next, N);
        {From, Msg, C} -> 
            io:format("~p Received ~p from ~p~n", [N, Msg, From]),
            Next ! {N, Msg, C-1},
            loop_last(Next, N);
        {From, Msg} -> 
            io:format("~p Received ~p from ~p~n", [N, Msg, From]),
            loop_last(Next, N);
        Any -> io:format("~p Received ~p~n", [N, Any])
    end.
