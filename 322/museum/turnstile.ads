package Turnstile is

   type Direction_Type is (Enter, Leave);
   type Entrance_Type is (North, South, East, West);
   
   procedure Get(Entrance : in Entrance_Type;
                 Direction : out Direction_Type);
   
end Turnstile;
