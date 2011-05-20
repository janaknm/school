with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Vat_Stuff; use Vat_Stuff;

procedure As2 is 
   
   ----
   -- basic type definitions
   
   -- specifies how badly a vat needs the house, 100 being most crucial
   subtype Priority_Reading is Float range 0.0 .. 100.0;
   
   subtype Vat_Range is Natural range 1..Integer'Value(Argument(1));
   type Vat_Array in array(Vat_Range) of Vat;
   
   ----
   -- task specifications
   task type Vat_Handler is
      entry Assign_Vat(A_Vat : in Vat);
   end Vat_Handler;
   
   task type Hose_Handler(Vats : Vat_Array);
   
   type Handler_Array is array(Vat_Range) of Vat_Handler;
   
   
   -- helpers
   function Get_Priority(A_Vat : in Vat) return Priority_Reading;
   
   
   -- create the vat handlers
   Handlers : Handler_Array; 
   
   -- create the vats
   Vats : Vat_Array;

   -- add the hose handler
   Hose_Control : Hose_Handler(Vats);
   
begin

   for I in Vat_Range loop
      Handlers(I).Assign_Vat(Vats(I));
   end loop;
   
end As2;
