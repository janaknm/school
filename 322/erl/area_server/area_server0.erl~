-module(area_server0)
-export([loop/0])

loop() ->
    receive {rectangle, W, H} ->
            io:format("Area of rectangle is ~p~n", [W*H]),
            loop();
            
