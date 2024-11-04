-module(centralized_ring).
-export([start/3]).

start(_, N, _) when N =< 0 -> {error, "ring must have at least 1 process"};
start(M, _, _) when M =< 0 -> {error, "ring must pass at least 1 message"};

start(M, N, Message) -> 
    create_ring(M, N, Message, []).

create_ring(M, 0, Msg, Ring) -> 
  master_loop(M, Msg, Ring, 1);

create_ring(M, N, Msg, Ring) -> 
  io:format("created worker ~p\n", [N]),
  Pid_i = spawn(fun() -> ring_loop(N) end),
  create_ring(M, N-1, Msg, [Pid_i|Ring]).

ring_loop(N) -> 
  receive
    {msg, Msg, InPid} -> 
      InPid!{self(), ok},
      case Msg of 
        stop -> 
          io:format("Worker ~p: im stopping \n", [N]),
          exit(normal);
        _ -> 
          io:format("Worker ~p: i received this message ~p \n", [N, Msg]),
          ring_loop(N)
      end;
    Any -> 
      io:format("Worker ~p: i received unknown ~p \n", [N, Any]),
      ring_loop(N)
  end.

master_loop(0, _,  Ring, _) ->
  master_send({msg, stop, self()}, Ring),
  io:format("Master: all messages sent\n");

master_loop(M, Msg, Ring, C) -> 
  io:format("Master: start sending \n"),
  master_send({msg, Msg ++ " " ++ integer_to_list(C), self()}, Ring),
  master_loop(M-1, Msg, Ring, C+1).

master_send(Msg, [Pid_last]) -> 
  send_message(Pid_last, Msg),
  io:format("Master: finished sending \n");

master_send(Msg, [Pid_i|Rest]) -> 
  send_message(Pid_i, Msg),
  master_send(Msg, Rest).
  
send_message(Pid, Msg) -> 
  Pid!Msg,
  receive
    _ ->  ok
  end.