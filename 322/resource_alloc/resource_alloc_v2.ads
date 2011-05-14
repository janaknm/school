package Resource_Alloc_V2 is
   
   protected type Manager(Initial_Value : Positive) is
      
      entry Take(Number_Req : in Positive);
      procedure return(Number_Returned : in Positive);
      entry Wait(Number_Req : in Positive);

   private
      
      Inventory : Natural := Initial_Value;
      Tasks_Waiting : Natural := 0;
      Resources_Released : Boolean := True;
      
end Resource_Alloc_V2;
