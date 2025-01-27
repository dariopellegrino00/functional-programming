-module(controller).
-export([start/0]).


start() -> 
    try
        unregister(server),
        server ! stop,
        start()
    catch 
        error:badarg -> 
            Pid = spawn(fun() -> loop() end),
            register(server, Pid),
            ok
    end.

loop() -> 
    receive 
        stop -> ok;
        {From, new, _} -> From ! {result, false}, loop();
        Any -> io:format("i received : ~p~n", [Any]), loop()
    end.
