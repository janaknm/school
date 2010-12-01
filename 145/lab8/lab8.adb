with Ada.Text_IO;	use Ada.Text_IO;
with ada.Integer_Text_IO; use ada.Integer_text_io;
with generic_doubly_linked_list;

procedure lab8 is

    package id_list is new generic_doubly_linked_list(Integer);
    use id_list;
    use id_list.ps;

    n : constant Natural := 100;

    head, last, iter : listp;
    c : Natural;

begin
    for i in 1..n loop
	last := insert_after_d(last, i);
	if(head = null) then
	    head := last;
	end if;
	
    end loop;

    iter := head;
    c := 0;

    while(iter /= null) loop
	put(iter.data, 4);
	iter := iter.next;
	c := c + 1;
	if(c rem 10 = 0) then
	    new_line;
	end if;
    end loop;

    new_line;
    put_line("reverse!");
    new_line;

    iter := last;
    c := 0;

    while(iter /= null) loop
	put(iter.data, 4);
	iter := dlistp(iter).prev;
	c := c + 1;
	if(c rem 10 = 0) then
	    new_line;
	end if;
    end loop;


end lab8;
