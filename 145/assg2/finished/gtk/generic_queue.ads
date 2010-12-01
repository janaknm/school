--Matt Forbes
--Feb 1, 2010
--Generic Queue specification
with Generic_Linked_list;
Generic
    --generic type parameter may be any type with an assignment operator
    type Element_t is private;
package Generic_Queue is

    --users of this package should not be able to see implementation
    type Queue is private;
    type QueuePtr is access Queue;
    
    --this exception is raised when a user tries to pop an empty stack
    Queue_Underflow : exception ;

    --constructor for a stack
    function new_queue return queuePtr;

    --push Item onto stack aStack
    procedure enqueue(aQueue : in QueuePtr; Item : in Element_t );

    --pop the top value from aStack
    function dequeue(aQueue : in QueuePtr) return Element_t;

    --peek at the top of the stack without popping it
    function front(aQueue : in QueuePtr) return Element_t;

    --check if stack aStack is empty
    function empty(aQueue : in QueuePtr) return Boolean;

    --get size of a queue
    function size(aQueue : in QueuePtr) return Natural;

    --clear aStack
    procedure clear(aQueue : in QueuePtr);
private

    --this stack is implemented with a linked_list
    package Element_Linked_List is new Generic_Linked_List(Element_t);
    subtype Element_List is Element_Linked_List.ListPtr;

    type Queue is
	record
	    top : Element_List;
	    bottom : Element_List;
	    size : Natural;
	end record;

end Generic_Queue;
