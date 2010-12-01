--Matt Forbes
--10/09/2009
--Lab 3
--Input magniture + measurement and convert it to relevant counterpart
--includes robust input that checks for a quit command to exit program

with ada.text_io;
with ada.text_io.unbounded_io;
with ada.float_text_io;
with ada.strings.unbounded;
with ada.characters.handling;

procedure lab3 is

    type abbreviations is array(1..6) of Character;
    type quickConversions is array(1..4) of Float;
    type abbreviationsArray is array(abbreviations'range) of ada.strings.unbounded.unbounded_string;

    subtype alphabet is Character range 'A'..'z';

    package t_io renames ada.text_io;
    package f_io renames ada.float_text_io;
    package u_io renames ada.text_io.unbounded_io;
    package su renames ada.strings.unbounded;
    package c_handling renames ada.characters.handling;

    abrv : constant abbreviations :=
	(1 => 'p',
	 2 => 'y',
	 3 => 'k',
	 4 => 'm',
	 5 => 'f',
	 6 => 'c'
	);

    inUnits : constant abbreviationsArray :=
	(1 => su.to_unbounded_string("pounds"),
	 2 => su.to_unbounded_string("yards"),
	 3 => su.to_unbounded_string("kilograms"),
	 4 => su.to_unbounded_string("meters"),
	 5 => su.to_unbounded_string("degrees fahrenheit"),
	 6 => su.to_unbounded_string("degrees celcius")
	);

    outUnits : constant abbreviationsArray :=
	(1 => su.to_unbounded_string("kilograms"),
	 2 => su.to_unbounded_string("meters"),
	 3 => su.to_unbounded_string("pounds"),
	 4 => su.to_unbounded_string("yards"),
	 5 => su.to_unbounded_string("degrees celcius"),
	 6 => su.to_unbounded_string("degrees fahrenheit")
	);

    quick : constant quickConversions := --hold constant conversion rates
	(1 => 0.454, --pounds to kilograms
	 2 => 0.914, --yards to meters
	 3 => 2.20, --kilograms to pounds
	 4 => 1.09 --meters to yards
	);

    function searchAbrv (needle : in Character) return Integer is
    begin
	for i in abrv'range loop
	    if abrv(i) = needle then return i;
	    end if;
	end loop;
	return -1;
    end searchAbrv;

    procedure convertUnits ( magnitude : in Float; unit : in Character ) is
	pos : Integer;
	calculatedMagnitude : Float;
    begin
	pos := searchAbrv(needle => unit);
	if pos /= -1 then
	    if pos in quick'range then
		calculatedMagnitude := magnitude * quick(pos);
	    else
		if unit = 'f' then
		    calculatedMagnitude := (magnitude - 32.0) / 1.8;
		    if calculatedMagnitude < -273.0 then
			calculatedMagnitude := 273.0;
		    end if;
		else
		    calculatedMagnitude := (magnitude * 1.8) + 32.0;
		    if calculatedMagnitude < 459.67 then
			calculatedMagnitude := 459.67;
		    end if;
		end if;
	    end if;
	    t_io.new_line;
	    f_io.put(Item => magnitude, fore => 0, aft => 2, exp => 0);
	    t_io.put(" ");
	    t_io.put(su.to_string(inUnits(pos)));
	    t_io.put(" is equal to ");
	    f_io.put(Item => calculatedMagnitude, fore => 0, aft => 2, exp => 0);
	    t_io.put(" ");
	    t_io.put(su.to_string(outUnits(pos)));
	    t_io.put(".");
	    t_io.new_line;
	else
	    t_io.put("Incorrect conversion, try again.");
	end if;

    end convertUnits;

    quitCommand : String := "quit";

    magnitude : Float;
    unit : Character; --explicitly not of type abbreviations so there can be space inbetween magnitude and unit
    checkCommand : su.unbounded_string;


begin
    loop --continue to loop until 'quit' is entered
	begin
	    --reset values
	    magnitude := 0.0;
	    unit := '0'; --any character not in abbreviations
	    checkCommand := su.to_unbounded_string("");

	    t_io.put_line("Enter a number followed by a unit abbreviation. Type 'quit' to quit.");
	    t_io.put("> ");

	    f_io.get(magnitude);

	    while not(unit in 'A'..'z') loop --read characters until we find one that might be a measurement
		t_io.get(unit);
	    end loop;
    
	    unit := c_handling.to_lower(unit); --convert to lowercase

	    t_io.skip_line; --clean up
	    t_io.new_line;
	    
	    convertUnits(magnitude => magnitude, unit => unit); --convert our units
	exception
	    when t_io.data_error =>
		u_io.get_line(checkCommand);
		if su.to_string(checkCommand) = quitCommand then
		    exit;
		else
		    t_io.new_line;
		    t_io.put_line("Invalid Conversion, try again.");
		    t_io.new_line;
		end if;
	end;
    end loop;
end lab3;
