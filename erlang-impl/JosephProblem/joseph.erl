-module(joseph).
-export([joseph/2]).


joseph(N, K) -> 
    OldJSPid = whereis(joseph),
    case OldJSPid of
        undefined ->  % case K = 0 or N = 0
            NewJSPid = spawn(fun() -> create_soldiers(N, K) end),
            register(joseph, NewJSPid);
        _ -> stop(), joseph(N, K)
    end.

create_soldiers(N, K) -> 
    FirstSoldier = spawn(fun() -> soldier:loop(undefined, N, K) end),
    io:format("In a circle of ~p people, killing number ~p~n", [N, K]),
    Pid = create_soldier(N-1, K, FirstSoldier),
    FirstSoldier!{self(), start_sending, Pid},
    loop(N).

create_soldier(1, K, FirstSoldier) -> % FIX THE SOLDIERS NUMBER
    LastSoldier = spawn(fun() -> soldier:loop(FirstSoldier, 1, K) end),
    LastSoldier;

create_soldier(M, K, FirstSoldier) ->
    Spid = spawn(fun() -> soldier:loop(create_soldier(M-1, K, FirstSoldier), M, K) end),
    Spid.




stop() -> exit(whereis(joseph), normal),
          unregister(joseph).  

loop(N) -> 
    receive
        {survivor, Pos} -> 
            io:format("Joseph is the Soldier in position ~p~n", [N - Pos + 1]),
            stop();
        _ -> loop(N)    
    end.
            

        


        
        