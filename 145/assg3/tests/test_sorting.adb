with Ada.Text_IO;	use Ada.Text_IO;
with sorting;

procedure test_sorting is
   type intArray is array(Integer range <>) of Integer;

   function getKey(n : in Integer; element : in Integer) return Integer is
	strRep : String := Integer'Image(element);
   begin
	if (strRep'Length < n) then
	    raise sorting.No_Key;
	end if;
	return element;
    end getKey;

    function numKeys(element : in Integer) return Natural is
	strRep : String := Integer'Image(element);
    begin
	return strRep'Length;
    end numKeys;

    procedure print(data : in intArray) is 
    begin
	for i in data'range loop
	    put(Integer'Image(data(i)) & " ");
	end loop;
	new_line;
    end print;

    procedure i_counting_sort is 
	new sorting.counting_sort(Integer, intArray);

    procedure i_bucket_sort is
	new sorting.bucket_sort(Integer, intArray);

    procedure i_counting_sort_from_key is 
	new sorting.counting_sort_from_key(Integer,
					   Integer,
					   intArray,
					   getKey);

   procedure i_bucket_sort_from_key is 
	new sorting.bucket_sort_from_key(Integer, 
					 Integer,
					 intArray,
					 getKey);

    procedure i_radix_counting_sort is 
	new sorting.radix_sort(Integer,
			       intArray,
			       numKeys,
			       i_counting_sort_from_key);

    procedure i_radix_bucket_sort is 
	new sorting.radix_sort(Integer,
			       intArray,
			       numKeys,
			       i_bucket_sort_from_key);


    myArray : intArray(1..10) := (51, 3, 220, 81, 1000, 7, 92, 0, 42, 67);

begin
    put("Before: ");
    print(myArray);
    i_bucket_sort(myArray);
    put("After: ");
    print(myArray);

end test_sorting;
