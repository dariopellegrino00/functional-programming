-module(echo).
-export([start/0, print/1, stop/0, loop/0]).

start() ->  try 
                register(server, spawn(?MODULE, loop, []))
            catch
                error:badarg -> io:format("The echo server is already started~n")
            end,
            ok.


print(Term) ->  try
                    server!{input, Term}
                catch 
                    error:badarg -> io:format("The echo server has not started yet, try to run 'echo:start()'  and then rerun this command~n")
                end,
                ok.

stop() ->   try
                server!{stop, "stop"}
            catch 
                error:badarg -> io:format("The echo server has not started yet, try to run 'echo:start()' and then rerun this command~n")
            end,
            ok.   

loop() -> 
    receive 
        {input, M} ->   io:format("~p: ~p~n", [server, M]),
                        loop();
        {stop, _}  ->   io:format("~p stopping \n", [server]),
                        exit(stopped);
        other ->    io:format("~p: error", [server]),
                    loop()
    end.
    

