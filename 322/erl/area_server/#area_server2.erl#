-module(area_server2).
-export([loop/0]).


% now tagging responses with its own PID

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
