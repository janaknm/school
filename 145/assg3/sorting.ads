package sorting is

    No_Key : Exception;

    generic
	type element_t is (<>);
	type array_t is array(Integer range <>) of element_t;
    procedure counting_sort(data : in out array_t);

    generic
	type element_t is (<>);
	type array_t is array(Integer range <>) of element_t;
    procedure bucket_sort(data : in out array_t);

    generic
	type element_t is private;
	type key_t is (<>);
	type array_t is array(Integer range <>) of element_t;
	with function getKey(n : Integer; elem : element_t) return key_t ;
	with function numKeys (item : element_t) return Natural;
	with function ">"(left, right : in key_t) return Boolean is <>;
    procedure bucket_sort_from_key(data : in out array_t; n : in Integer);
    --sort the array based on the result of getKey() on each element
    
    generic
	type element_t is private;
	type key_t is (<>);
	type array_t is array(Integer range <>) of element_t;
	with function getKey(n : in Integer; elem : element_t) return key_t;
	with function numKeys (item : element_t) return Natural;
	with function ">"(left, right : in key_t) return Boolean is <>;
    procedure counting_sort_from_key(data : in out array_t; n : in Integer);
    --sort the array based on the result of getKey() on each element

    generic
	type element_t is private;
	type array_t is array(Integer range <>) of element_t;
	with function numKeys (item : element_t) return natural is <>;
	with procedure stable_sort (data : in out array_t; n : Integer) is <>;
	with function "<"(left, right : element_t) return Boolean is <>;
    procedure radix_sort(data : in out array_t);

end sorting;
