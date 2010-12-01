with sorting;
with lab7_helper;	use lab7_helper;
with Ada.Text_IO;	use Ada.Text_IO;

procedure lab7 is
   procedure i_counting_sort is
	new sorting.counting_sort (Integer, IntArray);
    
    inFileName : constant String := "Ints_Unsorted.dat";
    outFileName : constant String := "Ints_Sorted.dat";
    size : Natural;
begin
    put_line("Sorting ints from file: " & inFileName & " in to file: " & outFileName & "...");
    size := get_size_of_file(inFileName);
    declare
	myArray : IntArray(1..size);
    begin
	get_ints_from_file(inFileName, myArray);
	put_line("Got ints from file " & inFileName);
	i_counting_sort(myArray);
	put_line("Sorted ints.");
	put_ints_to_file(outFileName, myArray);
	put_line("Wrote ints to file " & outFileName);
    end;
    put_line("Operations successful.");

end lab7;
