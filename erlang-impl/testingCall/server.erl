-module(server).
-export([start/0]).

start() -> 
    Pid = spawn(fun() -> loop() end),
    register(server, Pid).


loop() -> 
    receive
        Any -> io:format("~p~n", [Any])
    end,
    loop().