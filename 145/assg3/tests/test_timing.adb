with Timing;
with Ada.Text_IO;	use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure test_timing is

   type myArray is array(Integer range <>) of Integer;
   type sort_access is access procedure (data : in out myArray);

   procedure test_sort is new Timing.timesort(Integer, myArray, sort_access);

    procedure sort (data : in out myArray) is 
    begin
	data := (Others => 1);
	put_line("hello!");
    end sort;

    procedure print (data : in myArray) is
    begin
	for i in data'range loop
	    put(Integer'image(data(i)) & " ");
	end loop;
	new_line;
    end print;

    test_arr : myArray(1..10) := (Others => 0);
    ms	     : Float;
begin

    print(test_arr);
    test_sort(sort'access, test_arr, ms);
    print(test_arr);
    put("Took: ");
    put(ms, 0, 3, 0);
    put_line("ms");

end test_timing;
