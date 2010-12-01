with Ada.Text_IO;	use Ada.Text_IO;
with Generic_Queue;

package body sorting is

    procedure counting_sort (data : in out array_t)
    is
	function getKey(n : Integer; element : element_t) return element_t is
	begin
	    return element;
	end getKey;

	procedure counting_sort_k is 
	    new counting_sort_from_key(element_t,
				       element_t,
				       array_t,
				       getKey,
				       ">");
    begin
	counting_sort_k(data, 0);
    end counting_sort;

    procedure bucket_sort (data : in out array_t)
    is
	function getKey(n : Integer; element : element_t) return element_t is
	begin
	    return element;
	end getKey;

	procedure bucket_sort_k is 
	    new counting_sort_from_key(element_t,
				       element_t,
				       array_t,
				       getKey,
				       ">");

    begin
	bucket_sort_k(data, 0);
    end bucket_sort;

    procedure bucket_sort_from_key (data : in out array_t; n : in Integer)
    is
	package eGeneric_Queue is new Generic_Queue (element_t);
	use eGeneric_Queue;
	type bucketArray is array(key_t range <>) of queuePtr;

	procedure get_size_min_max (data : in out array_t;
				    size : out Natural;
				    min : out key_t;
				    max : out key_t) 
	is
	    tmp : key_t;
	begin
	    min := key_t'last;
	    max := key_t'first;
	    size := 0;
	    for i in data'range loop
		begin
		    size := size + 1;
		    tmp := getKey(n, data(i));
		    if(tmp > max) then
			max := tmp;
		    end if;
		    if(tmp < min) then
			min := tmp;
		    end if;
		exception
		    when sorting.No_Key => NULL;
		end;
	    end loop;
	end get_size_min_max;

	min, max : key_t;
	size, index : Natural;
	key : key_t;
    begin
	get_size_min_max(data, size, min, max);
	declare
	    buckets : bucketArray(min..max) := (Others => NULL); 
	begin
	    for i in data'range loop
		begin
		    key := getKey(n, data(i));
		exception
		    when No_Key =>
			key := min;
		end;
		enqueue(buckets(key), data(i));
	    end loop;

	    index := 0;
	    for i in buckets'range loop
		while(not empty(buckets(i))) loop
		    data(index) := dequeue(buckets(i));
		    index := index + 1;
		end loop;
	    end loop;
	end;
    end bucket_sort_from_key;

    procedure counting_sort_from_key (data : in out array_t; n : in Integer)
    is
	function "<"(left, right : key_t) return Boolean is
	begin
	    return (right > left);
	end "<";

	procedure get_size_min_max (data : in out array_t;
				    size : out Natural;
				    min : out key_t;
				    max : out key_t) 
	is
	    tmp : key_t;
	begin
	    min := key_t'last;
	    max := key_t'first;
	    size := 0;
	    for i in data'range loop
		begin
		    size := size + 1;
		    tmp := getKey(n, data(i));
		    if(tmp > max) then
			max := tmp;
		    end if;
		    if(tmp < min) then
			min := tmp;
		    end if;
		exception
		    when sorting.No_Key => NULL;
		end;
	    end loop;
	end get_size_min_max;

	size : Natural;
	max, min : key_t;
    begin
	get_size_min_max(data, size, min, max);
	declare
	    type auxArray is array(key_t range <>) of Natural;
	    sorted : array_t(data'range);
	    aux : auxArray(min..max) := (Others => 0);
	    key : key_t;
	begin
	    for i in data'range loop
		begin
		    key := getKey(n, data(i));
		exception
		    when sorting.No_Key =>
			key := min;
		end;
		aux(key) := aux(key) + 1;
	    end loop;
	    for i in key_t'succ(min) .. max loop
		aux(i) := aux(i) + aux(key_t'pred(i));
	    end loop;
	    for i in reverse data'range loop
		begin
		    key := getKey(n, data(i));
		exception
		    when sorting.No_Key =>
			key := min;
		end;
		sorted( aux(key)) := data(i);	
		aux(key) := aux(key) - 1;
	    end loop;
	    data := sorted;
	end;
	    
    end counting_sort_from_key;



    procedure radix_sort(data : in out array_t) is

	procedure get_min_and_passes(data : in out array_t;
				     min  : out element_t;
				     passes : out Natural) is
	    tmp : Natural := 0;
	begin
	    passes := 0;
	    min := data(data'first);
	    for i in data'range loop
		if(data(i) < min) then
		    min := data(i);
		end if;
		tmp := numKeys(data(i));
		if(tmp > passes) then
		    passes := tmp;
		end if;
	    end loop;
	end get_min_and_passes;

	min : element_t;
	passes : Natural;
    begin
	get_min_and_passes(data, min, passes);
	for i in reverse 1..passes loop
	    stable_sort(data, i);
	end loop;
    end radix_sort;

end sorting;
