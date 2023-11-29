-module(cl_string).
-export([request_reversed_string/1, request_reversed_string/0, rpc/1]).

-define(MASTERSERVER, mss@PCDario).  % Pc name may change
-define(MSMODULE, ms_string).

%TODO implement a requestreversed that reads a long string from file  

start() -> 
    OldCPid = whereis(client),
    case OldCPid of
        undefined -> 
            register(client, spawn(fun() -> loop() end));
        _ -> 
            stop(),
            start()
    end.

stop() -> 
    exit(whereis(client), normal),
    unregister(client).

loop() -> 
    receive
        {reverse_this, S} -> 
            N = node(),
            rpc:call(?MASTERSERVER, ?MSMODULE, long_reverse_string, [N, ?MODULE, S]),
            loop();
        {reversed, S} -> 
            io:format("received reveresed string!~n", []),
            io:format("string :~n ~s~n", [S]),
            loop();
        Other -> 
            io:format("ERROR received ~p~n", [Other])
        after 10000 -> 
            io:format("received no response from server!~n"),
            stop()  
    end.

request_reversed_string(String) -> 
    start(),
    rpc({reverse_this, String}).

request_reversed_string() -> 
    start(),
    {ok, BinaryData} = file:read_file("input.txt"),
    StringData = binary_to_list(BinaryData),
    io:format("File contents: ~s~n", [StringData]),
    rpc({reverse_this, StringData}).

rpc(M) -> 
    whereis(client)!M,
    ok.