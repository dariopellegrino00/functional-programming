-module(ms_string).
-export([long_reverse_string/3, start/0]).

%more than 10 slave process
start() -> 
    OldSpid = whereis(master),
    case OldSpid of
        undefined -> 
            Spid = spawn(fun() -> loop(#{},"", 0, 0) end),
            register(master, Spid),
            io:format("--- Master server created at ~p~n", [Spid]);
        _ -> stop(), start()
    end.

stop() -> 
    exit(whereis(master), normal),
    unregister(master),
    io:format("--- Master server exit~n", []).

rpc(M) -> 
    whereis(master)!M,
    ok.

long_reverse_string(Node, From, String) -> rpc({rev,{Node, From, String}}).

%TODO different pcs for client?
start_reversing(_, S, 1) -> 
    Self = self(),
    spawn(fun() -> sl_string:reverse_string(Self, S, 1) end);
start_reversing(Lsub, S, SlaveN) -> 
    LenS = string:len(S),
    NewS = string:right(S, LenS - trunc(Lsub)),
    SubS = string:left(S, trunc(Lsub)),
    Self = self(),
    spawn(fun() -> sl_string:reverse_string(Self, SubS, SlaveN) end),
    start_reversing(Lsub, NewS, SlaveN-1).

send_back(SlavesSubSMap, NodeFrom, ModuleFrom) -> 
    SortedRevKeysList = lists:reverse(lists:sort(maps:keys(SlavesSubSMap))),
    ReversedString = lists:foldl((fun(X, Acc) -> maps:get(X, SlavesSubSMap) ++ Acc end), "", SortedRevKeysList),
    io:format("--- Master: sending reversed string back~n", []),
    rpc:call(NodeFrom, ModuleFrom, rpc, [{reversed, ReversedString}]),
    loop(#{}, "", 0, 0).

loop(SlavesSubSMap, ModuleFrom, CountSlaves, NodeFrom) -> 
    receive 
        {msg, M} -> 
            io:format("--- MasterServer: received ~p~n", [M]),
            loop(SlavesSubSMap, ModuleFrom, CountSlaves, NodeFrom);  
        {rev, {NewNodeFrom, NewModuleFrom, S}} ->  % TODO check if it string 
            io:format("--- MasterServer: reversing the string~n"),
            L = math:ceil(string:len(S) / 10),
            start_reversing(L, S, 10),
            loop(#{}, NewModuleFrom, 0, NewNodeFrom); 
        {reversed, SlaveN, S} -> 
            io:format("--- MasterServer: slave ~p reversed ~n", [SlaveN]),  
            NewSlavesSubSMap = maps:put(SlaveN, S, SlavesSubSMap),
            case CountSlaves of
                9  -> send_back(NewSlavesSubSMap, NodeFrom, ModuleFrom);
                _  -> loop(NewSlavesSubSMap, ModuleFrom, CountSlaves + 1, NodeFrom)  
            end;
        Other -> 
            io:format("--- MasterServer error: ~p~n", [Other]),
            loop(SlavesSubSMap, ModuleFrom, CountSlaves, NodeFrom)  
    end.

   
    
