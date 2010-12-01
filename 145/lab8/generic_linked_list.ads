generic
    type Element_t is private;
package generic_linked_list is

    type list;
    type listp is access all list'Class;
    type list is tagged
	record
	    data : Element_t;
	    next : listp := null;
	end record;

    function insert_after(this : listp; value : Element_t) return listp; 




end generic_linked_list;
