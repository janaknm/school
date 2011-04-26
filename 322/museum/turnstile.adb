with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body Turnstile is
   
   Gen : Generator;
   
   procedure Get(Entrance : in Entrance_Type;
                 Direction : out Direction_Type) is
   begin

      Reset(Gen);
      delay Duration(0.8 + Random(Gen));
      
      if Random(Gen) >= 0.5 then
         Direction := Enter;
      else
         Direction := Leave;
      end if;
      
   end Get;
   
end Turnstile;
