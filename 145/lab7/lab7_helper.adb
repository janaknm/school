with Ada.Text_IO;	  use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body lab7_helper is
    function get_size_of_file(fileName : in String) return Natural is
	size : Natural := 0;
	file : File_Type;
	tmp : Integer;
    begin
	begin
	    open(file, IN_FILE, fileName);
	    put_line(fileName & " opened.");
	exception
	    when name_error => 
		put_line(fileName & " could not be opened");
		raise name_error;
	end;
	while(not End_Of_File(file)) loop
	    get(file, tmp);
	    size := size + 1;
	end loop;
	close(file);
	return size;
    end get_size_of_file;

    procedure get_ints_from_file(fileName : String; data : out IntArray) is
	file : File_Type;
    begin
	open(file, IN_FILE, fileName);
	for i in data'range loop
	    begin
		get(file, data(i));
	    exception
		when constraint_error =>
		    return;
	    end;
	end loop;
	close(file);
    end get_ints_from_file;

    procedure put_ints_to_file(fileName : String; data : in IntArray) is
	file : File_Type;
    begin
	begin
	    open(file, OUT_FILE, fileName);
	exception
	    when name_error =>
		create(file, OUT_FILE, fileName);
	end;
	for i in data'range loop
	    put(file, data(i), 4);
	    if( i rem 10 = 0) then
		new_line(file);
	    end if;
	end loop;
	close(file);
    end put_ints_to_file;

end lab7_helper;
