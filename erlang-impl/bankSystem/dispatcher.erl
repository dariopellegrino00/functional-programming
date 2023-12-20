-module(dispatcher).

-export([start/0, stop/0, msg/1]).

start() -> 
    DisPid = spawn(fun() -> loop() end),
    global:register_name(disp, DisPid).

stop() -> global:unregister_name(disp).

loop() ->
    io:format("~p~n", [global:whereis_name(atm)]),
    receive
        Any -> io:format("~p~n", [Any])
    end,
    loop().

msg(M) -> global:whereis_name(disp)!{M}.