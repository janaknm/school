--testing input for unit + measurement

with ada.text_io;
with ada.text_io.unbounded_io;
with ada.float_text_io;
with ada.strings.unbounded;

procedure testinput is

    package t_io renames ada.text_io;
    package f_io renames ada.float_text_io;
    package u_io renames ada.text_io.unbounded_io;
    package su renames ada.strings.unbounded;

    subtype alphabet is Character range 'A'..'z';
    type measurements is ('p', 'y', 'f', 'k', 'm', 'c');
    type rates is array(measurements) of Float;


    converstions : constant rates := ('p' => 0.454, 'y' => 0.914, others => 0.0);

    a : Float;
    b : Character;
    checkCommand : su.unbounded_string;

begin
    loop
	begin
	    a := 0.0;
	    b := '0';
	    
	    t_io.put("Enter a number followed by a unit abbreviation. (ie. 15m)  > ");
	    f_io.get(a);
	    while not(b in alphabet) loop
		t_io.get(b);
	    end loop;

	    t_io.skip_line;
	    t_io.new_line;
	    f_io.put(a);
	    t_io.new_line;
	    t_io.put(b);
	exception
	    when t_io.data_error =>
		u_io.get_line(checkCommand);
		u_io.put(checkCommand);
		--t_io.skip_line;
		t_io.new_line;
	end;
    end loop;

end testinput;
