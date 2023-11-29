-module(ms_string).
-export([long_reverse_string/3, start/0]).

start() -> 
    OldSpid = whereis(master),
    case OldSpid of
        undefined -> 
            Spid = spawn(fun() -> loop() end),
            register(master, Spid),
            io:format("--- Master server created at ~p~n", [Spid]);
        _ -> stop(), start()
    end.

stop() -> 
    exit(whereis(master), normal),
    unregister(master),
    io:format("--- Master server exit~n", []).

rpc(M) -> 
    whereis(master)!M.

long_reverse_string(Node, From, String) -> rpc({rev,{Node, From, String}}).

%TODO different pcs for client?
start_reversing(_, S, 1) -> 
    Self = whereis(master),
    spawn(fun() -> sl_string:reverse_string(Self, S, 1) end);
start_reversing(Lsub, S, SlaveN) -> 
    LenS = string:len(S),
    NewS = string:right(S, LenS - trunc(Lsub)),
    SubS = string:left(S, trunc(Lsub)),
    Self = whereis(master),
    spawn(fun() -> sl_string:reverse_string(Self, SubS, SlaveN) end),
    start_reversing(Lsub, NewS, SlaveN-1).

loop() -> 
    receive 
        {msg, M} -> io:format("--- MasterServer: received ~p~n", [M]);
        {rev, {_, _, S}} ->  % TODO check if it string 
            io:format("--- MasterServer: reversing the string~n"),
            L = math:ceil(string:len(S) / 10),
            start_reversing(L, S, 10);
        {reversed, From, S} -> io:format("--- MasterServer: reversed ~p~n from slave ~p~n", [S, From] );
        Other -> io:format("--- MasterServer error: ~p~n", [Other])
    end.

   
    
