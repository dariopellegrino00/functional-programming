-module(dks_client).

-export([
  store/2, 
  lookup/1
]).

-define(NODE1, n1@PCDario).
-define(NODE2, n2@PCDario).
-define(MODULE_SERVER, dkvs_server).

store(K, V) ->
  rpc:call(?NODE1, ?MODULE_SERVER, store, [self(), K, V]),
  rpc:call(?NODE2, ?MODULE_SERVER, store, [self(), K, V]),
  recStore(),
  recStore().
  
recStore() -> 
  receive
    {SPid, S, {stored}} -> io:format("Received stored from ~p (~p)~n", [SPid, S]);
    Other -> io:format("Error received ~p~n", [Other])
  end.

lookup(K) ->
  Node = get_random_node(),
  rpc:call(Node, ?MODULE_SERVER, lookup, [self(), K]),
  receive
    {SPid, S, {lookup, {ok, V}}} when S == Node -> io:format("Received ~p from ~p (~p)~n", [V, S, SPid]);
    Other -> io:format("Error received ~p~n", [Other])
  end.

get_random_node() -> 
  RandomNumber = rand:uniform(2),
    case RandomNumber of
        1 -> ?NODE1;
        2 -> ?NODE2
    end.