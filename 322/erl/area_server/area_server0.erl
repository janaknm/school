-module(area_server0).
-export([loop/0]).

loop() ->
    receive 
        {rectangle, W, H} ->
            io:format("Area of rectangle is ~p~n", [W*H]),
            loop();
        {circle, R} ->
            io:format("Area of circle is ~p~n", [R*R*3.14159]),
            loop();
        Other ->
            io:format("Cannot calculate area of ~p~n", [Other]),
            loop()
    end.
            
