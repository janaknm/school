-module(area_server_final).
-export([start/0, area/2])

start() ->
    spawn(fun loop/0).

area(Pid, What) ->
    rpc(Pid, What).

rpc(Pid, Request) ->
    Pid ! { self(), Request },
    receive
        {Pid, Response} ->
            Response
    end.

loop() ->
    receive
        {From, {rectangle, W, H}} ->
            From ! {self(), {ok, W*H}},
            loop();
        {From, {circle, R}} ->
            From ! {self(), {ok, R*R*3.14159}},
            loop();
        {From, Other} ->
            From ! {self(), {error, "bad stuff"}},
            loop()
    end.