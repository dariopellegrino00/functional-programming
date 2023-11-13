-module(echo).
-export([start/0, print/1, stop/0, loop/0]).

start() ->  try 
                register(echo, spawn(echo, loop, []))
            catch
                error:badarg -> io:format("The echo server is already started~n")
            end,
            ok.


print(Term) ->  try
                    echo!{input, Term}
                catch 
                    error:badarg -> io:format("The echo server has not started yet, try to run 'echo:start()'  and then rerun this command~n")
                end,
                ok.

stop() ->   try
                echo!{stop, "stop"}
            catch 
                error:badarg -> io:format("The echo server has not started yet, try to run 'echo:start()' and then rerun this command~n")
            end,
            ok.   

loop() -> 
    receive 
        {input, M} -> io:format("~p: ~p~n", [echo, M]),
                    loop();
        {stop, _}  -> io:format("~p stopping \n", [echo]),
                    exit(echo),
                    unregister(echo);
        other -> io:format("~p: error", [echo]),
                loop()
    end.
    

