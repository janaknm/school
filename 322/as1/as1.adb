-- Matt Forbes
-- May 2011
-- CS322 - WWU

-- Usage: as1 <clients> <messages>. Spawn <clients> tasks to send
--  <messages> number of messages to each other by transport in
--  "mailboxes"

-- standard includes
with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Numerics.Float_Random; 
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Numerics.Float_Random;

-- local includes
with Bounded_Queue; use Bounded_Queue;

procedure As1 is

    type Message_Type;
    package Message_Queue is new Bounded_Queue(Message_Type);

    Empty_Mailbox : exception;
    
    protected Delay_Manager is
        procedure sleep(Seconds : in Float);
    private
        Gen : Generator;
        First : Boolean := True;
    end Delay_Manager;

    protected body Delay_Manager is
        procedure Sleep(Seconds : in Float) is
        begin
            if First then
                First := False;
                Reset(Gen);
            end if;

            delay duration
        
    
    type Message_Type is
       record
           Name : Unbounded_String;
           Message : Unbounded_String;
       end record;

    -- Protected mailbox type
    protected type Mailbox_Type(Max_Messages : Positive) is
        
        procedure Drop_Message(Message : in Message_Type);
        procedure Take_Message(Message : out Message_Type);
        function Num_Messages;

    private
        
        Message_Count : Natural := 0;
        Message_Queue : Message_Queue.Queue_Type(Max_Messages);
        
    end Mailbox_Type;

    
        
    -- Name Registrar Types
    type Name_Type is 
       record
           Name : Unbounded_String;
           Available : Boolean := True;
       end record;

    type NameArray_Type is array(Positive range <>) of Name_Type;
    type NameArray_Ptr is access NameArray_Type;
    
    -- client registrar allows client to register a name/mailbox, and
    --  also provides a couple utilities.
    protected Client_Registrar is
        
        function Num_Clients;
        procedure Random_Client(Mailbox : out Mailbox_Ptr);
        procedure Register(Name : out Unbounded_String; 
                           Mailbox : out Mailbox_Ptr);
        
    private
        procedure Initialize;
        
        Name_Array : NameArray_Ptr;
        RegisteredClients : Positive := 0;
        
    end Client_Registrar;

    
    
    
    task type Client_Task(Messages_To_send : Positive;
                          Max_Messages : positive);
    
    task body Client_Task is
        Mailbox : Mailbox_Ptr;
        Name : Unbounded_String;
    begin
        
        for I in 1..Messages_To_Send loop
            
        end loop;

    end Client_Task;
    
        
    
end As1;

