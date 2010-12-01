--Matt Forbes
--Assignment 1`
--Get weekday from date

with ada.Text_IO;
with ada.integer_text_io;

procedure Main is
   --types
   type day is (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday); --enumerated type.
   --end types

   --subtype declarations
   subtype int_year is Integer range 1801..2199; --all subtypes of int.
   subtype int_month is Integer range 1..12;
   subtype int_date is Integer range 1..31;

   package T_IO renames ada.Text_IO;
   package I_IO renames ada.Integer_Text_IO;
   package Day_IO is New T_IO.Enumeration_IO (day); --custom IO package to deal with outputing the day of the week.
   --end subtype declarations

   --variable declarations
   year : int_year;
   month : int_month;
   date : int_date;
   c, l, c1, leap, adj, m, d : Integer; --used in calculations.
   valid : Boolean; --Used for validation.
   --end declarations


begin

   --Data Gathering.
   T_IO.Put(Item => "Enter the year (1801-2199): ");
   I_IO.Get(Item => year);
   T_IO.Put(Item => "Enter the month number (1-12): ");
   I_IO.Get(Item => month);
   T_IO.Put(Item => "Enter the date (1-31): ");
   I_IO.Get(Item => date);
   --end Data Gathering

   --Validation.
   valid := true;
   if month <= 7 then --if first 7 months
      if month = 2 then --if febuarary check if it's a leap year
         if year mod 4 = 0 or year mod 100 = 0 or year mod 400 = 0 then --yes it's a leap year
            if date > 29 then --so 29 is the highest date
            valid := false;
            end if;
         else
            if date > 28 then --not a leap year so highest date is 28th
               valid := false;
            end if;
         end if;
      elsif month mod 2 = 0 then --if it's an even month in the first half of year then the month has 30 days
         if date > 30 then
           valid := false;
         end if;
      end if;
   else --if the month is in the last 5 months
      if month mod 2 = 1 then --if odd month in the second half of year
         if date > 30 then
            valid := false;
         end if;
      end if;
   end if;
   --end Validation

   if valid = true then --if we have a valid date, calculate week day
      c := year / 100;
      l := year / 4 - (3 * c + 3) / 4;
      c1 := (year - 1) / 100;
      leap := l - (year - 1) / 4 + (3 * c1 + 3) / 4;
      adj := 1 - (month + 9) / 12;
      m := (13 * month + 3 + 17 * adj) / 5;
      m := m - (leap + 1) * adj;
      d := (year + l + m + date + 1) rem 7;
      
      T_IO.put("The day of the week for ");
      I_IO.put(Item => date, width => 1);
      T_IO.put("/");
      I_IO.put(Item => month, width => 1);
      T_IO.put("/");
      I_IO.put(Item => year, width => 1);
      T_IO.put(" is ");
      Day_IO.put(Item => day'val(d), Set => T_IO.Lower_Case);
      T_IO.put(".");
   else --invalid date, try again?
      T_IO.Put(Item => "Invalid Date.");
   end if;

   
end Main;
