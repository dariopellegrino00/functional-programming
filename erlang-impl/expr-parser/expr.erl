-module(expr).
-export([parse/1, evaluate/1]).

parse("(" ++ Expr) -> 
	{_, Res} = parse_left(Expr), 
	Res;
	
parse("~(" ++ Expr) -> 
	{_, Res} = parse_left(Expr), 
	{uminus, Res};

parse([N|_]) when (N >= 48) and (N =< 57) -> {num, N - 48}. 

parse_left([N|Expr]) when (N >= 48) and (N =< 57) -> 
	parse_right(Expr, {num, N-48}); % TODO in int not string!!

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
	{Rest, parse_op(Op, Left, Right)}.

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
		{num, N} -> N
	end.


	