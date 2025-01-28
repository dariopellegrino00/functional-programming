-module(combinator).
-export([start/2, permutations/2]).

start(N, K) -> 
	{N, K}.


permutations(_, 0) -> [[]];
permutations(N, K) -> 
	[[X|Pi] || Pi <- permutations(N, K-1), X <- lists:seq(1, N)].
