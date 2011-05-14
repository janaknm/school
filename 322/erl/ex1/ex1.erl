-module(ex1).
-export([factorial/1, map/2, sqrt/1]).
% reference to a function in a module: module_name:fun(a, b)

% alternate clauses of a function definition are separated by semicolons
factorial(1) -> 1;
factorial(N) -> N * factorial(N-1).

% built-in function lists:map(F, L)  takes function F and list L
map(_, []) -> [];
map(F, [H|T]) -> [F(H) | map(F, T)].

% square root wrapper with exception handling for negative square roots
sqrt(x) when x < 0 -> erlang:error({squareRootNeg, x});
sqrt(x) -> math:sqrt(x).
    
