-module(area_server_m).
-export([start/0, area/2]).

% goal: start a server, and get areas calculated in parallel with no
% extra work from a client

start() ->
    spawn(fun loop/0).

area(Server_Id, Request) ->
    rpc(Server_Id, Request).

rpc(Server_Id, Request) ->
    Server_Id ! {self(), Request },
    receive
        {Server_Id, Response} ->
            Response
    end.

loop() ->
    receive
        { Client_Id, Request } ->
            Client_Id ! 
                { self(), 
                  case Request of
                      { rectangle, W, H } ->
                          W * H ;
                      { circle, R } ->
                          3.14159 * R * R;
                      { triangle, B, H } ->
                          0.5 * B * H 
                  end },
            loop()
    end.
                    
            
