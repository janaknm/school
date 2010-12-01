with generic_linked_list;
with generic_queue;
with ada.text_io;
use ada.text_io;
with Expressions;

procedure test_queue is
    package i_queue is new generic_queue(Integer);
    use i_queue;

    q : i_queue.queuePtr;
begin
    q := new_queue;
    enqueue(q, 3);
    enqueue(q, 1);
    enqueue(q, 2);
    enqueue(q, 3);
    enqueue(q, 4);
    enqueue(q, 5);
    while(not empty(q)) loop
	put_line(Integer'Image(dequeue(q)));
    end loop;

    Expressions.runTests;
end test_queue;
