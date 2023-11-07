-module(sequential).
-export([is_palindrome/1]).
-export([is_anagram/2]).

is_palindrome(S) -> S == lists:reverse(S).

is_anagram(_, []) -> false;
is_anagram(S, [H| TL]) ->  (lists:sort(S) == lists:sort(H)) or is_anagram(S, TL). 



