--Matt Forbes
--Lab 4
--Oct 14
--body package of UnitConversion
--contains functions that pertain to the tagged record type Unit and it's derived types
--explanations in spec file

package body UnitConversion is
   procedure putFloat(Item : in Float) is
   begin
      f_io.put(Item => Item, fore => 0, aft => 2, exp => 0);
   end putFloat;

   procedure putUnit (Item : in Unit'Class) is
   begin
      putFloat(Item.Magnitude);
      t_io.put(" ");
      t_io.put(su.to_string(Item.inUnit));
      t_io.put(" is equal to ");
      putFloat(Item.NewMagnitude);
      t_io.put(" ");
      t_io.put(su.to_string(Item.outUnit));
      t_io.put_line(".");
   end putUnit;

   procedure convert (Item : in out Unit) is
   begin
       null;
   end convert;

   procedure convert (Item : in out EasyUnit) is
   begin
      Item.NewMagnitude := Item.Magnitude * Item.Rate;
   end convert;

   procedure convert (Item : in out Celcius) is
   begin
      Item.NewMagnitude := (Item.Magnitude * 1.8) + 32.0;
   end convert;

   procedure convert (Item : in out Fahrenheit) is
   begin
      Item.NewMagnitude := (Item.Magnitude - 32.0) / 1.8;
   end convert;

end UnitConversion;
