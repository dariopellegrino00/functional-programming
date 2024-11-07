-module(echo).
-export([start/0, print/1, stop/0]).

start() -> 
    case whereis(client) of 
        undefined -> 
            Client = spawn(fun() -> create_client() end),
            register(client, Client),
            ok;
        _ -> 
            unregister(client),
            start()
    end.
        
print(Message) ->  
    whereis(client)!{print, Message}, 
    ok.

stop() -> 
    whereis(client)!stop,
    ok. 

create_client() -> 
    case whereis(server) of 
        undefined -> 
            Server = spawn_link(fun() -> server_loop() end),
            register(server, Server),
            client_loop();
        _ -> 
            unregister(server),
            create_client()
    end.

client_loop() -> 
    receive
        {print, Message} -> 
            whereis(server)!{print, Message},
            client_loop();
        stop -> exit(kill)
    end.

server_loop() -> 
    receive
        {print, Message} -> 
            io:format("Server: ~p\n", [Message]),
            server_loop()
    end.