with Roman_IO; use Roman_IO;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   Value : Roman_Numeral;
   
begin
   
   Put("Enter a roman numeral: ");
   Get(Value);

   Put("You entered: " & Integer'Image(Value));
   
   
end Main;
