-module(soldier).
-export([loop/3]).  

loop(Next, N, K) -> 
    receive
        {From, start_sending, NewNext} -> 
            Spid = whereis(joseph),
            case From of 
                Spid -> NewNext!{self(), 2},
                        loop(NewNext, N ,K);
                _    -> loop(Next, N, K)
            end;
        {From, K} -> 
            From!{Next, suicide},
            Next!{self(), 1},
            stop();
        {NewNext, suicide} -> 
            loop(NewNext, N, K);   
        {From, Count} ->
            S = self(),
            case From of
                S ->
                    whereis(joseph)!{survivor, N},
                    stop();              
                _ -> 
                    Next!{self(), Count+1},
                    loop(Next, N, K)
            end                 
    end.

stop() -> exit(normal).