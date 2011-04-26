-- Roman_IO.adb
--
-- body for roman numeral IO
--
-- Matt Forbes April 2011

with Ada.Text_IO; use Ada.Text_IO;

package body Roman_IO is

   function From_Char(Value: Character) return Integer is
   begin
      case Value is
         when 'I' => return 1;
         when 'V' => return 5;
         when 'X' => return 10;
         when 'L' => return 50;
         when 'C' => return 100;
         when 'D' => return 500;
         when 'M' => return 1000;
         when others => raise Roman_Numeral_Error;
      end case;
   end From_Char;

   procedure Get_Numeral(Value: out String; Length : out Natural) is
      Char : Character;
   begin
      
      Length := 0;
      
      while not End_Of_Line loop
         
         Get(Char);
         exit when Char = ' ';
         
         -- validate character
         case Char is
            when 'I' | 'V' | 'X' | 'L' | 'C' | 'D' | 'M' => null;
            when others => raise Roman_Numeral_Error;
         end case;

         Length := Length + 1;
         Value(Length) := Char;
         
      end loop;

   end Get_Numeral;

               
   
   procedure Get (Value: out Roman_Numeral) is
      
      Num_Str : String(1..9); -- max digits
      Length : Integer;
      Last : Roman_Numeral := Roman_Numeral'First;
      Next : Roman_Numeral;
      
   begin
      
      Get_Numeral(Num_Str, Length);
      
      -- validate here

      Value := From_Char(Num_Str(Length));
      Last := Value;
      
      
      for Index in reverse 1..Length-1 loop
         Next := From_Char(Num_Str(Index));
         if Next >= Last then
            Value := Value + Next;
         else
            Value := Value - Next;
         end if;
         Last := Next;
      end loop;

      
   end Get;

   procedure Put (Value: in Roman_Numeral) is
      
   begin
      
      null;
      
   end Put;
   
end Roman_Io;
         
   
