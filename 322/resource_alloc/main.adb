with Resource_Alloc_V1;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

procedure Main is

   protected Random_Manager is
      function Get return Float;
   private
      Initialized : Boolean := False;
      Gen : Generator;
   end Random_Manager;
   
   protected body Random_Manager is
      function Get return Float is
      begin
         if not Initialized then
            Reset(Gen);
         end if;
         return Random(Gen);
      end Get;
   end Random_Manager;
   
   Resources : Resource_Alloc_V1.Manager(100);

   task type Client(Reqd : Positive);
   
   task body Client is
   begin
      for I in 1..20 loop
         
         Resources.Take(Reqd);
         
         delay Duration( Random_Manager.Get);

         Resources.Replace(Reqd);
         
      end loop;
   end Client;
   
   type Client_Ptr is access Client;
   type Client_Arr is array(Positive range <>) of Client_Ptr;

   Clients : Client_Arr(1..10);
   
begin
   
   for I in 1..10 loop
      
      Clients(I) := new Client(I);
      
   end loop;
   
end Main;
