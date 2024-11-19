-module(client).
-export([send/1]). 

send(Str) -> 
   {master, s@fedora} ! {self(), long_reverse, Str},
   receive 
      Any -> io:format("CLIENT: ~p~n", [Any])
      after 1000 -> "got nothing"
   end.

