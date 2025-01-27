-module(hypercube). 
-export([create/0, gray/1, hamiltonian/2]).

create() -> 
	case {whereis(first), whereis(master)} of
		{undefined, undefined} -> 
			register(master, spawn(fun() -> master_loop() end)),
			Names = gray(4),
			Nodes = [{Name, spawn(fun() -> create_node(Name) end)} || Name <- Names],
			{_, FirstPid} = lists:nth(1, Nodes),
			register(first, FirstPid),
			[Pid ! {
			   adjacents, 
			   lists:foldl(
				 fun({K, V}, Acc) -> maps:put(K, V, Acc) end,  
				 #{}, 
				 lists:filter(fun({N, _}) -> hamming(Name, N) == 1 end, Nodes))
			  } || {Name, Pid} <- Nodes], 
			done;
		{_, _} -> % TODO use exception
			unregister(first), 
			unregister(master),
			create()
	end.

master_loop() -> 
	receive 
		{hamilt, Msg, Path} -> first ! {hamilt, Msg, Path};
		R={msg, _} -> io:format("~p~n", [R]);
		Any -> io:format("Master: received ~p~n", [Any])
	end,
	master_loop().


hamiltonian(Msg, Path) -> master ! {hamilt, Msg, Path}, ok. % ipotesi che sia sempre first

gray(0) -> "";
gray(1) -> ["0", "1"];
gray(N) -> G = gray(N-1), ["0" ++ X || X <- G] ++ lists:reverse(["1" ++ Y || Y <- G]).

hamming([C1|S1], [C2|S2]) -> %must be same size
	abs(C1 - C2) + hamming(S1, S2);
hamming([], []) -> 0;
hamming(_, _) -> error.

create_node(Name) -> 
	io:format("The process labeled ~p just started~n", [Name]),
	node_loop(Name, none).

node_loop(Name, Adjs) -> 
	receive 	
		{hamilt, Msg, [Name|Ns]} -> 
			self() ! {Msg, Ns};
		Hamil={hamilt, Msg, [N|Ns]} -> 
			try 
				maps:get(N, Adjs) ! {Msg, Ns}
			catch
				_:_ -> % should be the hamming closes to N TODO
					lists:nth(1,(maps:values(Adjs))) ! Hamil
			end;
		{Msg, Path=[N|Ns]} -> 
			case (lists:any(fun(X) -> X == Name end, Path)) of 
				true -> io:format("this is not an hamiltonian path for hypercube graph~n"); 
				_ ->
				   	try 
						maps:get(N, Adjs) ! {{src, Name, msg, Msg}, Ns}
					catch 
						_:_ -> io:format("this is not a path for the hypercube graph~n")
					end
			end;
		{Msg, []} -> 
			master ! {msg, {src, Name, msg, Msg}};
			%io:format("~p~n", [Msg]);
		{adjacents, NewAdjs} -> 
			%io:format("~p: My new Adjacent nodes; ~n~p~n", [Name, NewAdjs]),
			node_loop(Name, NewAdjs);
		Any -> io:format("~p: received ~p~n", [Name, Any])
	end,
	node_loop(Name, Adjs).
