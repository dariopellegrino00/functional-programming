-module(peer_client).
-export([start/1, start_chatting/1, msg/1, add_peer/1, exit/0, stop/0]).

-define(PEERS, [a@fedora, b@fedora, c@fedora]).

start(Name) -> 
    try
        stop(),
        unregister(peer),
        start(Name)
    catch
        error:badarg -> 
            register(peer, spawn(fun() -> loop(?PEERS, Name, none) end)),
            io:format("LOG: started ~n")
    end.

start_chatting(Channel) -> 
    peer!{chat, Channel},
    ok.

msg(Msg) ->
    peer!{msg, Msg},
    ok.

add_peer(Node) -> 
    peer ! {add_peer, Node},
    ok.

exit() -> 
    peer ! {exit},
    ok.

stop() -> 
    peer ! {stop, auto}.

loop(Peers, Name, Current) ->
    receive
        {stop, auto} -> 
            exit(normal);
        {chat, Channel} -> 
            case Channel of 
                C when (C =:= none) or (C =:= Current) -> 
                    loop(Peers, Name, Current);
                _ -> 
                    message_chat(Peers, {exit, Name, Current}),
                    io:format("~p joined the chat room.~n", [Name]),
                    message_chat(Peers, {chat, Name, Channel}),
                    loop(Peers, Name, Channel)
            end;
        {chat, From, Current} -> 
            io:format("~p joined the chat room.~n", [From]),
            loop(Peers, Name, Current);
        {chat, _, _} -> 
            loop(Peers, Name, Current);
        {msg, Msg} -> 
            io:format("~p: ~p~n", [Name, Msg]),
            message_chat(Peers, {msg, Name, Current, Msg}),
            loop(Peers, Name, Current);
        {msg, From, Current, Content} -> 
            io:format("~p: ~p~n", [From, Content]),
            loop(Peers, Name, Current);
        {msg, _, _, _} -> 
            loop(Peers, Name, Current);
        {exit, _, none} -> 
            loop(Peers, Name, Current);
        {exit, From, Current} -> 
            io:format("~p left the chat room.~n", [From]),
            loop(Peers, Name, Current);
        {exit, _, _} -> 
            loop(Peers, Name, Current);
        {exit} ->
            case Current of 
                none -> ok;
                _ -> 
                    message_chat(Peers, {exit, Name, Current})
            end,
            loop(Peers, Name, none);
        Any -> 
            io:format("LOG: Unknown ~p~n", [Any]),
            loop(Peers, Name, Current)
    end.

message_chat(Peers, Msg) -> 
    Me = node(),
    [{peer, X} ! Msg || X <- Peers, X =/= Me]. 
