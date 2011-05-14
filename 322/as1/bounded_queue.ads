generic

	-- the generic parameter: the type of item to be queued
	type Element_type is private;
	
package bounded_queue is

	type Queue_type (Max_size : positive) is limited private;
	
	Overflow, 
	Underflow : exception;

	-- procedure Clear
	-- purpose:	remove all entries from the queue
	procedure Clear(Queue : in out Queue_type);	

	-- procedure Enqueue
	-- purpose:		add an item to the tail of the queue
	-- exception: 	Overflow on attempt to add to a full queue
	procedure Enqueue(Queue : in out Queue_type; Item : in Element_type);
	
	-- procedure Dequeue
	-- purpose:		remove the item from the front of the queue
	-- exception:	Underflow on attempt to dequeue from an empty queue 
	procedure Dequeue(Queue : in out Queue_type; Item : out Element_type);
	
	-- function Empty
	-- purpose:	determine whether the queue is empty
	function Empty(Queue : in Queue_type) return boolean;
	
	-- function Full
	-- purpose:	determine whether the queue is full
	function Full(Queue : in Queue_type) return boolean;


private

	type Queue_Array is array (Positive range <>) of Element_Type;
	type Queue_Type (Max_size : positive) is record
		Count : natural := 0;			 	-- number of items in the queue
		Front : Positive := 1;				-- index of first item
		Rear  : Positive := 1;		-- index of the last item 
		Items : Queue_Array(1 .. Max_Size);	-- element array
	end record;
    
end bounded_queue;
