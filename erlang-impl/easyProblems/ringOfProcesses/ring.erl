

-module(ring).
-export([start/3, create/3]).

start(M, N, Msg) -> 
  register(first, spawn(?MODULE, create, [N, 1, self()])),
  io:format(" [first] address is ~p~n", [whereis(first)]),
  receive 
    ready -> ok
    after 5000 -> exit(timeout)
  end,
  send_message(M, 1, Msg),
  first ! stop,
  ok.

send_message(M, M, Msg) -> first!{Msg, M, 1};
send_message(M, N, Msg) -> first!{Msg, N, 1}, send_message(M, N+1, Msg).

create(1, Who, Starter) ->
  Starter ! ready,
  io:format(" created [~p] as ~p connected to ~p~n", [self(), Who, first]),
  last_loop(first, Who);
create(N, Who, Starter) ->
  Next = spawn(?MODULE, create, [N-1, Who+1, Starter]),
  io:format(" created [~p] as ~p connected to ~p~n", [self(), Who, Next]),
  loop(Next, Who).

loop(Next, Who) -> 
  receive
    {Msg, N, P} ->  io:format("[~p]: message ~p acknowledged, ~p time\n", [Who, Msg, N]),
                    Next!{Msg, N, P},
                    io:format("[~p]: message ~p sent to ~p, ~p time\n", [Who, Msg, Next, N]),
                    loop(Next, Who);
    stop -> io:format("[~p]: stop\n", [Who]),
            Next ! stop;
    other -> io:format("[~p]: i received something i cant explain\n", Who)
  end.

last_loop(Next, Who) -> 
  receive
    {Msg, N, P} ->  io:format("[~p]: message ~p acknowledged, ~p time\n", [Who, Msg, N]),
                      Next!{Msg, N, P},
                      io:format("[~p]: message ~p sent to ~p, ~p time\n", [Who, Msg, Next, N]),
                      last_loop(Next, Who);
    stop -> io:format("[~p]: stop \n", [Who]),
            exit(normal),
            unregister(first);
    other -> io:format("[~p]: i received something i cant explain\n", Who)
  end.