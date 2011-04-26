with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

procedure TaskDemo is
   
   Gen: Generator;
   
   task type Runner(Id: Integer);
   
   type Runner_Ptr is access Runner;
   
   task body Runner is
   begin
      for I in 1..10 loop
         Put_Line(Integer'Image(I) & " " & Argument(Id) );
         delay Duration(0.2 + Random(Gen));
      end loop;
      
      Put_Line("DONE! " & Argument(Id));
   end Runner;
   
   Contestant: Runner_Ptr;
   
begin
   
   Reset(Gen);
   
   for Arg in 1..Argument_Count loop
      Contestant := new Runner(Arg);
   end loop;
   
end TaskDemo;

        
