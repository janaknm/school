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
with Ada.Exceptions; use Ada.Exceptions;


-- local includes
with Mail_Help; use Mail_Help;

procedure As1 is

    Number_Of_Clients : Positive := Integer'Value(Argument(1));
    Messages_To_Send : Positive := Integer'Value(Argument(2));

    Manager : Client_Manager(Number_Of_Clients, Messages_To_Send * Number_Of_clients);
    Post_Office : Post_Office_Type(Number_Of_Clients, Number_Of_Clients * Messages_To_send);
    
    task type Client_Task;
    
    task body Client_Task is
        Id, Destination : Mailbox_Id;
        Name : Unbounded_String;
        Message_String : Unbounded_String;
        Message : Message_Type;
        Num_Messages : Natural;
        File : File_Type;
        File_Name : Unbounded_String;
    begin

        Manager.Register(Name, Id);

        -- open log file
        File_Name := Name;
        Append(File_Name, ".log");
        ROpen_Or_Create(File, To_String(File_Name));
        
        for I in 1..Messages_To_Send loop
            delay Duration(Random(1.0));
            
            Message_Manager.Random_Message(Message_String);
            Destination := Manager.Random_Mailbox(Id);

            if Destination > 0 then
                Message := (Name, Message_String);
                Post_Office.Put(Destination, Message);
                Put_Line(Integer'Image(Id) & " sending message...destination " & Integer'Image(Destination));
            end if;
                
            Post_Office.Num_Messages(Id, Num_Messages);
            if Num_Messages > 0 then
                Post_Office.Get(Id, Message);
                Put_Line(File, "From " & To_String(Message.Name) 
                           & ": " & To_String(Message.Message));
                Post_Office.Num_Messages(Id, Num_Messages);
            end if;

        end loop;

        Post_Office.Num_Messages(Id, Num_Messages);
        while Num_Messages > 0 loop
            Post_Office.Get(Id, Message);
            Put_Line(File, "From " & To_String(Message.Name) 
                       & ": " & To_String(Message.Message));
            Post_Office.Num_Messages(Id, Num_Messages);
        end loop;

        Manager.UnRegister(Id);

        Close(File);
        Put_Line("Wrote " & To_String(File_Name));
        
    exception
        when E : others => Put_Line(Exception_Name(E));
        
    end Client_Task;
    
    type Client_Array is array(Positive range <>) of Client_Task;

    Clients : Client_Array(1..Number_Of_clients);
    
begin
    
    null;
    
end As1;

