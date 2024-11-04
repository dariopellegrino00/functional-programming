-module(ring).
-export([start/3]).

start(_, N, _) when N =< 1 -> {error, "ring must have at least 2 processes"};
start(M, _, _) when M =< 0 -> {error, "ring must pass at least 1 message"};

start(N, M, Message) -> 
    First = spawn(fun() -> first_worker_loop(1, M-1, none) end),
    First!{new_next, create_ring(N, First), self()},
    io:format("Worker 1: created!\n"), 
    receive
        {received} -> 
            First!{first_msg, Message},
            {ok, "all messages sent"};
        _ -> {error, "error"}
    end.

create_ring(1, Next) -> Next;

create_ring(N, Next) ->
    io:format("Worker ~p: created!\n", [N]), 
    create_ring(N-1, spawn(fun() -> worker_loop(N, Next) end)).

first_worker_loop(N, M, Next) -> 
    receive 
        {new_next, Pid, Sender} ->
            Sender!{received},
            first_worker_loop(N, M, Pid); 

        {first_msg, Msg} -> 
            Next!{msg, Msg, 1},
            first_worker_loop(N, M, Next);

        {msg, Msg, C} when C-1 > M -> 
            io:format("Worker ~p: received message ~p ~p\n", [N, Msg, C]),
            Next!{stop}, 
            io:format("Worker ~p: stop!\n", [N]),
            exit("normal");

        {msg, Msg, C} -> 
            Next!{msg, Msg, C+1},
            io:format("Worker ~p: received message ~p ~p\n", [N, Msg, C]),
            first_worker_loop(N, M-1, Next);
        
        Any -> 
            io:format("Worker ~p: i received unknown ~p \n", [N, Any]),
            first_worker_loop(N, M, Next)
    end.

worker_loop(N, Next) -> 
    receive 
        {msg, Msg,  C} -> 
            Next!{msg, Msg, C},
            io:format("Worker ~p: received message ~p ~p\n", [N, Msg, C]),
            worker_loop(N, Next);
        {stop} ->
            Next!{stop}, 
            io:format("Worker ~p: stop!\n", [N]),
            exit(normal);
        Any -> 
            io:format("Worker ~p: i received unknown ~p \n", [N, Any]),
            worker_loop(N, Next)
    end.
   