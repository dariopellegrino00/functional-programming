-module(sleepsort).
-export([sort/1]).
-define(Node(N), list_to_atom("node" ++ integer_to_list(N) ++ "@fedora")).

sort(IntList) -> 
	case whereis(master) of  
		undefined -> 
			register(master, self()),
			Nodes = sort(IntList, 1, []), 
			[X ! start|| X <- Nodes],
			wait([]);
		_ -> 
			unregister(master),
			sort(IntList)
	end.

sort([], _, _) -> [];
sort([X], N, Nodes) -> 
	Pid = spawn(?Node(N), fun() -> sleep_last(X) end), [Pid|Nodes];
sort([X|L], N, Nodes) -> 
	Pid = spawn(?Node(N), fun() -> sleep(X) end), sort(L, N+1, [Pid|Nodes]).

wait(Sorted) -> 
	receive 
		{elem, E} -> wait(Sorted ++ [E]); %cambia questo append
		{last, E} -> Sorted ++ [E]
	end.

sleep_last(X) ->
	receive
		start -> ok
	end,
	receive	
	after X -> {master, master@fedora} ! {last, X}
	end.

sleep(X) ->
	receive
		start -> ok
	end,
	receive	
	after X -> {master, master@fedora} ! {elem, X}
	end.
