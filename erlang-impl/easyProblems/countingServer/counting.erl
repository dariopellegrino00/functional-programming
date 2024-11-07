-module(counting).
-export([start/0, request/1, tot/0, stop/0]).

start() -> 
    case whereis(server) of 
        undefined ->
            Server = spawn(fun() -> counter_server(#{}, 0) end),
            register(server, Server);
        _ -> 
            unregister(server),
            start()
    end,
    ok.
   
request(Service) -> 
    Server = whereis(server),
    case Server of 
        undefined -> io:format("server unavailable try counting:start()~n"), ok;
        _ -> 
            Server!{self(), request, Service},
            receive
                {response, Content} -> 
                    io:format("response: ~p~n", [Content])
                after 1000 -> ok
            end
    end.

tot() -> request(tot).

stop() -> request(stop).
    
update_service(Service, Services) -> 
    maps:update_with(
        Service,
        fun(V) -> V + 1 end, 
        1,
        Services
    ). 

counter_server(Services, N) -> 
    receive
        {From, request, Service} -> 
            case Service of 
                tot ->  From!{response, {maps:to_list(Services), N}};
                stop -> exit(normal);  % just to create a close, not the purpose of this exercise to make a good close
                _ ->  From!{response, Service}
            end, 
            counter_server(update_service(Service, Services), N+1);
        Any ->
            io:format("Server: unknown format ~p ", [Any])
    end.