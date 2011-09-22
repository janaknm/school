-module(pmap).
-export([pmap/2]).
-import(lists, [map/2]).

pmap(F,L) ->
    S = self(),
    Ref = erlang:make_ref(), % unique reference
    Pids = map(fun(I) ->
                       spawn(fun() ->
                                     do_f(S, Ref, F, I)
                             end)
               end, L),
    gather(Pids, Ref).

do_f(Parent, Ref, F, I) ->
% if F fails, result will be an error rather than killing program
    Parent ! { self(), Ref, catch F(I) }. 

gather([Pid | T], Ref) ->
    receive
        { Pid, Ref, Ret } ->
            [Ret | gather(T, Ref)];
        
gather([], _) -> [].

