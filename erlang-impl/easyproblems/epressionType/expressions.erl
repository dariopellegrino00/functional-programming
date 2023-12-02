-module(expressions).

-type exp() :: {plus, exp(), exp()}
                | {minus, exp(), exp()}
                | {uminus, exp()}
                | {times, exp(), exp()}
                | {num, integer()}.






