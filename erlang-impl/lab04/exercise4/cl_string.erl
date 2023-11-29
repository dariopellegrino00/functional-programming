-module(cl_string).
-export([request_reversed_string/1]).

-define(MASTERSERVER, mss@Scavallo).  % Pc name may change
-define(MSMODULE, ms_string).

%TODO implement a requestreversed that reads a long string from file  
request_reversed_string(String) -> 
    N = node(),
    F = self(),
    rpc:call(?MASTERSERVER, ?MSMODULE, long_reverse_string, [N, F, String]).

    % Receive part

