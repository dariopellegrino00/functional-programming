-module(echo).
-export([start/0, print/1, stop/0, loop/0]).

start() -> register(echo, spawn(echo, loop, [])),
           ok.

print(Term) -> echo!{input, Term},
               ok.

stop() -> echo!{stop, "stop"},
          ok.

loop() -> 
    receive 
        {input, M} -> io:format("~p: ~p~n", [echo, M]),
                      loop();
        {stop, _} -> io:format("~p stopping \n", [echo]),
                     exit(echo),
                     unregister(echo);
        other -> io:format("~p: error", [echo]),
                 loop()
    end.
