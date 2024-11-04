-module(sequential).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

% Function made using only self made code, 
% can be done in one row with libs

is_alphanumeric(C) -> 
    (C >= 65) and (C =< 90) or 
    (C >= 97) and (C =< 122) or 
    (C >= 48) and (C =< 57).

ascii_lower_case(H) -> 
    case (H >= 65) and (H =< 90) of 
        true -> H + 32;
        false -> H
    end.

is_palindrome(S) -> is_palindrome(S, [], []).
is_palindrome([], S, ACC) -> S =:= ACC;
is_palindrome([H|T], S, ACC) -> 
    case is_alphanumeric(H) of 
        true -> 
            LowerH = ascii_lower_case(H), 
            is_palindrome(T, S ++ [LowerH], [LowerH|ACC]);
        false -> is_palindrome(T, S, ACC)
    end.


is_an_anagram(S, [Hd|Dict]) -> 
        (lists:sort(string:to_lower(S)) =:= lists:sort(string:to_lower(Hd))) orelse is_an_anagram(S, Dict);
is_an_anagram(_, []) -> false.


factors(N) -> factors(N, 2, []).

factors(1, _, Acc) -> lists:reverse(Acc);
factors(N, Factor, Acc) when N rem Factor =:= 0 ->
    factors(N div Factor, Factor, [Factor | Acc]);
factors(N, Factor, Acc) ->
    factors(N, Factor + 1, Acc).

is_proper(0) -> false; 
is_proper(N) -> is_proper(abs(N), 2, 1).

is_proper(N, M, Sum) when M * 2 =< N -> 
    case N rem M of
        0 -> is_proper(N, M+1, M+Sum);
        _ -> is_proper(N, M+1, Sum)
    end;
is_proper(N, _, Sum) -> N =:= Sum.