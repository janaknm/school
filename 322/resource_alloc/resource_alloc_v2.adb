package body Resource_Alloc_V2 is
   
   protected body Manager is
      
      entry Take (Number_Req : in Positive)
      when Inventory > 0 is
      begin
         if Inventory >= Number_Req then
            Inventory := Inventory - Number_Req;
         else
            requeue Wait(Number_Req);
         end if;
      end Take;
      
      procedure return (Number_Returned : in Positive) is
      begin
         Inventory := Inventory + Number_Returned;
         Tasks_Waiting := Wait'Count;
         
         if Tasks_Waiting > 0 then
            Resources_Released := True;
         end if;
      end return;



      
   end Manager;
   
end Resource_Alloc_V2;
