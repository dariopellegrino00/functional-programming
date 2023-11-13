-module(sequential).
-export([is_palindrome/1]).
-export([is_anagram/2]).
-export([factors/1]).
-export([is_proper/1]).

is_palindrome(S) -> S == lists:reverse(S).

is_anagram(_, []) -> false;
is_anagram(S, [H| TL]) ->  (lists:sort(S) == lists:sort(H)) or is_anagram(S, TL). 

factors(1) -> [];
factors(N) when (N > 1) -> factors(N, 2, []).
factors(1, _, Factors) -> Factors;
factors(N, Divisor, Factors) when N rem Divisor == 0 -> 
    factors(N div Divisor, Divisor, [Divisor | Factors]); 
factors(N, Divisor, Factors) when (N =< Divisor) -> [N|Factors];
factors(N, Divisor, Factors) -> factors(N, Divisor + 1, Factors).

is_proper(N) when N =< 5 -> false;
is_proper(N) when N > 5  -> is_proper(N, 1) == N.

is_proper(N, Divisor) when N =< Divisor -> 0;
is_proper(N, Divisor) when N rem Divisor == 0 -> Divisor + is_proper(N, Divisor+1);
is_proper(N, Divisor) when N rem Divisor =/= 0 -> is_proper(N, Divisor+1).




