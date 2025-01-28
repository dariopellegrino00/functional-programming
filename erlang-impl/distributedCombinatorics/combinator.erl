-module(combinator).
-export([start/2]).

start(N, K) -> 
	try
		exit(whereis(master), normal),
		unregister(master)
	catch
		_:_ -> ok
	end,
	First = start(N, K, N),
	First ! start,
	ok.
	
start(_, _, 0) -> 
	register(master, Pid=spawn(fun() -> collector(0) end)),
	Pid;
	
start(N, K, I) -> 
	spawn(generator, node_loop, [N, K, I, start(N, K, I-1)]).

collector(C) -> 
	receive
		{perm, C, P} -> %use count to close?
			io:format("~p~n", [P]),
			collector(C+1);
		Any -> io:format("Collector: i received this ~p~n", [Any])
	end,
	collector(C).
