-module(ring).
-export([start/1, create/3]).

start(N) -> 
   register(rring_fst, spawn(?MODULE, create, [N, 1, self()])),
    io:format("*** [rring_fst] is at ~p~n", [whereis(rring_fst)]).

create(1, Who, Starter) ->
  Starter ! ready,
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, rring_fst]);
create(N, Who, Starter) ->
  Next = spawn(?MODULE, create, [N-1, Who+1, Starter]),
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, Next]).

