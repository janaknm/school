-module(area_server1).
-export([loop/0]).

% now sending responses back to client

loop() ->
    receive
        {From, {rectangle, W, H}} ->
            From ! {ok, W*H},
            loop();
        {From, {circle, R}} ->
            From ! {ok, R*R*3.14159},
            loop();
        {From, Other} ->
            From ! {error, "bad stuff"},
            loop()
    end.
