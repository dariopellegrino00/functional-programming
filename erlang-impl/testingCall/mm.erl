-module(mm). 
-export([start/1]).

start(From) ->
    group_leader(whereis(user), self()),
    io:format("alora ~p~n", [From]),
    rpc:call(From, client, message, ["sono middle man!~n"]),
    io:format("teschio~n").
