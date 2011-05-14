package Resource_Alloc_V1 is
   
   protected type Manager(Initial_Value : Positive) is
      
      entry Take(Number_Req : Positive);
      
      procedure Replace(Number_Returned : Positive);
      
   private
      
      Inventory : Natural := Initial_Value;
      
   end Manager;
   
end Resource_Alloc_V1;
