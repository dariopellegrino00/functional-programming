-module(starter).
-export([start_ringer/1]).

start_ringer(N) ->
    try 
        gnu ! {nonmore},
        start_ringer(N)
    catch 
        error:badarg -> 
            register(gnu, spawn(fun() -> loop() end)),
            rpc:call(magnum@fedora, ring, start, [N])
    end.

loop() -> 
    receive
        {nonmore} -> 
            unregister(gnu),
            exit(crash);
        Any -> io:format("Received ~p~n", [Any])
    end.
