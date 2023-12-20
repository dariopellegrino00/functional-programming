-module(client).
-export([start/0, close/0, is_palindrome/1]).

start() -> 
    {ok, Hostname} = inet:gethostname(),
    io:format("~p~n", [Hostname]),
    ServerNode = list_to_atom("server@" ++ Hostname),
    MM1Node = list_to_atom("mm1@" ++ Hostname),
    MM2Node = list_to_atom("mm2@" ++ Hostname),

    Server = spawn(ServerNode, server, loop, []),
    MM1 = spawn(MM1Node, mm, loop, [1, Server]),
    MM2 = spawn(MM2Node, mm, loop, [2, Server]),
    Client = spawn(fun() -> loop(MM1, MM2) end),
    case whereis(client) of
        undefined -> 
            Server!{msg, "kattarak" ++ Client},
            register(client, Client);
        _ -> close(), start()
    end.
    


loop(MM1, MM2) -> 
    group_leader(whereis(user), self()),
    link(MM1),
    link(MM2),
    receive
        {palindrome, S} -> 
            {First, Second} = reverse(S),
            MM1!{reverse, First},
            MM2!{reverse, Second},
            loop(MM1, MM2);
        close -> exit(close);
        Other -> io:format("ERROR: i received ~p~n", [Other])
    end.


close() -> whereis(client)!close.

is_palindrome(S) -> whereis(client)!{palindrome, S}.
          
reverse(S) -> reverse(length(S) rem 2, S).
reverse(0, S) -> 
    {lists:sublist(S, 1, length(S) div 2), 
    lists:sublist(S, length(S) div 2 + 1, length(S))};
reverse(_, S) -> 
    {lists:sublist(S, 1, length(S) div 2 + 1), 
    lists:sublist(S, length(S) div 2 + 1, length(S))}.


