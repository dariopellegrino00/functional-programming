-module(client).
-export([start/0]).

start() -> 
    Pid = spawn(fun() -> loop() end),
    register(client, Pid),
    {server, server@Scavallo}!ciao.

loop() -> 
    loop().