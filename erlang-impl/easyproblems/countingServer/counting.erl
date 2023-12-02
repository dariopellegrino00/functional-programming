-module(counting).
-export([start/0, loop/5, stop/0]).

start() ->  try 
                register(counting_server, spawn(?MODULE, loop, [0, 0, 0, 0, 0]))
            catch
                error:badarg -> io:format("The counting server was already started, the server is now close, rerun this command~n")
            end,
            ok.

loop(Dc1, Dc2, Dc3, Dc4, Dc5) -> 
    receive
        {stop_server, stop} -> io:format("The counting server is stopping~n"), exit(normal);
        {Client, dummy1} -> Client!{dummy1, ok}, loop(Dc1+1, Dc2, Dc3, Dc4, Dc5);
        {Client, dummy2} -> Client!{dummy2, ok}, loop(Dc1, Dc2+1, Dc3, Dc4, Dc5);
        {Client, dummy3} -> Client!{dummy3, ok}, loop(Dc1, Dc2, Dc3+1, Dc4, Dc5);
        {Client, dummy4} -> Client!{dummy4, ok}, loop(Dc1, Dc2, Dc3, Dc4+1, Dc5); 
        {Client, dummy5} -> Client!{dummy5, ok}, loop(Dc1, Dc2, Dc3, Dc4, Dc5+1);
        {Client, tot}    -> Client!{{dummy1, Dc1}, {dummy2, Dc2}, {dummy3, Dc3}, {dummy4, Dc4}, {dummy5, Dc5}, {tot, Dc1+Dc2+Dc3+Dc4+Dc5}};
        {Client, _} -> Client!{"service does not exist"}
    end.

stop() -> {stop_server, stop}.