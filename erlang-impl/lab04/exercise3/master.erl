-module(master).
-export([start/1, to_slave/2]).

% starts the master and tell it to start N slave processes 
% and registers the master as the registered process master
% require N > 0
start(N) -> 
    OldSpid = whereis(master),
    case OldSpid of
        undefined -> 
            Spid = spawn(fun() -> createSlave(N, #{}) end),
            io:format("Mater: now running at ~p~n", [Spid]),
            register(master, Spid);
            % global:register_name(master, Spid),
            % group_leader(global:whereis_name(master), self()),
        _ -> stop(), start(N)
    end.
    

createSlave(0, M) -> 
    io:format("Loop Master ~n", []),
    process_flag(trap_exit, true),
    loopMaster(M);
createSlave(N, M) -> 
    SlavePid = spawn_link(fun() -> loopSlave() end),
    io:format("Master: Slave ~p is now running at ~p~n", [N, SlavePid]),
    createSlave(N-1, maps:put(N, SlavePid, M)).

sendMsg(Message, Pid, N) -> 
    Pid!{msg, Message},
    receive 
        {Pid, _} -> 
            io:format("Master: slave ~p at ~p is running~n", [N, Pid]),
            ok
        after 5000 -> 
            error                    
    end.


checkSlaves(M) -> 
    % io:format("Master: Checking Slaves ~n", []),
    NewMap = maps:fold(fun(K, V, Acc) -> 
        Pid = case sendMsg(running, V, K) of 
            ok -> 
                V;
            error -> 
                % io:format("Master: Slave ~p not running~n", [K]),
                NewPid = spawn_link(fun() -> loopSlave() end),
                io:format("Master: restarted ~p, now running at ~p~n", [K, NewPid]),
                NewPid
        end,
        maps:put(K, Pid, Acc)
    end, #{}, M),
    loopMaster(NewMap).

% consider is alive?
loopMaster(M) -> 
    receive 
        {'EXIT',Pid, Type} -> 
            io:format("Exit at ~p detected, exit type ~p~n", [Pid, Type]),
            checkSlaves(M);
        {send, Message, N} -> 
            sendMsg(Message, maps:get(N, M), N),
            loopMaster(M);
        Other -> 
            io:format("Error ~p", [Other]),
            loopMaster(M)
    end.

to_slave(Message, N) -> 
    io:format("sending ~p to ~p~n", [Message, N]),
    master!{send, Message, N}.

loopSlave() -> 
    receive 
        {msg, running} -> 
            S = self(),
            io:format("~p: im running!~n", [S]),
            master!{S, running},
            loopSlave();   
        {msg, die} ->
            exit(normal);
        {msg, Message} ->
            S = self(),
            io:format("~p: I received ~p~n", [S, Message]),
            exit(normal);
        Other -> 
            S = self(),
            io:format("~p: Error: i received~p~n", [S, Other]),
            loopSlave()
    end.


stop() -> exit(global:whereis_name(master), stop).