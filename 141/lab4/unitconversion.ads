--Matt Forbes
--Lab 4
--Unit Conversion spec file
--descripes type Unit and it's derived types

with ada.text_io;
with ada.float_text_io;
with ada.strings.unbounded;

package UnitConversion is

   package t_io renames ada.text_io;
   package f_io renames ada.float_text_io;
   package su renames ada.Strings.unbounded;

   --Unit is our base class that all types of units will derive from
   type Unit is tagged
      record
	 --every unit has to have a magnitude, unconverted unit name, converted unit name, and a place holder for the converted value
         Magnitude : Float;
         InUnit : su.unbounded_string;
         OutUnit : su.unbounded_string;
         NewMagnitude : Float;
      end record;

   --Unit has a convert function, but it is just a dispatcher it won't every be called because Unit by itself is too abstract
   procedure convert (Item : in out Unit);

   --Easy unit is a terminal derived type of Unit and is easy to convert because newMagnitude is just equal to magnitude * rate
   type EasyUnit is new Unit with
      record
         Rate : Float;
      end record;

   --EasyUnit overrides the Unit base class' convert procedure to use it's own rate
   procedure convert (Item : in out EasyUnit);

   --Celcius has a unique conversion equation so it needs its own derived type and overriden convert procedure
   type Celcius is new Unit with null record;
   procedure convert (Item : in out Celcius);

   --same with Fahrenheit
   type Fahrenheit is new Unit with null record;
   procedure convert (Item : in out Fahrenheit);

   --UnitPtr is the class-wide type for all dervied types of Unit
   type UnitPtr is access all Unit'class;

   --putFloat is an easy way to output floats without having to use all the parameters
   procedure putFloat (Item : in Float);

   --putUnit will take any derived type of Unit and output it
   procedure putUnit (Item : in Unit'Class);


end UnitConversion;
