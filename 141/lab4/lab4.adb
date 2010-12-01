with ada.text_io;
with ada.Float_Text_IO;
with ada.text_io.unbounded_io;
with ada.Strings.Unbounded;
with UnitConversion;
    use UnitConversion;

procedure Lab4 is

   package t_io renames ada.Text_IO;
   package f_io renames ada.Float_Text_IO;
   package u_io renames ada.text_io.unbounded_io;
   package su renames ada.Strings.Unbounded;
   package uc renames UnitConversion;


   --makeUnit::
   --takes a float and character and turns it into a Unit we can convert and output
   --really the only function we need for the client part
   function makeUnit (char : in Character; magnitude : in Float) return  uc.UnitPtr is
      retVal : uc.UnitPtr; --uc.UnitPtr is a class wide type (pointer to base class)
   begin
      case char is --switch type of abbreviation
	when 'm' => 
	    retVal := new uc.easyUnit'
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("meters"),
		 outUnit => su.to_unbounded_string("yards"),
		 rate => 1.09);
        when 'y' => 
	    retVal := new uc.EasyUnit' 
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("yards"),
		 outUnit => su.to_unbounded_string("meters"),
		 rate => 0.914);
        when 'k' => 
	    retVal := new uc.EasyUnit'
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("kilograms"),
		 outUnit => su.to_unbounded_string("pounds"),
		 rate => 2.2);
	when 'p' => 
	    retVal := new uc.EasyUnit'
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("pounds"),
		 outUnit => su.to_unbounded_string("kilograms"),
		 rate => 0.454);
	when 'c' => 
	    retVal := new uc.Celcius'
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("degrees celcius"),
		 outUnit => su.to_unbounded_string("degrees fahrenheit"));
	when 'f' => 
	    retVal := new uc.Fahrenheit'
		(magnitude => magnitude,
		 newMagnitude => 0.0,
	         inUnit => su.to_unbounded_string("degrees fahrenheit"),
		 outUnit => su.to_unbounded_string("degrees celcius"));
	when others => retVal := null; --if it's not an abbreviation then return null 

      end case;
      return retVal; --return pointer to a derived type of Unit
   end makeUnit;

   --Global Variables
   magnitude : Float; --input magnitude
   char : Character; --input character
   currentConversion : uc.UnitPtr; --current unit we are converting (it is a class wide type)
   count : Integer := 0; --how many successful conversions we've done
   command : su.unbounded_string; --if input is not in conversion format, put the input into this string to check for another command (quit)
   quitCommand : constant string := "quit"; --only command we'll do something with

begin

    loop
	begin
	    t_io.new_line;
	    t_io.put_line("Enter a value followed by a unit abbreviation. Type 'quit' to quit.");
	    t_io.put("  > ");

	    --check first part of input for float and store it in magnitude
	    f_io.get(magnitude);

	    --we'll skip through all the blanks until we hit a character
	    char := ' '; --reset char to space
	    while char = ' ' loop --until we get a non-space character consume blank space
		t_io.get(char);
	    end loop;
	    
	    --currentConversion is a class wide type and depending on the char we pass makeUnit, we will get a different derived type
	    currentConversion :=  makeUnit(char => char, magnitude => magnitude);

	    --if makeUnit returned a valid derived type continue with conversion
	    if currentConversion /= null then
		--base type unit has a dispatching procedure called convert that is overriden by all of it's derived types
		--so when we call convert on a pointer to a class wide type(uc.UnitPtr) it will dispatch the right procedure
		uc.convert(currentConversion.all);

		--putUnit simply outputs any type of Unit because they all share the necessary variables
		uc.putUnit(currentConversion.all);

		--keep track of successful conversions
		count := count + 1;
	    else
		--the character we passed makeUnit was not valid so we can't convert it
		t_io.skip_line;
		t_io.put_line("Incorrect input, try again.");
	    end if;
	exception
	    when t_io.data_error =>
		--when the input doesn't match our format then check the line for a command (namely quit)
		--store the whole line in string command
		u_io.get_line(command);

		--if command is equal to quitcommand then quit
		if su.to_string(command) = quitCommand then
		    exit;
		else
		--if it wasn't quit just output error and continue
		    t_io.skip_line;
		    t_io.put_line("Incorrect input, try again.");
		end if;
	end;
    end loop;

    --after we've converted all we want then output how many conversions were successful.
    t_io.new_line;
    t_io.put(Integer'Image(count));
    t_io.put(" successful conversion");
    if count > 1 then t_io.put("s.");
    else t_io.put(".");
    end if;
end Lab4;
