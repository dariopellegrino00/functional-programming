-module(sl_string).
-export([reverse_string/3]).

reverse_string(From, S, N) ->
    io:format("~p: reversing ~p~n", [N, S]),
    Rev = string:reverse(S),
    io:format("~p: reversed ~p~n ", [N, S]),
    From!{reversed, N, Rev}.