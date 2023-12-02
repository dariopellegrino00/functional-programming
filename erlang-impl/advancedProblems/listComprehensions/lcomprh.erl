-module(lcomprh). 
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(LS) -> [X*X || X <- LS, is_integer(X)]. 

intersect(L1, L2) -> [X || X <- L1, lists:member(X, L2)].

symmetric_difference(L1, L2) -> lists:append([X || X <- L1, not(lists:member(X, L2))], [X || X <- L2, not(lists:member(X, L1))]). 