-module(dks_server).

-export([
         start/0, 
         stop/0, 
         store/3,
         lookup/2
        ]).

start() ->
  OldSPid = whereis(dkvs_s),
  case OldSPid of
    undefined ->
      SPid = spawn(fun() -> loop(#{}) end),
      register(dss, SPid),
      io:format(" The server ~p started at ~p on the node ~p~n",
                [dss, SPid, node()]);
    _ -> stop(), start()
  end.

stop() ->
  exit(whereis(dss), stop),
  unregister(dss),
  io:format("Server stop~n").

store(From, K, V) -> rpc(From, {store, K, V}).
lookup(From, K) -> 
  rpc(From, {lookup, K}).
rpc(From, M) -> dss ! {From, M}.

loop(M) ->
  receive
    {From, {store, K, V}} -> 
        io:format("store received key:~p value:~p from ~p~n", [K, V, From]),
        From!{self(), node(), {stored}},
        M1 = maps:put(K, V, M),
        io:format("~p~n", [M1]),
        loop(M1);
    {From, {lookup, K}} -> 
        io:format("lookup key:~p from ~p~n", [K, From]),
        V = maps:find(K, M),
        case V of 
          error -> From!{self(), node(), {"could not find key:", K}};
          _ -> From!{self(), node(), {lookup, V}}
        end,
        loop(M);

    Other -> 
        io:format("Error: received ~p~n", [Other]), 
        loop(M)
  end.