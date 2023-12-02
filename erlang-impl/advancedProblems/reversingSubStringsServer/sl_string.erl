-module(sl_string).
-export([reverse_string/3]).

reverse_string(From, S, N) ->
    Rev = string:reverse(S),
    % the random is to make the subprocess slaves finish in random order, 
    % otherwise they always finish in order, 
    % we pretend the load is so high process dont finish in order
    RandomWait = rand:uniform(5000),
    receive 
        after RandomWait -> From!{reversed, N, Rev} 
    end,
    exit(normal).