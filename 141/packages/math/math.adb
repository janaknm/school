with ada.text_io;
with ada.float_text_io;

package body math is

--    type numArray is array(Integer range <>) of Float;
  --  type numArrayPtr is access numArray;

    package t_io renames ada.text_io;
    package f_io renames ada.float_text_io;

    function getNumArray (needed : in Integer) return numArrayPtr is --return a reference to a type numArray
	returnArray : numArrayPtr; --reference to return
	index : Integer;
    begin
	returnArray := new numArray(1..needed); --set returnArray to point to a memory location holding an array of this size
	index := 1;
	loop
	    begin
		exit when index > returnArray'last;
		t_io.put("Enter a number > ");
		f_io.get(Item => returnArray(index));

		index := index + 1;
	    exception
		when t_io.data_error =>
		    t_io.new_line;
		    t_io.skip_line;
		    t_io.put("That is not a correct number, please enter another.");
		    t_io.new_line;
		when constraint_error =>
		    t_io.new_line;
		    t_io.skip_line;
		    t_io.put("That number is out of bounds, please enter another.");
	    end;
	end loop;
	return returnArray;
    end getNumArray;

    procedure add (needed : Integer) is
	sum :Float;
	numbers : numArrayPtr;
    begin
	sum := 0.0;
	numbers := getNumArray(needed);
	for i in numbers'range loop
	    sum := sum + numbers(i);
	end loop;
	f_io.put(Item => sum, fore => 1, aft => 1, exp => 0);
    end add;

    procedure subtract (needed : Integer) is
	remainder : Float;
	numbers : numArrayPtr;
    begin
	numbers := getNumArray(needed);
	remainder := numbers(numbers'first);
	for i in numbers'range loop
	    if i /= numbers'first then
		remainder := remainder - numbers(i);
	    end if;
	end loop;
	f_io.put(remainder);
    end subtract;

    procedure multiply (needed : Integer) is
	numbers : numArrayPtr;
	product : Float;
    begin
	numbers := getNumArray(needed);
	product := 1.0;
	for i in numbers'range loop
	    product := product * numbers(i);
	end loop;
	f_io.put(product);
    end multiply;

    procedure divide (needed : Integer) is
	numbers : numArrayPtr;
	quotient : Float;
    begin
	numbers := getNumArray(needed);
	quotient := numbers(numbers'first);
	for i in numbers'range loop
	    quotient := quotient / numbers(i);
	end loop;
	f_io.put(quotient);
    end divide;
end math;
