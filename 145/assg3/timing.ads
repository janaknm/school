package timing is

    generic
	type element_t is private;
	type array_type is array(Integer range <>) of element_t;
	type sort_func is access procedure (data : in out array_type);
    procedure timesort (sort : in sort_func;
			data : in out array_type;
			ms   : out Float);

end timing;

