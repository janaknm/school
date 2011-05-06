with Ada.Strings.Unbounded, Ada.Numerics.Float_Random;
use Ada.Strings.Unbounded, Ada.Numerics.Float_Random;

package Mail_Help is
    
    Messages_Filename : constant String := "messages.txt";
    Names_Filename : constant String := "names.txt";

    Empty_Mailbox : exception;

    
    type Str_Array_Type is array(Positive range <>) of Unbounded_String;
    type Str_Array_Ptr is access Str_Array_Type;
    
    type Message_Type is
       record
           Name : Unbounded_String;
           Message : Unbounded_String;
       end record;

    type Mailbox_Type;
    type Mailbox_Ptr is access Mailbox_Type;

    
    -- Protected mailbox type
    protected type Mailbox_Type(Max_Messages : Positive) is
        
        procedure Put(Message : in Message_Type);
        procedure Get(Message : out Message_Type);
        function Num_Messages return Natural;

    private
        
        package Message_Queue is new Bounded_Queue(Message_Type);
        
        Message_Count : Natural := 0;
        Messages : Message_Queue.Queue_Type(Max_Messages);
        
    end Mailbox_Type;

    

    protected Client_Manager(Max_Clients : Natural) is
        
        function Num_Clients return Natural;
        procedure Random_Mailbox return Mailbox_Ptr;
        procedure Register(Name : out Unbounded_String; 
                           ID : out Natural;
                           Mailbox : out Mailbox_Ptr);
        procedure UnRegister(Id : out Natural);
        
    private

        type Client_Element is
           record
               Mailbox : Mailbox_Ptr;
               Id : Natural;
               Name : Unbounded_String;
               Available : Boolean = False;
           end record;
        type Client_Array is array(Positive range <>) of Client_Element;
        
        procedure Initialize;

        Clients : Client_Array(1..Max_Clients);
        RegisteredClients : Positive := 0;
        Initialized : Boolean := False;
        
    end Client_Manager;


    
    protected Message_Manager is
        function Random_Message return Unbounded_String;
    private
        procedure Initialize;
        
        Gen : Generator;
        Message_Array : Str_Array_Ptr;
        Initialized : Boolean := False;
        Num_Messages : Natural := 0;
        
    end Message_Manager;


    
    -- protected delay object to wrap the random generator and give
    --  access to each task
    protected Random_Manager is
        function Random(Max : Float) return Float;
    private
        Gen : Generator;
        First : Boolean := True;
    end Random_Manager;

    
end Mail_Help;
