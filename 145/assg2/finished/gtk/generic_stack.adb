--Matt Forbes
--Feb 1, 2010
--Generic Stack body

package body Generic_Stack is

    --this is the generic linked list package created in the private part of spec file
    use Element_Linked_list;

    function new_stack return stackPtr is
	nStack : stackPtr;
    begin
	nStack := new stack;
	nStack.size := 0;
	nStack.top := NULL;
	return nStack;
    end new_stack;

    function size(aStack : in StackPtr) return Natural is
    begin
	return aStack.size;
    end size;

    procedure push(aStack : in StackPtr; Item : in Element_t) is
    begin
	aStack.size := aStack.size+1;
	aStack.top := insert_before(aStack.top, Item);
    end push;

    function pop(aStack : in StackPtr) return Element_t is
	rVal : Element_t;
    begin
	if(empty(aStack)) then
	    raise Stack_Underflow;
	end if;
	aStack.size := aStack.size - 1;
	rVal := value(aStack.top);
	remove(aStack.top, aStack.top);
	return rVal;
    end pop;

    function top(aStack : in StackPtr) return Element_t is
    begin
	if(empty(aStack)) then
	    raise Stack_Underflow;
	end if;
	return value(aStack.top);
    end top;

    function empty(aStack : in StackPtr) return Boolean is
    begin
	if(aStack.size < 1) then
	    return True;
	end if;
	return False;
    end empty;

    procedure clear(aStack : in StackPtr) is
    begin
	aStack.size := 0;
	clear(aStack.top);
    end clear;

end Generic_Stack;
