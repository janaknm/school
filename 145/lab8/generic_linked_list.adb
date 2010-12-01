with ada.text_io; use ada.text_io;
package body generic_linked_list is

    function insert_after(this : listp; value : Element_t) return listp is
	newlist : listp := null;
    begin
	put_line("wrong one!");
	if(this = null) then
	    newlist := this;
	    newlist := new list'(next=>null, data=>value);
	    return newlist;
	end if;
	newlist := new list'(next=>this.next, data=>value);
	this.next := newlist;
	return newlist;
    end insert_after;

end generic_linked_list;
