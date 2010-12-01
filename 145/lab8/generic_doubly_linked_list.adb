with ada.text_io; use ada.text_io;
package body generic_doubly_linked_list is


    function insert_after_d(this : listp; value : Element_t) return listp is
	newlist : listp;
    begin
	if(this = null) then
	    newlist := new dlist'(prev=>null, next=>null, data=>value);
	    return newlist;
	end if;
	newlist := new dlist'(prev=>this, next=>this.next, data=>value);
	this.next := newlist;
	return newlist;
    end insert_after_d;

end generic_doubly_linked_list;
