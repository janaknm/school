--Matt Forbes
--Feb 1, 2010
--Generic Linked List specification
with Generic_Linked_list;
Generic
    --generic type parameter may be any type with an assignment operator
    type Element_t is private;
package Generic_Stack is

    --users of this package should not be able to see implementation
    type Stack is private;
    type StackPtr is access Stack;
    
    --this exception is raised when a user tries to pop an empty stack
    Stack_Underflow : exception ;

    --constructor for a stack
    function new_stack return stackPtr;

    --push Item onto stack aStack
    procedure push(aStack : in StackPtr; Item : in Element_t );

    --pop the top value from aStack
    function pop(aStack : in StackPtr) return Element_t;

    --peek at the top of the stack without popping it
    function top(aStack : in StackPtr) return Element_t;

    --check if stack aStack is empty
    function empty(aStack : in StackPtr) return Boolean;

    --clear aStack
    procedure clear(aStack : in StackPtr);
private

    --this stack is implemented with a linked_list
    package Element_Linked_List is new Generic_Linked_List(Element_t);
    subtype Element_List is Element_Linked_List.ListPtr;

    type Stack is
	record
	    top : Element_List;
	    size : Natural;
	end record;

end Generic_Stack;
