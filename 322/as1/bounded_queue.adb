
package body bounded_queue is

    -- procedure Clear
    -- purpose:	remove all entries from the queue
    procedure Clear(Queue : in out Queue_type) is
    begin
        Queue.Count := 0;
        Queue.Front := 1;
        Queue.rear  := 1;	
    end Clear;

    -- procedure Enqueue
    -- purpose:		add an item to the tail of the queue
    -- exception: 	Overflow on attempt to add to a full queue
    procedure Enqueue(Queue : in out Queue_type; Item : in Element_type) is
    begin
        if Queue.Count = Queue.Max_Size then
            raise Overflow;
        end if;
        
        -- add the item to the rear of the queue
        Queue.Items(Queue.Rear) := Item;
        Queue.Rear := Queue.Rear mod Queue.Max_Size + 1;
        Queue.Count := Queue.Count + 1;	
    end Enqueue;
    
    -- procedure Dequeue
    -- purpose:		remove the item from the front of the queue
    -- exception:	Underflow on attempt to dequeue from an empty queue 
    procedure Dequeue(Queue : in out Queue_type; Item : out Element_type) is
    begin
        if Queue.Count = 0 then
            raise Underflow;
        end if;
        
        -- remove the item from the front of the queue
        Item := Queue.Items(Queue.Front);
        Queue.Front := Queue.Front mod Queue.Max_Size + 1;
        Queue.Count := Queue.Count - 1;
    end Dequeue;
    
    -- function Empty
    -- purpose:	determine whether the queue is empty
    function Empty(Queue : in Queue_type) return boolean is
    begin
        return Queue.Count = 0;
    end Empty;
    
    -- function Full
    -- purpose:	determine whether the queue is full
    function Full(Queue : in Queue_type) return boolean is
    begin
        return Queue.Count = Queue.Max_Size;
    end Full;


end bounded_queue;

