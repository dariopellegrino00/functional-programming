-module(test).
-export([test_parsing/1, test_evaluation/1]).

read_lines(FileName) -> 
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
        after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of 
        eof -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

test_parsing(FileName) -> 
    Lines = string:tokens((read_lines(FileName)), "\n"),
    lists:map(fun(X) -> expr:parse(X) end, Lines).

test_evaluation(FileName) -> 
    ExprsList = test_parsing(FileName),
    lists:map(fun(X) -> expr:evaluate(X) end, ExprsList).

