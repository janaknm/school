with Turnstile;     use Turnstile;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_Io;   use Ada.Text_IO;

procedure Museum_V1 is

   Maximum : constant := 100;  -- museum capacity
   Population : natural := 0;	-- current number of visitors
   
   -- turnstile monitor tasks
   task type Entrance_Monitor( My_Entrance : Entrance_type);
   
   task body Entrance_Monitor is
      Direction : Turnstile.Direction_type;
   begin
      loop
         -- wait until someone passes through my turnstile
         Turnstile.Get(My_Entrance, Direction);
         
         -- update the visitor count
         case Direction is
            when Enter => 
               Population := Population + 1;
            when Leave => 
               Population := Population - 1;
         end case;		
      end loop;
      
   exception
      when Except : others =>
         Put_Line ( Standard_Error, Entrance_type'image(My_Entrance) &
                      " turnstile task terminated with " &
                      Exception_Name(Except) &
                      " because " &
                      Exception_message(Except));
   end Entrance_Monitor;

   -- one task for each entrance to the museum
   North_Door : Entrance_Monitor(North);
   South_Door : Entrance_Monitor(South);
   East_Door  : Entrance_Monitor(East);
   West_Door  : Entrance_Monitor(West);
   
   Museum_Full : boolean := false;
   
begin -- Museum_V1
   loop
      Put_Line("Current number of visitors is " &
                 integer'image(Population));
      
      -- check for change in ticket selling status
      if not Museum_full and Population >= Maximum then
         Put_Line("The museum is full.  Suspend ticket sales");
         Museum_Full := true;
      elsif Museum_full and Population < maximum then
         Put_Line("There is room for more visitors.  Resume ticket sales");
         Museum_Full := false;
      end if;
      
      delay 1.0;		-- update status every second	
   end loop;

end Museum_V1;
