-- Matt Forbes
-- May 2011
-- CS322 - WWU

-- Usage: as1 <clients> <messages>. Spawn <clients> tasks to send
--  <messages> number of messages to each other by transport in
--  "mailboxes"

-- standard includes
with Ada.Text_IO, Ada.Strings.Unbounded
  
use Ada.Text_IO, Ada.Strings.Unbounded;

-- local includes
with Bounded_Queue; use Bounded_Queue;
with Mail_Help; use Mail_Help;

procedure As1 is

    task type Client_Task(Messages_To_send : Positive;
                          Max_Messages : positive);
    
    task body Client_Task is
        ID : Natural;
        Mailbox, Destination : Mailbox_Ptr;
        Name : Unbounded_String;
        Message_String : Unbounded_String;
        Message : Message_Type;
        My_Messages : Natural;
    begin

        Client_Registry.Register(Name, ID, Mailbox);
        
        for I in 1..Messages_To_Send loop
            delay Duration(Random_Manager.Random(1.0));
            Message_String := Message_Manager.Random_Message;
            Destination := Client_Registrar.Random_Mailbox;
            Message := (Name => Name, 
                        Message => Message_String);
            Mailbox.Put(Message);
            My_Messages := Mailbox.Num_Messages;
            if My_Messages > 0 then
                Mailbox.Get(Message);
                -- do something cool
            end if;
        end loop;

        while Mailbox.Num_Messages > 0 loop
            Mailbox.Get(Message);
            -- do something cool
        end loop;
        
    end Client_Task;
    
        
    
end As1;

