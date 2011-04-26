with Turnstile;     use Turnstile;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_Io;   use Ada.Text_IO;

procedure Museum_V2 is

   Maximum : constant := 100;  -- museum capacity

   -- new protected type for mutual exclusion
   protected Population is
      procedure Increment;
      procedure Decrement;
      function Current return Natural;
   private
      Count: Natural := 0;
   end Population;
   
   protected body Population is

      procedure Increment is
      begin
         Count := Count + 1;
      end Increment;
      
      procedure Decrement is
      begin
         Count := Count - 1;
      end Decrement;

      function Current return Natural is
      begin
         return Count;
      end Current;
      
   end Population;
   
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
               Population.Increment;
            when Leave => 
               Population.Decrement;
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
   Count : Natural;
   
begin -- Museum_V1
   loop

      Count := Population.current;
      
      
      Put_Line("Current number of visitors is " &
                 integer'image(count));
      
      -- check for change in ticket selling status
      if not Museum_full and count >= Maximum then
         Put_Line("The museum is full.  Suspend ticket sales");
         Museum_Full := true;
      elsif Museum_full and count < maximum then
         Put_Line("There is room for more visitors.  Resume ticket sales");
         Museum_Full := false;
      end if;
      
      delay 1.0;		-- update status every second	
   end loop;

end Museum_V2;
