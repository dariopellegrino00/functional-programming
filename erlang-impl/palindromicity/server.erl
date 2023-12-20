-module(server).
-export([loop/0]).

loop() -> 
    group_leader(whereis(user), self()),
    receive
        {reverse, N, S} -> io:format("SERVER: received from MM~p reversed ~p~n", [N, S]);
        Other -> io:format("SERVER: received ~p~n", [Other])
    end,
    loop().

