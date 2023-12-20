-module(mm).
-export([loop/2]).

loop(N, Server) -> 
    group_leader(whereis(user), self()),
    link(Server),
    receive
        {reverse, S} ->
            io:format("[~p, ~p]: reverse ~p~n", [self(), N, S]),
            Server!{reverse, N, lists:reverse(S)};
        Any -> io:format("[~p, ~p]: ~p~n", [self(), N, Any])
    end,
    loop(N, Server).