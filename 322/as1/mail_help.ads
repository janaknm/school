with Ada.Strings.Unbounded, Ada.Numerics.Float_Random;
use Ada.Strings.Unbounded, Ada.Numerics.Float_Random;

with Bounded_Queue;

package Mail_Help is
    
    Messages_Filename : constant String := "messages.txt";
    Names_Filename : constant String := "names.txt";

    Mailbox_Empty, Mailbox_Full : exception;

    
    type Str_Array_Type is array(Positive range <>) of Unbounded_String;
    type Str_Array_Ptr is access Str_Array_Type;

    procedure Read_String_Array(Str_Array : out Str_Array_Ptr;
                                Count : out Natural;
                                Filename : string);
    
    type Message_Type is
       record
           Name : Unbounded_String;
           Message : Unbounded_String;
       end record;
    
    package Message_Queue is new Bounded_Queue(Message_Type);
    

    type Mailbox_Type;
    type Mailbox_Ptr is access Mailbox_Type;

    
    -- Protected mailbox type
    protected type Mailbox_Type(Max_Messages : Positive) is
        
        procedure Put(Message : in Message_Type);
        procedure Get(Message : out Message_Type);
        function Num_Messages return Natural;

    private
        
        
        Message_Count : Natural := 0;
        Messages : Message_Queue.Queue_Type(Max_Messages);
        
    end Mailbox_Type;

    

    type Client_Element is
           record
               Mailbox : Mailbox_Ptr;
               Id : Natural;
               Name : Unbounded_String;
               Available : Boolean := False;
           end record;
    type Client_Array is array(Positive range <>) of Client_Element;
    
    protected type Client_Manager(Max_Clients : Positive; 
                                  Max_messages : Positive) is
        
        function Num_Clients return Natural;
        function Random_Mailbox(My_ID : in Natural) return Mailbox_Ptr;
        procedure Register(Name : out Unbounded_String; 
                           ID : out Natural;
                           Mailbox : out Mailbox_Ptr);
        procedure UnRegister(Id : in Natural);
        
    private
        
        function Next_Index return Positive;
        
        Clients : Client_Array(1..Max_Clients);
        Registered_Clients : Positive := 0;
        
    end Client_Manager;


    
    protected Message_Manager is
        function Random_Message return Unbounded_String;
    private
        procedure Initialize;
        
        Message_Array : Str_Array_Ptr;
        Initialized : Boolean := False;
        Num_Messages : Natural := 0;
        
    end Message_Manager;


    protected Name_Manager is
        function Next_Name return Unbounded_String;
    private
        procedure Initialize;
        procedure Randomize;

        Names : Str_Array_Ptr;
        Initialized : Boolean := False;
        Num_Names : Natural := 0;
        Current_Index : Positive := 1;
        Suffix : Natural := 0;
        
    end Name_Manager;

    
    function Random(Max : Float) return Float;
    function Int(Max : Natural) return Natural;
    
private

    
end Mail_Help;
