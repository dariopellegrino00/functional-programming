-module(rring).
-export([create_local/1, propag_msg/1, start/0]).

create_local(N) when N < 1-> io:format("bruh...");
create_local(N) -> 
	case whereis(first) of
		undefined -> 
			Nodes = [ spawn(fun() -> worker(X, none) end) || X <- lists:seq(1, N)],
			register(first, lists:nth(1, Nodes)),
			[Node ! {new_next, lists:nth(X rem N + 1, Nodes), X rem N + 1} || {X, Node} <- lists:enumerate(Nodes)], 
			done;
		_ -> unregister(first), create_local(N)
	end.

propag_msg(Msg) -> first ! {start, Msg}, ok.

worker(X , Next) -> 
	receive 
		{msg, _} when X == 1-> ok;
		{P, Msg} when P == msg ; P == start-> 
			 io:format("worker ~p: i received ~p~n", [X, Msg]), 
			 Next ! {msg, Msg};
		{new_next, NewNext, Y} -> 
			io:format("worker ~p: my new next is ~p~n", [X, Y]),
			worker(X, NewNext);
		Any -> io:format("worker ~p: i received ~p~n", [X, Any])
	end,
	worker(X, Next).


start() -> 
	case whereis(master) of
		undefined -> 
			register(master, self()),
			Me = node(), 
			spawn(m@fedora, remote, start_worker, [Me]),
			receive 
				Any -> io:format("~p: ~p~n", [Me, Any])
			after 10000 -> ok
			end;
		_ -> unregister(master), start()
	end.






