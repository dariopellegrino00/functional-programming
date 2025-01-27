-module(remote).
-export([start_worker/1]).

start_worker(A) -> 
	group_leader(whereis(user), self()),
	{master, A} ! {msg, "crated"}, ded.
