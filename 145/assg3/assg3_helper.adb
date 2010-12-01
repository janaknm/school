with Ada.Text_IO;	    use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;	    use Ada.Float_Text_IO;

 package body assg3_helper is

    function getKey(n : in Integer; element : in Integer) return Integer is
	k : Natural := element;
    begin
	for i in 1..n loop
	    if(k = 0) then
		return 0;
	    end if;
	    k := k / 10;
	end loop;
	return (k REM 10);
    end getKey;

    function getKey(n : in Integer; element : in Float) return Integer is
	strRep : String := Integer'Image(Integer(element));
    begin
	if(strRep'Length < n) then
	    return 0;
	end if;
	return Character'pos(strRep(n)) - Character'pos('0');
    end getKey;

    function getKey(n : in Integer; element : in Obscure) return Integer is
	strRep : String := Integer'Image(element.ID);
    begin
	if(strRep'Length < n) then
	    return 0;
	end if;
	return Character'pos(strRep(n)) - Character'pos('0');
    end getKey;


    function numKeys(element : in Integer) return Natural is
	s : Natural := 1;
	k : Natural := 0;
    begin
	while (s <= element) loop
	    k := k + 1;
	    s := s*10;
	end loop;
	return k;
    end numKeys;
    
    function numKeys(element : in Float) return Natural is
	strRep : String := Integer'Image(Integer(element));
    begin
	return strRep'Length;
    end numKeys;
    
    function numKeys(element : in Obscure) return Natural is
	strRep : String := Integer'Image(element.ID);
    begin
	return strRep'Length;
    end numKeys;

    function ">"(left, right : Obscure) return Boolean is
    begin
	return (left.ID > right.ID);
    end ">";

    function "<"(left, right : Obscure) return Boolean is
    begin
	return right > left;
    end "<";

    procedure makeRandom(data : in out IntArray) is
    	G : Generator;
    begin
	reset(G);	
	for i in data'range loop
	    data(i) := Random(G);
	end loop;
    end makeRandom;
	
    procedure makeRandom(data : in out FloatArray) is
	G : Generator;
    begin
	reset(G);
	for i in data'range loop
	    data(i) := Float(Random(G));
	    data(i) := data(i) + Float(Random(G))/100.0;
	end loop;
    end makeRandom;
	
    procedure makeRandom(data : in out ObscureArray) is
	G : Generator;
    begin
	reset(G);
	for i in data'range loop
	    data(i).ID := Random(G);
	end loop;
    end makeRandom;

    procedure print(file : File_Type; element : Integer) is 
    begin
	put(file, element, 0);
    end print;

    procedure print(file : File_Type; element : Float) is
    begin
	put(file, element, 0, 2, 0);
    end print;

    procedure print(file : File_Type; element : Obscure) is
    begin
	put(file, element.ID, 0);
    end print;
	
    procedure printArr(file : File_Type; data : in Array_t) is
    begin
	for i in data'range loop
	    print(file, data(i));
	    put(file, " ");
	    if(i REM 50 = 0) then
		new_line(file);
	    end if;
	end loop;
    end printArr;

    procedure open_or_create(file : in out File_Type; mode : in File_Mode; filename : in String) is
    begin
	begin
	    open(file, mode, filename);
	exception
	    when name_error =>
		if(mode = Out_File) then
		    create(file, mode, filename);
		else
		    put_line("Could not open " & filename);
		    raise name_error;
		end if;
	end;
    end open_or_create;

    procedure get_size_of_ints(file : in out File_Type; size : out Natural) is
        tmp : Integer;
    begin
	size := 0;
       while(not End_of_file(file)) loop
	    get(file, tmp);
	    size := size + 1;
	end loop;
	reset(file);
    end get_size_of_ints;
    
    procedure get_ints_from_file(file : in File_Type; data : out IntArray) is
    begin
	for i in data'range loop
	    get(file, data(i));
	end loop;
    end get_ints_from_file;


    

end assg3_helper;

