package body Resource_Alloc_V1 is
   
   protected body Manager is
      
      entry Take (Number_Req : Positive) 
      when Inventory >= Number_Req is
      begin
         Inventory := Inventory - Number_Req;
      end Take;
      
      procedure Replace(Number_Returned : Positive) is
      begin
         Inventory := Inventory + Number_Returned;
      end Replace;
      
   end Manager;
   
end Resource_Alloc_V1;
