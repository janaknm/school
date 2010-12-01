--package to convert standard ada.text_io procedures into functions

with ada.text_io;
with ada.text_io.unbounded_io;
with ada.float_text_io;
with ada.integer_text_io;
with ada.strings;
with ada.strings.fixed;
with ada.strings.unbounded;

package body m_io is

    package t_io renames ada.text_io;
    package u_io renames ada.text_io.unbounded_io;
    package f_io renames ada.float_text_io;
    package i_io renames ada.integer_text_io;
    package s renames ada.strings;
    package sf renames ada.strings.fixed;
    package su renames ada.strings.unbounded;

    function getInt return Integer is
	retVal : Integer;
    begin
	loop
	    begin
		t_io.put("Enter an Integer > ");
		i_io.get(retval);
		t_io.skip_line;
		exit;
	    exception
		when t_io.data_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That is not an Integer, try again.");
		    t_io.new_line;
		when constraint_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That Integer is out of bounds, try again.");
		    t_io.new_line;
	    end;
	end loop;
	return retval;
    end getInt;

    function getFloat return Float is
	retval : Float;
    begin
	loop
	    begin
		t_io.put("Enter a Float > ");
		f_io.get(retVal);
		t_io.skip_line;
		exit;
	    exception
		when t_io.data_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That is not a Float, try again.");
		    t_io.new_line;
		when constraint_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That Float is out of bounds, try again.");
		    t_io.new_line;
	    end;
	end loop;
	return retVal;
    end getFloat;

    function getString(size : Positive) return StringPtr is
	retVal : StringPtr;
	retString : String(1..size);
	stringBuffer : su.unbounded_string;
    begin
	retval := new String(1..size);
	loop
	    begin
		t_io.put("Enter a String > ");
		u_io.get_line(stringBuffer);
		sf.move(
		    source => su.to_string(stringBuffer),
		    target => retString,
		    drop => s.right,
		    justify => s.left,
		    pad => s.space);
		retVal(1..size) := retString(1..size);
		exit;
	    exception
		when t_io.data_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That is not a String, try again");
		    t_io.new_line;
		when constraint_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That String is out of bounds, try again");
		    t_io.new_line;
	    end;
	end loop;
	return retval;
    end getString;

    function getUnboundedString return su.unbounded_string is
	retVal : su.unbounded_string;
    begin
	loop
	    begin
		t_io.put("Enter a String > ");
		u_io.get_line(retVal);
		exit;
	    exception
		when t_io.data_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That is not a String, try again");
		    t_io.new_line;
		when constraint_error =>
		    t_io.skip_line;
		    t_io.new_line;
		    t_io.put("That String is out of bounds, try again");
		    t_io.new_line;
	    end;
	end loop;
	return retVal;
    end getUnboundedString;
end m_io;

