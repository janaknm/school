--Matt Forbes
--robust IO for just integers and floats
--FUTURE: maybe generic package for robust input with enumeration types
package body robust_io is

    procedure handleError (message: string) is --take message to use as error message
    begin
	t_io.skip_line; --clear out bad input
	t_io.put_line(message); --display error
	t_io.new_line;
    end handleError;

    function getInt (message : string) return Integer is --message is prompt for this integer
	retVal : Integer;
    begin
	loop
	    begin
		t_io.put(message);
		i_io.get(retVal);
		exit;
	    exception
		when t_io.data_error =>
		    handleError("Invalid input, try again");
		when constraint_error =>
		    handleError("Out of bounds, try again.");
	    end;
	end loop;
	return retVal;
    end getInt;

    function getFloat (message : string) return Float is
	retVal : Float;
    begin
	loop
	    begin
		t_io.put(message);
		f_io.get(retVal);
		exit;
	    exception
		when t_io.data_error =>
		    handleError("Invalid input, try again.");
		when constraint_error =>
		    handleError("Out of bounds, try again.");
	    end;
	end loop;
	return retVal;
    end getFloat;

end robust_io;
