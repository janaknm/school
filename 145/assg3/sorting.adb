with Ada.Text_IO;	use Ada.Text_IO;
with Generic_Queue;

package body sorting is

    procedure counting_sort (data : in out array_t)
    is
	function getKey(n : Integer; element : element_t) return element_t is
	begin
	    return element;
	end getKey;

	function numKeys(item : element_t) return Natural is
	begin
	    return 1;
	end numKeys;

	procedure counting_sort_k is 
	    new counting_sort_from_key(element_t,
				       element_t,
				       array_t,
				       getKey,
				       numKeys,
				       ">");
    begin
	counting_sort_k(data, 0);
    end counting_sort;



    procedure bucket_sort (data : in out array_t)
    is
	function getKey(n : in Integer; element : in element_t) return element_t is
	begin
	    return element;
	end getKey;

	function numKeys(element : element_t) return Natural is
	begin
	    return 1;
	end numKeys;


	procedure bucket_sort_k is 
	    new counting_sort_from_key(element_t,
				       element_t,
				       array_t,
				       getKey,
				       numKeys,
				       ">");

    begin
	bucket_sort_k(data, 0);
    end bucket_sort;

    procedure bucket_sort_from_key (data : in out array_t; n : in Integer)
    is
	package eGeneric_Queue is new Generic_Queue (element_t);
	use eGeneric_Queue;
	type bucketArray is array(key_t range <>) of queuePtr;
	
	min, max : key_t;
	size, index : Natural;
	key : key_t;
    begin
	min := key_t'last;
	max := key_t'first;
	size := 0;
	--get size/max/min
	for i in data'range loop
	    size := size + 1;
	    if(numKeys(data(i)) >= n) then
		key := getKey(n, data(i));
		if(key > max) then
		    max := key;
		end if;
		if(key < min) then
		    min := key;
		end if;
	    end if;
	end loop;

	declare
	    buckets : bucketArray(min..max) := (Others => new_queue); 
	begin
	    for i in data'range loop
		if(numKeys(data(i)) >= n) then
		   key := getKey(n, data(i));
		else
		    key := min;
		end if;
		enqueue(buckets(key), data(i));
	    end loop;

	    index := data'First;
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
	
	size : Natural;
	max, min, tmp : key_t;
    begin
	min := key_t'last;
	max := key_t'first;
	size := 0;
	--get size/max/min
	for i in data'range loop
	    size := size + 1;
	    if(numKeys(data(i)) >= n) then
		tmp := getKey(n, data(i));
		if(tmp > max) then
		    max := tmp;
		end if;
		if(tmp < min) then
		    min := tmp;
		end if;
	    end if;
	end loop;

	declare
	    type auxArray is array(key_t range <>) of Natural;
	    sorted : array_t(data'range);
	    aux : auxArray(min..max) := (Others => 0);
	    key : key_t;
	begin
	    for i in data'range loop
		if(numKeys(data(i)) >= n) then
		    key := getKey(n, data(i));
		else
		    key := min;
		end if;
		aux(key) := aux(key) + 1;
	    end loop;
	    for i in key_t'succ(min) .. max loop
		aux(i) := aux(i) + aux(key_t'pred(i));
	    end loop;
	    for i in reverse data'range loop
		if(numKeys(data(i)) >= n) then
		    key := getKey(n, data(i));
		else
		    key := min;
		end if;
		sorted( aux(key)) := data(i);	
		aux(key) := aux(key) - 1;
	    end loop;
	    data := sorted;
	end;
	    
    end counting_sort_from_key;



    procedure radix_sort(data : in out array_t) is
	tmp, passes : Natural;
    begin
	passes := 0;
	for i in data'range loop
	    tmp := numKeys(data(i));
	    if(tmp > passes) then
		passes := tmp;
	    end if;
	end loop;

	for i in reverse 1..passes loop
	    stable_sort(data, i);
	end loop;
    end radix_sort;

end sorting;
