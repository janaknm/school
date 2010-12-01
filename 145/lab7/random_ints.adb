with Ada.Text_IO;		    use Ada.Text_IO;
with Ada.Integer_Text_IO;	    use Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

procedure random_ints is
    fileName : constant String := "ints.dat";
    size : Natural;
begin
    put("Generate how many randoms to file: " & fileName & "? ");
    get(size);
    declare
	subtype randRange is Integer range 0..size;
	package randoms is new Ada.Numerics.Discrete_Random(randRange);
	file : File_Type;
	G : randoms.Generator;
    begin
	randoms.reset(G);
	begin
	    open(file, OUT_FILE, fileName);
	    put_line(fileName & " opened.");
	exception
	    when name_error =>
		create(file, OUT_FILE, fileName);
		put_line(fileName & " created.");
	end;
	put_line("Generating...");
	for i in 1..size loop
	    put(file, randoms.Random(G), 0);
	    put(file, " ");
	    if(i rem 10 = 0) then
		new_line(file);
	    end if;
	end loop;
	put_line("Operations successful.");

    end;

end random_ints;
