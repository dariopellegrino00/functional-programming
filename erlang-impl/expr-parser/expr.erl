-module(expr).
-export([parse/1, evaluate/1]).

parse(E) -> 
	{_, Res} = parse_left(lists:filter(fun(X) -> X =/= 32 end, E)),
	Res.

parse_left("if" ++ E) -> 
	{RestCond, Condition} = parse_left(E),
	case RestCond of 
		"then" ++ ThenExpr -> 
			{RestElse, Then} = parse_left(ThenExpr),
			case RestElse of 
				"else" ++ ElseExpr -> 
					%if there is something after the else should maube give error?
					{Rest, Else} = parse_left(ElseExpr),
					{Rest, {if_ , Condition, Then, Else}}
			end
	end;

parse_left([N|Expr]) when (N >= 48) and (N =< 57) -> 
	parse_right(Expr, {num, N-48}); 

parse_left("(" ++ Expr) -> 
	{[_|Rest], Left} = parse_left(Expr), 
	parse_right(Rest, Left);

parse_left("~(" ++ Expr) -> 
	{[_|Rest], Left} = parse_left(Expr), 
	parse_right(Rest, {uminus, Left}). 

parse_right([Op, N | Expr], Left) when (N >= 48) and (N =< 57) -> % check for op or lit
	{Expr, parse_op(Op, Left, {num, N-48})};

parse_right([Op, 40 | Expr], Left) -> 
	{Rest, Right} = parse_left(Expr), 
	{Rest, parse_op(Op, Left, Right)};

% if there is a ) pop it
parse_right([41|E], Left) -> {E ,Left};

parse_right(E, Left) -> {E ,Left}.



parse_op(Op, Left, Right) -> 
	case Op of 
		$+ -> {plus, Left, Right};
		$- -> {minus , Left, Right};
		$* -> {times , Left, Right}
	end.

evaluate(Expr) -> 
	case Expr of 
		{plus, Left, Right} -> evaluate(Left) + evaluate(Right);
		{minus, Left, Right} -> evaluate(Left) - evaluate(Right);
		{times, Left, Right} -> evaluate(Left) * evaluate(Right);
		{uminus, Term} -> -(evaluate(Term));
		{num, N} -> N;
		{if_, Cond, Then, Else} -> 
			case evaluate(Cond) of
				0 -> evaluate(Then); 
				_ -> evaluate(Else)
			end
	end.


	