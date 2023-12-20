-module(atm).
-export([start/0, balance/0, withdraw/1, deposit/1, stop/0]).

start() -> 
    {ok, HostName} = inet:gethostname(),
    DispNode = list_to_atom("disp@" ++ HostName),
    AtmPid = spawn(fun() -> loop(0, DispNode) end),
    global:register_name(atm, AtmPid).

balance() -> global:whereis_name(atm)!balance.
withdraw(Amount) -> global:whereis_name(atm)!{withdraw, Amount}.
deposit(Amount) -> global:whereis_name(atm)!{deposit, Amount}.

stop() -> global:unregister_name(atm).

loop(N, DispNode) -> 
    receive 
        balance -> 
            rpc:call(DispNode, dispatcher, msg ,[{balance}]);
        {withdraw, Amount} -> 
            rpc:call(DispNode, dispatcher, msg ,[{withdraw, Amount}]);
        {deposit, Amount} -> 
            rpc:call(DispNode, dispatcher, msg ,[{deposit, Amount}])
    end,
    loop(N, a).