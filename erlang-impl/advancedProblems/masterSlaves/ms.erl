-module(ms).
-export([start/1, to_slave/2]). 

start(N) -> 
    Slaves = [spawn(fun() -> slave_loop() end) || _ <- lists:to_seq(0, N-1)],
    register(master, fun() -> 
        process_flag(trap_exit, true),
        loop(Slaves) 
    end).
    
loop(Slaves) -> 
    receive
        {slave_msg, N ,Msg} -> list:nth(N, Slaves) ! Msg;
        msg -> io:format("slave: unknowk, i received this:~p~n", [msg]) 
        after 10000 -> ok
    end.

slave_loop() -> 
    receive 
        msg -> io:format("slave: i received this msg:~p~n", [msg]) 
        after 10000 -> ok
    end.

to_slave(Msg, N) -> whereis(master) ! {to_slave, N, Msg}.