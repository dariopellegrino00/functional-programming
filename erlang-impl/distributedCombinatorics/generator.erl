-module(generator).
-export([node_loop/4]).

permutation_column(N, K, I) when I =< 0; K =< 0; N =< 0 ; I > K -> {error, badarg};
permutation_column(N, K, I) ->
    Pattern = [X || X <- lists:seq(1, N), _ <- lists:seq(1,trunc(math:pow(N, K-I)))],
    complete_column(Pattern, trunc(math:pow(N, I-1)), []).

complete_column(_, X, _) when X =< 0-> {error, badarg};
complete_column(P, 1, Acc) -> P ++ Acc;
complete_column(P, X, Acc) -> complete_column(P, X-1, Acc ++ P).


node_loop([], _, _, _) -> exit(normal);
node_loop(Column=[E|Col], I, Next, C) -> 
	receive
		start -> 
			Next ! {perm, C, [E]},
			self() ! start, % change this 
			node_loop(Col, I, Next, C+1);
		{perm, C, P} -> 
			Next ! {perm, C, [E|P]},
			node_loop(Col, I, Next, C+1);
		Any -> io:format("~p: i received this ~p~n", [I, Any])
	end,
	node_loop(Column, I, Next, C);

node_loop(N, K, I, Next) -> 
	node_loop(permutation_column(N, K, I), I, Next, 0).
