-- Matt Forbes
-- May 2011
-- CS322 - WWU

-- Usage: as1 <clients> <messages>. Spawn <clients> tasks to send
--  <messages> number of messages to each other by transport in
--  "mailboxes"

-- standard includes
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line; use Ada.Command_Line;

-- local includes
with Mail_Help; use Mail_Help;

procedure As1 is

    Number_Of_Clients : Positive := Integer'Value(Argument(1));
    Messages_To_Send : Positive := Integer'Value(Argument(2));

    Manager : Client_Manager(Number_Of_Clients, Messages_To_Send * Number_Of_clients);

    task type Client_Task;
    
    task body Client_Task is
        ID : Natural;
        Mailbox, Destination : Mailbox_Ptr;
        Name : Unbounded_String;
        Message_String : Unbounded_String;
        Message : Message_Type;
        My_Messages : Natural;
    begin

        Manager.Register(Name, ID, Mailbox);
        
        for I in 1..Messages_To_Send loop
            delay Duration(Random(1.0));
            Message_String := Message_Manager.Random_Message;
            Destination := Manager.Random_Mailbox(ID);
            Message := (Name => Name, 
                        Message => Message_String);
            Destination.Put(Message);
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

        Manager.UnRegister(Id);
        
    end Client_Task;
    
    type Client_Array is array(Positive range <>) of Client_Task;

    Clients : Client_Array(1..Number_Of_clients);
    
begin
    
    null;
    
end As1;

