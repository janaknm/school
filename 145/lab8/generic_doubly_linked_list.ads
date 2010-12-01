with generic_linked_list;

generic
    type element_t is private;
package generic_doubly_linked_list is
    package ps is new generic_linked_list(element_t);
    use ps;

    type dlist is new list with
	record
	    prev : listp;
	end record;
    type dlistp is access all dlist;

    function insert_after_d(this : listp; value : Element_t) return listp; 


end generic_doubly_linked_list;
