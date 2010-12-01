--Matt Forbes
--Feb 1, 2010
--Generic Queue body
with ada.text_io; use ada.text_io;

package body Generic_Queue is

    --this is the generic linked list package created in the private part of spec file
    use Element_Linked_list;

    function new_queue return queuePtr is
	nQueue : queuePtr;
    begin
	nQueue := new queue;
	nQueue.size := 0;
	nQueue.top := NULL;
	nQueue.bottom := NULL;
	return nQueue;
    end new_queue;

    function size(aQueue : queuePtr) return Natural is
    begin
	return aQueue.size;
    end size;

    procedure enqueue(aQueue : in queuePtr; Item : in Element_t) is
    begin
	aQueue.size := aQueue.size+1;
	aQueue.bottom := insert_after(aQueue.bottom, Item);
	if aQueue.top = null then
	    aQueue.top := aQueue.bottom;
	end if;
    end enqueue;

    function dequeue(aQueue : in queuePtr) return Element_t is
	rVal : Element_t;
    begin
	if(empty(aQueue)) then
	    raise Queue_Underflow;
	end if;
	aQueue.size := aQueue.size - 1;
	rVal := value(aQueue.top);
	remove(aQueue.top, aQueue.top);
	return rVal;
    end dequeue;

    function front(aQueue : in queuePtr) return Element_t is
    begin
	if(empty(aQueue)) then
	    raise Queue_Underflow;
	end if;
	return value(aQueue.top);
    end front;

    function empty(aQueue : in queuePtr) return Boolean is
    begin
	if(aQueue.size < 1) then
	    return True;
	end if;
	return False;
    end empty;

    procedure clear(aQueue : in queuePtr) is
    begin
	aQueue.size := 0;
	clear(aQueue.top);
    end clear;

end Generic_Queue;
