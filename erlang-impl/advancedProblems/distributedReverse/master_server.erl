-module(master_server).
-export([start/0, start/1]).

start() -> start(10).

start(Splits) -> 
    Auth = 1221920, % randomize this
    try
       master ! {stop, Auth},
       unregister(master),
       start()
    catch 
        error:badarg ->
            ServerPID = spawn(fun() -> master_loop(Auth, [], 0, 0, Splits, none) end),
            register(master, ServerPID) 
    end.

long_reversed_String(Str, Splits) -> 
    StrLen = string:len(Str),
    case StrLen < Splits of 
        true -> 
            N = 0,
            M = StrLen,
            Len = 1;
        false -> 
            N = string:len(Str) rem Splits,
            M = Splits - N,
            Len = string:len(Str) div Splits
    end,
    [spawn_slave(string:substr(Str, (N)*(Len+1) + I * Len, Len), N+I) || I <- lists:seq(1, M)] ++ 
    [spawn_slave(string:substr(Str, I * (Len+1) + 1, Len+1), I) || I <- lists:seq(0, N-1)],
    N+M.

spawn_slave(String, Id) -> 
    spawn(fun() -> master!{self(), Id, reversed, reverse(String), 1221920}, slave_loop(Id) end).

master_loop(Auth, Reversed, L, C, Splits, Client) -> 
    receive
        {stop, Auth} -> exit(normal);
        {From, long_reverse, Str} -> 
            try 
                Len = long_reversed_String(Str, Splits),
                master_loop(Auth, [], Len, 0, Splits, From)
            catch 
                error:badarg -> 
                    io:format("SERVER ERROR: badarg not a string ~p~n", [Str]),
                    master_loop(Auth, [], 0, 0, Splits, From)
            end;
        {Pid, SlaveN, reversed, RevStr, Auth} ->
            case (C >= L-1) and (L =/= 0)  of 
                true -> 
                    CompareTuples = 
                        fun(A, B) -> 
                            case {A, B} of
                                {{N1, _}, {N2, _}} -> N1 =< N2;
                                {{_, _}, _} -> false;
                                {_, {_, _}} -> true 
                            end
                        end,
                    send_reversed_back(Client, lists:sort(
                        CompareTuples,
                        [{SlaveN, RevStr}|Reversed])),
                    Pid!{ack, Auth},
                    io:format("reversed, waiting...\n"),
                    master_loop(Auth, [], 0, 0, Splits, Client);
                false ->
                    Pid!{ack, Auth},
                    master_loop(Auth, [{SlaveN, RevStr}|Reversed], L, C+1, Splits, Client)
            end;
        {_, reversed, _, _} -> 
            io:format("SERVER: i received a wrong Auth token, rejecting~n"),
            master_loop(Auth, Reversed, L, C, Splits, Client);
        Any -> 
            io:format("SERVER: i received unknown format ~p~n", [Any]),
            master_loop(Auth, Reversed, L, C, Splits, Client)
    end.

slave_loop(_) -> 
    receive
        {ack, 1221920} -> ok 
    end.

reverse([]) -> [];
reverse([C|Str]) -> 
    reverse(Str) ++ [C].


send_reversed_back(Client, Strings) ->
    io:format("~p~n", [Strings]),
    Client ! {reversed, lists:foldl(fun({_, E}, Acc) -> E ++ Acc end, "", Strings)}.
